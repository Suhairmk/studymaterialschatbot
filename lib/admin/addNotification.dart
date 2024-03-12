import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Scaffold(
      appBar: AppBar(
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
                    child: ListTile(
                      title: Text(notifications[index]['title']),
                      subtitle: Text(notifications[index]['body']),
                      trailing: Text(
                        notifications[index]['time'].toString(),
                      ),
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
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Add Notification',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            buildTextfield(
                              context,
                              Icon(Icons.title),
                              'Title',
                              titleController,
                              false,
                              (value) {
                                if (value!.isEmpty) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                              SizedBox(),
                            ),
                            SizedBox(height: 20),
                            buildTextfield(
                              context,
                              Icon(Icons.description),
                              'Description',
                              descriptionController,
                              false,
                              (value) {
                                if (value!.isEmpty) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                              SizedBox(),
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
                                },
                                child:isloading?CircularProgressIndicator(): Text('Add Notification'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
