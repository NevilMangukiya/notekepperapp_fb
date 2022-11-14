import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helper/firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle mystyle = TextStyle(color: Colors.white);
  final GlobalKey<FormState> insertKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  TextEditingController topicNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? topicName;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Note Kepper"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.selectRecords(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;

            List<QueryDocumentSnapshot> docus = data!.docs;
            return ListView.builder(
              itemCount: docus.length,
              itemBuilder: (context, i) {
                return Card(
                  color: Colors.black,
                  shadowColor: Colors.white,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  elevation: 3,
                  child: ListTile(
                      isThreeLine: true,
                      leading: Text(
                        "${i + 1}",
                        style: mystyle,
                      ),
                      title: Text(
                        "${docus[i]['topicName']}",
                        style: mystyle,
                      ),
                      subtitle: Text(
                        "${docus[i]['description']}",
                        style: mystyle,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Update Records"),
                                    content: Form(
                                      key: updateKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            validator: (val) {
                                              (val!.isEmpty)
                                                  ? "Enter TopicName First..."
                                                  : null;
                                            },
                                            onSaved: (val) {
                                              topicName = val;
                                            },
                                            controller: topicNameController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText:
                                                    "Enter TopicName Here....",
                                                labelText: "TopicName"),
                                          ),
                                          const SizedBox(height: 10),

                                          // TODO: CITY

                                          TextFormField(
                                            maxLines: 5,
                                            validator: (val) {
                                              (val!.isEmpty)
                                                  ? "Enter description First..."
                                                  : null;
                                            },
                                            onSaved: (val) {
                                              description = val;
                                            },
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText:
                                                    "Enter description Here....",
                                                labelText: "description"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: const Text("Update"),
                                        onPressed: () {
                                          if (updateKey.currentState!
                                              .validate()) {
                                            updateKey.currentState!.save();

                                            Map<String, dynamic> data = {
                                              'topicName': topicName,
                                              'description': description,
                                            };
                                            FirestoreHelper.firestoreHelper
                                                .updateRecords(
                                                    id: docus[i].id,
                                                    data: data);
                                          }
                                          topicNameController.clear();

                                          descriptionController.clear();

                                          topicName = "";
                                          description = "";
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      OutlinedButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          topicNameController.clear();
                                          descriptionController.clear();

                                          topicName = null;

                                          description = null;

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          IconButton(
                              onPressed: () {
                                deleteData(id: docus[i].id);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      )),
                );
              },
            );
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          validateAndInsertRecords();
        },
      ),
    );
  }

  validateAndInsertRecords() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Insert Records"),
        content: Form(
          key: insertKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (val) {
                  (val!.isEmpty) ? "Enter TopicName First..." : null;
                },
                onSaved: (val) {
                  topicName = val;
                },
                controller: topicNameController,
                decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter TopicName Here....",
                    labelText: "Topic"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                maxLines: 5,
                maxLength: 250,
                validator: (val) {
                  (val!.isEmpty) ? "Enter description First..." : null;
                },
                onSaved: (val) {
                  description = val;
                },
                controller: descriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter description Here....",
                    labelText: "description"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            child: const Text("Insert"),
            onPressed: () {
              if (insertKey.currentState!.validate()) {
                insertKey.currentState!.save();

                Map<String, dynamic> data = {
                  'topicName': topicName,
                  'description': description,
                };
                FirestoreHelper.firestoreHelper.insertRecords(data);
              }
              topicNameController.clear();
              descriptionController.clear();

              topicName = "";
              description = "";
              Navigator.of(context).pop();
            },
          ),
          OutlinedButton(
            child: const Text("Cancel"),
            onPressed: () {
              topicNameController.clear();
              descriptionController.clear();

              topicName = null;
              description = null;

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteData({required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: const Text("Delete ")),
        content: const Text(
          "Are you sure to delete this data permanently",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              FirestoreHelper.firestoreHelper.deleteRecords(id: id);

              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}
