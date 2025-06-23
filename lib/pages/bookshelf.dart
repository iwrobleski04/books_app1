import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:books_app1/main.dart';
import 'shelf.dart';

// main page that displays all of the book lists and their numbers of books
// when each of the inkwells are tapped, they navigate to the corresponding shelf page and pass the corresponding methods and title
class Bookshelf extends StatelessWidget {
  const Bookshelf({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);

    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Shelf(
                  title: "Want to Read",
                  onDelete: appState.removeFromWantToRead,
                  onAdd: appState.addToWantToRead
                ),
              ),
            );
          },
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text("Want to Read", style: const TextStyle(fontSize: 18)),
                const Spacer(),
                Text(appState.wantToRead.length.toString(), style: const TextStyle(fontSize: 16))
              ],
            ),
          )
        ), 
        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1.5,
          height: 1.0,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Shelf(
                  title: "Reading",
                  onDelete: appState.removeFromReading,
                  onAdd: appState.addToReading
                ),
              ),
            );
          },
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text("Reading", style: const TextStyle(fontSize: 18)),
                const Spacer(),
                Text(appState.reading.length.toString(), style: const TextStyle(fontSize: 16))
              ],
            ),
          )
        ), 
        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1.5,
          height: 1.0,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Shelf(
                  title: "Read",
                  onDelete: appState.removeFromRead,
                  onAdd: appState.addToRead
                ),
              ),
            );
          },
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text("Read", style: const TextStyle(fontSize: 18)),
                const Spacer(),
                Text(appState.read.length.toString(), style: const TextStyle(fontSize: 16))
              ],
            ),
          )
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1.5,
          height: 1.0,
        ),
      ]
    );
  }
}