import 'package:flutter/material.dart';
import 'model.dart';
import 'sql.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AvailableBooks> booksList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Books',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TextEditingController titleInput = TextEditingController();
          TextEditingController authorInput = TextEditingController();
          TextEditingController urlInput = TextEditingController();
          await showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  height: 250,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: titleInput,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Book Title',
                          ),
                        ),
                        TextField(
                          controller: authorInput,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Book Author',
                          ),
                        ),
                        TextField(
                          controller: urlInput,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(),
                            hintText: 'Book Cover URL',
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 500,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Sql.instance.insertBook(
                                AvailableBooks(
                                  bookTitle: titleInput.text,
                                  bookAuthor: authorInput.text,
                                  bookCoverURL: urlInput.text,
                                ),
                              );
                              print(booksList);
                              Navigator.pop(context);
                              setState(() {

                              });
                            },
                            child: const Text(
                              'ADD',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<AvailableBooks>>(
        future: Sql.instance.getAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            booksList = snapshot.data!;
            return ListView.builder(
              itemCount: booksList.length,
              itemBuilder: (context, index) {
                AvailableBooks book = booksList[index];
                return Card(
                  margin: const EdgeInsets.all(6),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(book.bookCoverURL),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(

                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.bookTitle,style: TextStyle(fontSize: 20),),
                              const SizedBox(height: 10),
                              Text(book.bookAuthor,style: TextStyle(color: Color(0xFF6F6F6F),fontSize: 15),),
                            ],
                          ),
                        ),
                      //  const SizedBox(width:1),
                        IconButton(
                          iconSize: 30,
                          icon: const Icon(Icons.delete_forever_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Book'),
                                  content: const Text(
                                      'Are you sure you want to delete this book?'),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        Sql.instance.deleteBook(book.id!);
                                        Navigator.of(context).pop();
                                        setState(() {
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}