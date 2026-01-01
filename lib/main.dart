import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'শিবির পিডিএফ ডেমো',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Book {
  final String title;
  final String cover;
  final String pdf;
  final String category;

  Book({
    required this.title,
    required this.cover,
    required this.pdf,
    required this.category,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Book> allBooks = [
    Book(title: 'কর্মী সিলেবাস ১', cover: 'assets/covers/cover1.png', pdf: 'assets/pdfs/book1.pdf', category: 'কর্মী সিলেবাস'),
    Book(title: 'কর্মী সিলেবাস ২', cover: 'assets/covers/cover2.png', pdf: 'assets/pdfs/book2.pdf', category: 'কর্মী সিলেবাস'),
    Book(title: 'সাথী সিলেবাস ১', cover: 'assets/covers/cover3.png', pdf: 'assets/pdfs/book3.pdf', category: 'সাথী সিলেবাস'),
    Book(title: 'সাথী সিলেবাস ২', cover: 'assets/covers/cover4.png', pdf: 'assets/pdfs/book4.pdf', category: 'সাথী সিলেবাস'),
    Book(title: 'দাওয়াহ বই ১', cover: 'assets/covers/cover5.png', pdf: 'assets/pdfs/book5.pdf', category: 'দাওয়াহ'),
    Book(title: 'দাওয়াহ বই ২', cover: 'assets/covers/cover6.png', pdf: 'assets/pdfs/book6.pdf', category: 'দাওয়াহ'),
    Book(title: 'হাদিস সংকলন', cover: 'assets/covers/cover7.png', pdf: 'assets/pdfs/book7.pdf', category: 'দাওয়াহ'),
  ];

  late List<Book> filteredBooks;

  final List<String> categories = ['কর্মী সিলেবাস', 'সাথী সিলেবাস', 'দাওয়াহ'];

  @override
  void initState() {
    super.initState();
    filteredBooks = allBooks;
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        filteredBooks = allBooks.where((book) =>
            book.title.toLowerCase().contains(_searchQuery) ||
            book.category.toLowerCase().contains(_searchQuery)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('শিবির বই সম্ভার'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'বই বা ক্যাটাগরি সার্চ করুন...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryBooks = filteredBooks.where((book) => book.category == category).toList();
                if (categoryBooks.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoryBooks.length,
                        itemBuilder: (context, bookIndex) {
                          final book = categoryBooks[bookIndex];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfViewerPage(pdfPath: book.pdf, title: book.title),
                                ),
                              );
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      book.cover,
                                      height: 210,
                                      width: 160,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 210,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.book, size: 60, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    book.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;
  final String title;

  const PdfViewerPage({super.key, required this.pdfPath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green[700],
      ),
      body: PdfView(
        documentLoader: const Center(child: CircularProgressIndicator()),
        errorLoader: const Center(child: Text('PDF লোড হয়নি', style: TextStyle(fontSize: 18))),
        document: PdfDocument.openAsset(pdfPath),
      ),
    );
  }
}
