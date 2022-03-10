import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/create_tasks.dart';
import '../models/data_base_helper.dart';
import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  Widget listItem(Task task) {
    return Container(
      color: Colors.lightGreenAccent,
      margin: const EdgeInsets.fromLTRB(2, 0, 2, 8),
      child: ListTile(
        leading: const Icon(Icons.edit),
        trailing: Checkbox(
          onChanged: (val) {},
          value: true,
        ),
        title: Text(
          task.title!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(task.time.toString()),
      ),
    );
  }

  _initDb() async {
    DatabaseHelper db = DatabaseHelper();
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    db.open(path);
    tasks = await db.getTaskList();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CreateTask()));
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              const Text(
                "MY TASKS",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return listItem(tasks[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}