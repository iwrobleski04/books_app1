import 'dart:async';
import 'package:flutter/material.dart';
import 'package:books_app1/models/book.dart';
import 'package:books_app1/services/search.dart';

// book search widget
class BookSearch extends StatefulWidget {
  final Function(Book) onBookSelected;
  final bool popOnSelect;
  final bool expand;

  const BookSearch({super.key, required this.onBookSelected, required this.popOnSelect, this.expand=false});

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _results = [];
  bool _isLoading = false;
  String? _error;
  Timer? _debounce;

  // method to ensure search only goes through if the user stops typing 
  // if the user is still typing but the timer is active, cancel the timer
  // otherwise, start a new timer, and run the search method with the query if the timer is up
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _search(query);
    });
  }

  // overriding dispose to cancel the active itmer when the book search widget is disposed
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _search(String query) async {
    // if there is no query, there are no results but no error
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
      });
      return;
    }
    // if the query is not empty, the search is loading and there is no error 
    setState(() {
      _error = null;
      _isLoading = true;
    });
    // try to use the search service with the query to get results
    // then set the results and stop loading
    try {
      final books = await searchBooks(query);
      setState(() {
        _results = books;
        _isLoading = false;
      });
    } catch (e) {
      // if there is any error, stop loading and display the error text
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
          children: [
            // search bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search for a book...",
                border: OutlineInputBorder(),
               ),
               // when the text in the search bar is changed, call onChanged to decide whether to search or restart the timer
               onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),
            // show loading sign if loading
            // if there is an error, display it in red text
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null) SelectableText(_error!, style: const TextStyle(color: Colors.red)),
            // if the search is not loading and there are results, display them
            if (!_isLoading && _results.isNotEmpty)
              widget.expand ? 
              Expanded(
                child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final book = _results[index];
                      return ListTile(
                        leading: book.imageUrl.isNotEmpty ? Image.network(book.imageUrl, width:40, fit: BoxFit.contain) : const Icon(Icons.book, size: 40),
                        title: Text(book.title),
                          subtitle: Text(book.author),
                        onTap: () {
                          widget.onBookSelected(book);
                          if (widget.popOnSelect) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                ),
              )
              // if expand is false, shrinkwrap and use flexible
              : Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final book = _results[index];
                      return ListTile(
                        leading: book.imageUrl.isNotEmpty ? Image.network(book.imageUrl, width:40, fit: BoxFit.contain) : const Icon(Icons.book, size: 40),
                        title: Text(book.title),
                          subtitle: Text(book.author),
                        onTap: () {
                          widget.onBookSelected(book);
                          if (widget.popOnSelect) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                ),
              )
          ],
        ),
    );
  }
}