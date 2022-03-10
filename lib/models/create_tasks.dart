import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_tasks/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'data_base_helper.dart';

class CreateTask extends StatefulWidget {
  CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  String? _title = "";

  String? _description = "";

  DateTime _date = DateTime.now();

  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _showDatePick(BuildContext context) async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2022),
        lastDate: DateTime(2100));

    if (date != _date) {
      setState(() {
        _date = date as DateTime;
      });

      _controller.text = date.toString();
    }
  }

  _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      Task task = Task(_title, _description, _date);

      DatabaseHelper db = DatabaseHelper();
      Directory dir = await getApplicationDocumentsDirectory();
      String path = dir.path + 'todo_list.db';
      db.open(path);
      db.insert(task);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(label: Text("Title")),
                      onSaved: (value) => _title = value,
                    ),
                    TextFormField(
                      decoration:
                      const InputDecoration(label: Text("Description")),
                      onSaved: (value) => _description = value,
                    ),
                    TextFormField(
                      controller: _controller,
                      onTap: () {
                        _showDatePick(context);
                      },
                      decoration: const InputDecoration(label: Text("Date")),
                      onSaved: (value) => _date = DateTime.now(),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    _save();
                  },
                  child: const Text("SAVE"))
            ],
          ),
        ),
      ),
    );
  }
}