import 'package:flutter/material.dart';
import 'package:books_app1/widgets/booksearch.dart';
import 'package:books_app1/pages/bookinfopage.dart';
import 'package:books_app1/models/book.dart';

// page to search for a book and view its details
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();

}

class _SearchPageState extends State<SearchPage> {

  // method to navigate to the book info page of the corresponding book from the search page
  // this will be used as onBookSelected with the search widget
  void moveToBookPage(Book book) {
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookInfoPage(book: book))
    );
  }

  // returns scaffold with search widget
  // popOnSelect is false because we do not want to leave the search page when selecting a book
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookSearch(onBookSelected: moveToBookPage, popOnSelect: false, expand: true)
    );
  }
}