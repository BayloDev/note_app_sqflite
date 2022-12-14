// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:notes_app/home_page.dart';
import 'package:notes_app/sql_func.dart';

class EditNotesPage extends StatefulWidget {
  const EditNotesPage({super.key, this.title, this.note, this.id, this.color});
  final id;
  final title;
  final note;
  final color;
  @override
  State<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  SqlFunctions sql = SqlFunctions();

  final title = TextEditingController();
  final note = TextEditingController();
  final color = TextEditingController();
  @override
  void initState() {
    title.text = widget.title;
    note.text = widget.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text('Edit Note'),
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Edit this Note',
                      style: TextStyle(
                        fontSize: 25,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: title,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Title',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 4,
                        ),
                        prefixIcon: const Icon(Icons.title_sharp),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Title must not be null';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: note,
                      maxLines: 4,
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                        hintText: 'Note',
                        labelText: 'Note',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 4,
                        ),
                        prefixIcon: const Icon(Icons.note_add_outlined),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Note must not be null';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: color,
                      maxLines: 1,
                      cursorColor: Colors.deepOrange,
                      decoration: InputDecoration(
                        hintText: 'Color',
                        labelText: 'Color',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          gapPadding: 4,
                        ),
                        prefixIcon: const Icon(Icons.colorize_outlined),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Color must not be null';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: saveData,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange),
                      ),
                      child: const Text(
                        'Edit Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveData() async {
    if (formKey.currentState!.validate()) {
      int response = await sql.updateData('''
          UPDATE notes SET 
          title = "${title.text}",
          note = "${note.text}",
          color = "${color.text}"
          WHERE id = ${widget.id}
        ''');
      if (response > 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      }
    }
  }
}
