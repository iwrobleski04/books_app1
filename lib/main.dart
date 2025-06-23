import 'package:flutter/material.dart';
import 'package:books_app1/models/book.dart';
import 'package:provider/provider.dart';
import 'package:books_app1/pages/bookshelf.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:books_app1/pages/searchpage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue.shade200),
      ),
      home: const MyHomePage(title: "Books"),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var wantToRead = <Book>[];
  var reading = <Book>[];
  var read = <Book>[];

  // methods to add to shelves and remove from shelves
  // removes from other shelves since a book cannot be on more than one at once
  // if a book is added to or removed from reading, add the current date to the dates list
  void addToWantToRead(Book book) {
    if (reading.contains(book)) removeFromReading(book);
    if (read.contains(book)) removeFromRead(book);
    if (!wantToRead.contains(book)) wantToRead.add(book);
    notifyListeners();
  }
  void addToReading(Book book) {
    if (wantToRead.contains(book)) removeFromWantToRead(book);
    if (read.contains(book)) removeFromRead(book);
    if (!reading.contains(book)) reading.add(book);
      book.dates.add(DateTime.now());
      book.dates.sort((a, b) => a.compareTo(b));
    notifyListeners();
  }
  void addToRead(Book book) {
    if (wantToRead.contains(book)) removeFromWantToRead(book);
    if (reading.contains(book)) {
      removeFromReading(book);
      book.dates.add(DateTime.now());
      book.dates.sort((a, b) => a.compareTo(b));
    }
    if (!read.contains(book)) read.add(book);
    notifyListeners();
  }
  void removeFromWantToRead(Book book) {
    wantToRead.remove(book);
    notifyListeners();
  }
  void removeFromReading(Book book) {
    reading.remove(book);
    notifyListeners();
  }
  void removeFromRead(Book book) {
    read.remove(book);
    notifyListeners();
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // page and title options with corresponding index variable
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[Bookshelf(), SearchPage()];
  static final List<String> _titles = <String>["Bookshelf", "Search"];

  // changes selectedIndex to the index chosen
  void _onItemTapped(int index) {
    setState(() {
    _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: "Bookshelf"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search")
        ]
      ),
    );
  }
} 

