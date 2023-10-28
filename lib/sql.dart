import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model.dart';

final String columnId = 'id';
final String columnTitle = 'title';
final String columnAuthor = 'author';
final String columnURL = 'url';
final String bookTabel = 'book_tabel';
class Sql {
  late Database db;

  static final Sql instance = Sql._internal();

  factory Sql() {
    return instance;
  }

  Sql._internal();


  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'books.db'),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute('''
CREATE TABLE  $bookTabel ( 
  $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
  $columnTitle TEXT NOT NULL,
  $columnAuthor TEXT NOT NULL,
  $columnURL TEXT NOT NULL
  )
''');
        });
  }

  Future<AvailableBooks> insertBook(AvailableBooks books) async {
    books.id = await db.insert(bookTabel, books.toMap());
    return books;
  }
  Future<int> updateBooks(AvailableBooks books) async {
    return await db.update(bookTabel, books.toMap(),
        where: '$columnId = ?', whereArgs: [books.id]);
  }

  Future<int> deleteBook(int id) async {
    return await db.delete(bookTabel, where: '$columnId = ?', whereArgs: [id]);
  }






  Future<List<AvailableBooks>> getAllBooks() async {
    List<Map<String, dynamic>> booksMaps = await db.query(bookTabel);
    if (booksMaps.length == 0)
      return [];
    else {
      List<AvailableBooks> books = [];
      for (var element in booksMaps) {
        books.add(AvailableBooks.fromMap(element));
      }
      return books;
    }
  }

  Future close() async => db.close();
}
