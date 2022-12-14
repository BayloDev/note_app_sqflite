// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notes_app/add_notes.dart';
import 'package:notes_app/edit_notes.dart';
import 'package:notes_app/sql_func.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> navKey = GlobalKey();

  final SqlFunctions sqlDb = SqlFunctions();

  List notes = [];

  bool isLoading = true;

  Future readData() async {
    List<Map> response = await sqlDb.readData('SELECT * FROM notes');
    notes.addAll(response);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notes App'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddNotesPage(),
          )),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              )
            : Container(
                color: Colors.black12,
                child: ListView(
                  children: [
                    ListView.builder(
                      itemCount: notes.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text('${notes[index]['title']}'),
                            subtitle: Text('${notes[index]['note']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditNotesPage(
                                          id: notes[index]['id'],
                                          title: notes[index]['title'],
                                          note: notes[index]['note'],
                                          color: notes[index]['color'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    var response = await sqlDb.deleteData(
                                        'DELETE FROM notes WHERE id = ${notes[index]['id']}');
                                    if (response > 0) {
                                      notes.removeWhere(
                                        (element) =>
                                            element['id'] == notes[index]['id'],
                                      );
                                      setState(() {});
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ), //   child: CircularProgressIndicator(),
                  ],
                ),
              ),
      ),
    );
  }
}
