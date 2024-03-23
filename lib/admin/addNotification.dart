import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/admin/adminmain.dart';
import 'package:stdproject/customWidgets/textfield.dart';
import 'package:stdproject/provider/myProvider.dart';

class NotificationAdd extends StatefulWidget {
  const NotificationAdd({Key? key}) : super(key: key);

  @override
  _NotificationAddState createState() => _NotificationAddState();
}

class _NotificationAddState extends State<NotificationAdd> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> notifications = [];
  bool isloading = false;

  @override
  void initState() {
    fetchNotifications();

    super.initState();
  }

  void fetchNotifications() async {
    var provider = Provider.of<MyProvider>(context, listen: false);
    notifications = await provider.getNotifications(context);
    print(notifications.length);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        provider.navigation(context, AdminMain());
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(62, 62, 61, 1),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 157, 246),
          title: Text('Notifications'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(notifications[index]['title']),
                            subtitle: Text(notifications[index]['body']),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  notifications[index]['time']
                                      .toString()
                                      .substring(0, 10),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text(
                                              "Are you sure you want to delete this notification?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await provider.deleteDocument(
                                                    'notifications',
                                                    notifications[index]
                                                        ['title']);
                                                provider.navigation(
                                                    context, NotificationAdd());
                                                // Close the dialog
                                              },
                                              child: Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_forever_outlined,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Add Notification'),
                  content: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                buildTextfield(context, Icon(Icons.title),
                                    'Title', titleController, false, (value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid';
                                  }
                                  return null;
                                }, SizedBox(), 1),
                                SizedBox(height: 20),
                                buildTextfield(
                                    context,
                                    Icon(Icons.description),
                                    'Description',
                                    descriptionController,
                                    false, (value) {
                                  if (value!.isEmpty) {
                                    return 'Invalid';
                                  }
                                  return null;
                                }, SizedBox(), 4),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  await provider.addNotification(
                                    context,
                                    titleController.text,
                                    descriptionController.text,
                                  );
                                  titleController.clear();
                                  descriptionController.clear();
                                  fetchNotifications();
                                }
                                setState(() {
                                  isloading = false;
                                });
                                Navigator.pop(context);
                              },
                              child: isloading
                                  ? CircularProgressIndicator()
                                  : Text('Add Notification'),
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
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
