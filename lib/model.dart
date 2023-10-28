import 'sql.dart';

class AvailableBooks {
  int? id;
  late String bookTitle;
  late String bookAuthor;
  late String bookCoverURL;

  AvailableBooks({
    this.id,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCoverURL,
  });

  AvailableBooks.fromMap(Map<String, dynamic> map) {
    if (map[columnId] != null) id = map[columnId];
    bookTitle = map[columnTitle];
    bookAuthor = map[columnAuthor]; // تعديل هنا لتعيين قيمة لـ bookAuthor
    bookCoverURL = map[columnURL]; // تعديل هنا لتعيين قيمة لـ bookCoverURL
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnTitle] = bookTitle;
    map[columnAuthor] = bookAuthor;
    map[columnURL] = bookCoverURL;

    return map;
  }
}