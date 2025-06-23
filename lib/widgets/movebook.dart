import 'package:flutter/material.dart';
import 'package:books_app1/models/book.dart';
import 'package:books_app1/main.dart';
import 'package:provider/provider.dart';

// widget to move book to a new shelf
class MoveBook extends StatelessWidget {

  final String currentShelf;
  final Book book;

  const MoveBook({
    super.key,
    required this.currentShelf,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {

    final appState = Provider.of<MyAppState>(context);
    List<Widget> options = [];

    // add all other shelves except the current one to the options list
    if (currentShelf != "Want to Read") {
      options.add(
        ListTile(
          leading: (currentShelf != "") ? Icon(Icons.swap_vert_outlined) : Icon(Icons.add),
          title: (currentShelf != "") ? const Text("Move to Want to Read") : const Text("Add to Want to Read"),
          onTap: () {
            appState.addToWantToRead(book);
            Navigator.pop(context);
          },
        ),
      );
    }

    if (currentShelf != "Reading") {
        options.add(
          ListTile(
            leading: (currentShelf != "") ? const Icon(Icons.auto_stories) : const Icon(Icons.add),
            title: const Text("Start Reading"),
            onTap: () {
              appState.addToReading(book);
              Navigator.pop(context);
            },
          ),
        );
    }

    if (currentShelf != "Read") {
      options.add(
        ListTile(
          leading: currentShelf == "Want to Read" ? const Icon(Icons.swap_vert_outlined) 
                : currentShelf == "Reading" ? const Icon(Icons.book)
                : Icon(Icons.add),
          title: currentShelf == "Want to Read" ? const Text("Move to Read") 
                : currentShelf == "Reading" ? const Text("Finish Reading")
                : const Text("Add to Read"),
          onTap: () {
            appState.addToRead(book);
            Navigator.pop(context);
          },
        ),
      );
    }

    // display the options
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24, top: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
        ),
      ),
    );

  }

}