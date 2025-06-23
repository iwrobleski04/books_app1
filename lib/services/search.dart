import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:books_app1/models/book.dart';

// search service
// will return a list of books (future)
// takes the query
Future<List<Book>> searchBooks (String query) async {

  // variable for url and to get response
  final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}');
  final response = await http.get(url);

  // if successful, parse (extract the information) from each book that it returns
  // and return the list of book objects for the user to see
  // set the field values for each book to their corresponding information
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<Book> books = [];
    if (data['items'] != null) {
      for (var item in data['items']) {
        final volumeInfo = item['volumeInfo'];
        books.add(Book(
          title: volumeInfo['title'] ?? 'No Title',
          author: (volumeInfo['authors'] != null) ? (volumeInfo['authors'] as List).join(', ') : 'Unknown',
          imageUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',
          description: volumeInfo['description'] ?? '',
        ));
      }
    }
    return books;
  } else {
    throw Exception('Failed to load books');
  }
}