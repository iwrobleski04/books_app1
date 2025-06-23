import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:books_app1/models/book.dart';

class ReviewEditor extends StatelessWidget {

  final Book book;
  final TextEditingController controller;

  const ReviewEditor({
    super.key,
    required this.book,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // this should just be a column
    // on the edit page it wil be a scaffold with the appbar and the text and th
    return Column(
      children: [
        SizedBox(height: 16),
        Text("Rating:", style: const TextStyle(fontSize: 16)),
        RatingBar(
          allowHalfRating: true,
          initialRating: (book.reviewRating ?? 0),
          onRatingUpdate: (double newRating) {
            book.reviewRating = newRating;
          },
          minRating: 0.5,
          ratingWidget: RatingWidget(
            full: Icon(Icons.star, color: Theme.of(context).colorScheme.primary), 
            half: Icon(Icons.star_half, color: Theme.of(context).colorScheme.primary), 
            empty: Icon(Icons.star_outline, color: Theme.of(context).colorScheme.primary)
          )
        ),
        const SizedBox(height: 16),
        Text("Review:", style: const TextStyle(fontSize: 16)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controller,
              minLines: null,
              maxLines: null,
              expands: true, 
              textAlignVertical: TextAlignVertical.top, // if there is already a review the controller should start as being that text
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: OutlineInputBorder(), 
                contentPadding: EdgeInsets.all(16),
                hintText: book.reviewText.isEmpty ? "Write a Review..." : null)
            ),
          ),
        ),
      ]
    );
  }
}