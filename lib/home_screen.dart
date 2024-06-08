import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dbRef = FirebaseDatabase.instance.ref('Tasks');
  final _editController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/addTask');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 120),
              child: Text("Notes List"),
            ),
            InkWell(
                onTap: () {
                  signoutUser();
                },
                child: const Icon(Icons.logout))
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _dbRef.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Container(
                    height: 50,
                    width: 50,
                    child: const CircularProgressIndicator(),
                  ));
                } else {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: ListTile(
                          selectedColor: Colors.amber,
                          title: Text(
                            list[index]['title'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            list[index]['description'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          trailing: PopupMenuButton(
                            child: const Icon(Icons.more_vert),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        showMyDialog(list[index]['description'],
                                            list[index]['id']);
                                      },
                                      title: const Text("Edit"),
                                      leading: const Icon(Icons.edit),
                                    )),
                                PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        _dbRef
                                            .child(list[index]['id'])
                                            .remove();
                                        Navigator.pop(context);
                                      },
                                      title: const Text("Delete"),
                                      leading: const Icon(Icons.delete),
                                    ))
                              ];
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> showMyDialog(String data, String id) async {
    _editController.text = data;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: TextField(
            controller: _editController,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  _dbRef
                      .child(id)
                      .update({'description': _editController.text.toString()});
                  Navigator.pop(context);
                },
                child: const Text("Update")),
          ],
        );
      },
    );
  }

  Future<void> signoutUser() async {
    await _auth.signOut().then(
      (value) {
        Navigator.pushReplacementNamed(context, '/loginScreen');
      },
    );
  }
}
