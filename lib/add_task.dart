import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _titleController = TextEditingController();
  final _discriptionController = TextEditingController();
  final _databaseRef = FirebaseDatabase.instance.ref("Tasks");

  Future<void> addTask() async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await _databaseRef.child(id).set({
      'title': _titleController.text,
      'description': _discriptionController.text,
      'id': id
    });
    Navigator.pushReplacementNamed(context, '/homeScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Add Task"),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              TextField(
                maxLines: 1,
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: "Task 1...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 5,
                controller: _discriptionController,
                decoration: InputDecoration(
                    hintText: "I have to do....",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white)),
                  onPressed: () {
                    addTask();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      'Add',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
