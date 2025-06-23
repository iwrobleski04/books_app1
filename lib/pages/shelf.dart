import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:books_app1/main.dart';
import 'package:books_app1/models/book.dart';
import 'bookinfopage.dart';
import 'package:books_app1/widgets/booksearch.dart';
import 'package:books_app1/widgets/movebook.dart';

// shelf page
class Shelf extends StatelessWidget {
  final String title;
  final Function(Book) onDelete;
  final Function(Book) onAdd;

  const Shelf({
    super.key,
    required this.title,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<MyAppState>(context);
    final books = (title == "Want to Read") ? appState.wantToRead :
                  (title == "Reading") ? appState.reading :
                  appState.read;

    // if there are no books in the corresponding list, display text
    // also display floating action button to add with popup modal to search
    if (books.isEmpty) {
      return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Align(
        alignment: Alignment.center,
        child: 
          Text(
        "No books in $title yet.",
        textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return BookSearch(
                    onBookSelected: (book) {onAdd(book);
                    },
                    popOnSelect: true
              );
            },
          );
        },
        child: const Icon(Icons.add)
      ),
    );
    }

    // if there are books in the list, return a listview of the books
    // each book has buttons to move it to one of the other lists and delete it from the list
    // when the book is tapped, navigate to its info page
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              leading: book.imageUrl.isNotEmpty ? Image.network(book.imageUrl, width:40, fit: BoxFit.contain) : const Icon(Icons.book, size: 40),
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_location_alt),
                    onPressed:() {
                      showModalBottomSheet(
                        context: context, 
                        builder: (context) {
                          return MoveBook(book: book, currentShelf: title);
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      onDelete(book);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => BookInfoPage(book: book),
                  ) 
                );
              },
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BookSearch(
                    onBookSelected: (book) {onAdd(book);
                    },
                    popOnSelect: true
              );
            },
          );
        },
        child: const Icon(Icons.add)
      ),
    );
  }

}

