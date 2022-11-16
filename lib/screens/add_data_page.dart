import 'package:flutter/material.dart';

import '../helper/firestore_helper.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
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
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        height: 350,
        color: Colors.white,
        width: 400,
        padding: EdgeInsets.all(20),
        child: Form(
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
                    border: OutlineInputBorder(),
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
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                  ),
                  OutlinedButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      topicNameController.clear();
                      descriptionController.clear();

                      topicName = null;
                      description = null;

                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (route) => false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
