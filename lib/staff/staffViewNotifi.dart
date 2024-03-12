import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/provider/myProvider.dart';

class StaffViewNotifivation extends StatefulWidget {
  const StaffViewNotifivation({super.key});

  @override
  State<StaffViewNotifivation> createState() => _StaffViewNotifivationState();
}

class _StaffViewNotifivationState extends State<StaffViewNotifivation> {
 List<Map<String, dynamic>> notifications = [];

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
        ));
  }
}