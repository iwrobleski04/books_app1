import 'package:flutter/material.dart';
import 'package:books_app1/widgets/review.dart';
import 'package:books_app1/models/book.dart';

class EditReviewPage extends StatefulWidget {
  final Book book;

  const EditReviewPage({super.key, required this.book});

  @override
  State<EditReviewPage> createState() => _EditReviewPageState();

}

class _EditReviewPageState extends State<EditReviewPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.book.reviewText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.book.reviewText.isEmpty ? "Add Review" : "Edit Review")),
      body: ReviewEditor(
        controller: _controller,
        book: widget.book
      ),
      bottomNavigationBar:
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 28),
          child: Row(
            children: [
              Expanded(child: SizedBox()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Save", 
                  style: TextStyle(
                    fontSize: 16, 
                    color: Theme.of(context).colorScheme.onPrimary
                  )
                ),
                onPressed:() {
                  setState(() {
                    widget.book.reviewText = _controller.text;
                  });
                  Navigator.pop(context);
                },
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
    );

  }



}