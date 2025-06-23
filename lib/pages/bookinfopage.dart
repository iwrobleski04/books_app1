import 'package:flutter/material.dart';
import 'package:books_app1/models/book.dart';
import 'package:books_app1/main.dart';
import 'package:provider/provider.dart';
import 'package:books_app1/widgets/movebook.dart';
import 'package:intl/intl.dart';
import 'package:books_app1/pages/editreview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookInfoPage extends StatefulWidget {
  final Book book;
  const BookInfoPage({super.key, required this.book});

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

// page with book details and review
class _BookInfoPageState extends State<BookInfoPage> {

  // flag to show full book description 
  bool _showFullDescription = false;
  bool _showFullReview = false;

  // method to show the sheet to edit date range
  // takes original start and end indices
  // it will always take a start index, end is optional if book has not been finished
  Future<void> _showEditDateRangeSheet(int startIndex, int? endIndex) async {

    // choose start date
    DateTime startDate = widget.book.dates[startIndex];
    DateTime? newStart = await showDatePicker(
      context: context,
      initialDate: startDate, // initial date is original start date (date at startIndex)
      firstDate: DateTime(2000),  // calendar will go back to 2000
      lastDate: endIndex != null ? widget.book.dates[endIndex] : DateTime.now(),  // last date will be the original end date or the current date
      helpText: "Edit Start Date"
    );
    if (newStart == null || !mounted) return;

    // choose end date if an index is provided
    DateTime? newEnd;
    if (endIndex != null) {
      DateTime endDate = widget.book.dates[endIndex];
      newEnd = await showDatePicker(
        context: context,
        initialDate: endDate, // initial date is the original end date (date at endIndex) 
        firstDate: newStart,  // calendar goes back to the start date that was just chosen
        lastDate: DateTime.now(), // calendar goes up to the current date
        helpText: "Edit End Date"
      );
    if (newEnd == null || !mounted) return;
    }

    // change the dates
    setState(() {
      widget.book.dates[startIndex] = newStart; // set the date at startIndex to the new start date
      if (endIndex != null && newEnd != null) { // set the date at endIndex to the new end date if applicable
        widget.book.dates[endIndex] = newEnd;
      }
      widget.book.dates.sort((a, b) => a.compareTo(b)); // sort the list of dates so they appear in chronological order when displayed
    });

  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    var currentShelf = 
      appState.reading.contains(widget.book) ? "Reading" :
      appState.wantToRead.contains(widget.book) ? "Want to Read" :
      appState.read.contains(widget.book) ? "Read" : "";

    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // display cover image
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, left: 16.0),
                  child: SizedBox (
                    width: 100,
                    height: 150,
                    child: widget.book.imageUrl.isNotEmpty ? Image.network(widget.book.imageUrl, fit: BoxFit.contain) : const Icon(Icons.book, size: 100),
                  ),
                ),
                // display title and author
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8),
                            child: Text(
                              widget.book.title,
                              style: const TextStyle(fontSize: 20),
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 8),
                            child: Text(
                              widget.book.author,
                              style: const TextStyle(fontSize: 16),
                              softWrap: true,
                            ),
                          ),
                          const SizedBox(height: 4),  
                          // display button showing the shelf the book is in
                          // with icon button to change the shelf or add it to a shelf if it is not in one
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // container with the current shelf or "add to shelf"
                                Container(
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  alignment: Alignment.center,
                                  child: Text(
                                    currentShelf != "" ? "  $currentShelf" : "  Add to Shelf",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                // container with icon button to change the current shelf or add to a shelf
                                Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child:
                                    IconButton(
                                      icon: currentShelf != "" ? Icon(Icons.arrow_drop_down) : Icon(Icons.add),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                        iconSize: 18,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        tooltip: currentShelf != "" ? "Change Shelf" : "Add to Shelf",
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context, 
                                            builder: (context) {
                                              return MoveBook(book: widget.book, currentShelf: currentShelf);
                                            }
                                          );
                                        },
                                    )
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (widget.book.dates.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // if the list of dates is not empty, display them
                                  // pairs of dates will be next to each other in the list, so if the index is odd, the date is an end date and has a start date before it
                                  // if the index is even, display it only if it is the last date in the list, as this means it does not have an end date to go with it
                                  // next to each date is a button to edit it followed by a button to delete it
                                  for (var dt in widget.book.dates.asMap().entries)
                                    if (dt.key.isOdd)
                                      Row(
                                        children: [
                                            Expanded(
                                              child: Text(
                                                "Read ${DateFormat.yMMMd().format(widget.book.dates[dt.key - 1].toLocal())} - ${DateFormat.yMMMd().format(dt.value.toLocal())}",
                                                overflow: TextOverflow.ellipsis                                                
                                              ),
                                            ),
                                            SizedBox(
                                              height: 22,
                                              child: IconButton(
                                                icon: const Icon(Icons.edit),
                                                tooltip: "Edit dates",
                                                iconSize: 14,
                                                visualDensity: VisualDensity.compact,
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  _showEditDateRangeSheet(dt.key-1, dt.key);
                                                  }
                                              ),
                                            ),
                                            SizedBox(
                                              height: 22,
                                              child: IconButton(
                                                icon: Icon(Icons.close),
                                                tooltip: "Remove dates",
                                                iconSize: 14,
                                                visualDensity: VisualDensity.compact,
                                                padding: EdgeInsets.only(right: 16),
                                                onPressed: () {
                                                  setState(() {
                                                    widget.book.dates.removeAt(dt.key);
                                                    widget.book.dates.removeAt(dt.key-1);
                                                  });
                                                }
                                              ),
                                            )
                                        ],
                                      )
                                    else if (dt.key == widget.book.dates.length - 1 && dt.key.isEven)
                                      Row(
                                        children: [
                                            Expanded(
                                              child: Text(
                                                "Started Reading ${DateFormat.yMMMd().format(dt.value.toLocal())}",
                                                overflow: TextOverflow.ellipsis                                                
                                              ),
                                            ),
                                            SizedBox(
                                              height: 22,
                                              child: IconButton(
                                                icon: const Icon(Icons.edit),
                                                tooltip: "Edit date",
                                                iconSize: 14,
                                                visualDensity: VisualDensity.compact,
                                                padding: EdgeInsets.only(right: 16),
                                                onPressed: () {
                                                  _showEditDateRangeSheet(dt.key, null);
                                                  }
                                              ),
                                            ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                        ]
                      ),
                    ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                // display book description
                // if the book description is too long, display 10 lines and show full description button
                // if show full description is on, display hide full description button
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.description,
                    style: const TextStyle(fontSize: 14),
                    softWrap: true,
                    overflow: _showFullDescription ? TextOverflow.visible : TextOverflow.ellipsis,  // ellipsis if full description is not on
                    maxLines: _showFullDescription ? null : 10, // 10 lines if full description is not on
                    textAlign: TextAlign.justify,
                  ),
                  if (widget.book.description.length > 450) // estimated length for book description longer than 10 lines
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(_showFullDescription ? Icons.arrow_drop_up : Icons.arrow_drop_down,),
                        onPressed: () {
                          setState(() {
                            _showFullDescription = !_showFullDescription;
                          });
                        },
                      ),
                    ),
                  ]
                ),
              ),
            // dividing line
            Divider(
              thickness: 2,
              indent: 16,
              endIndent: 16,
            ),
            // display review
            // if there is no review, display button to add a review
            // if there is a review, display button to edit
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  if (widget.book.reviewRating != 0)
                    Column(
                      children: [
                        Text(
                          "My Rating:",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center
                        ),
                        const SizedBox(height: 4),
                        RatingBarIndicator(
                          rating: widget.book.reviewRating ?? 0,
                          itemBuilder:(context, index) => Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                          itemSize: 26
                        ),
                        const SizedBox(height: 16)
                      ]
                    ),
                  if (widget.book.reviewText.isEmpty )
                    const Text(
                      'No Review Yet.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  if (widget.book.reviewText.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          "My Review:",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.book.reviewText,
                          style: const TextStyle(fontSize: 14),
                          softWrap: true,
                          overflow: _showFullReview ? TextOverflow.visible : TextOverflow.ellipsis,
                          maxLines: _showFullReview ? null : 10, 
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16)
                      ],
                    ),
                  if (widget.book.reviewText.length > 450)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(_showFullReview ? Icons.arrow_drop_up : Icons.arrow_drop_down,),
                        onPressed: () {
                          setState(() {
                            _showFullReview = !_showFullReview;
                          });
                        },
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                    child: Text( 
                      (widget.book.reviewText.isEmpty ? "Add a Review" : "Edit Review"),
                      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditReviewPage(book: widget.book))
                      );
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}