class Book {

  // variables
  // review text and rating can be null
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  String reviewText;
  double? reviewRating;
  final List<DateTime> dates;

  // constructor
  // if the dates list is null it will be initialized as an empty list
  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    this.reviewText = "",
    this.reviewRating,
    List<DateTime>? dates,
  })
    : dates = dates ?? <DateTime>[];

  // overriding the == operator
  // so any two books with the same field values are equal
  @override
  bool operator == (Object other) =>
    identical(this, other) ||
    other is Book &&
        runtimeType == other.runtimeType &&
        title == other.title &&
        author == other.author &&
        imageUrl == other.imageUrl &&
        description == other.description;

  // overriding hashcode getter
  // so two books with the same field values get the same hash code
  @override
  int get hashCode =>
    title.hashCode ^ author.hashCode ^ imageUrl.hashCode ^ description.hashCode;
  
}