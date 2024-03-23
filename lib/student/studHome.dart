import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/Dashboard.dart';
import 'package:stdproject/ai.dart';
import 'package:stdproject/customWidgets/container.dart';
import 'package:stdproject/provider/myProvider.dart';
import 'package:stdproject/staff/staffViewNotifi.dart';
import 'package:stdproject/student/Cbscreen.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHome extends StatelessWidget {
  StudentHome({super.key});

  @override
  final Uri _url =
      Uri.parse('https://teams.ac.in/index.php?r=site%2Fstudent-select-inst');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    DateTime? currentBackPressTime;
    return WillPopScope(
      onWillPop: () async {
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                Duration(seconds: 2)) {
          // First tap, show Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press again to exit'),
              duration: Duration(seconds: 2),
            ),
          );

          // Update the last press time
          currentBackPressTime = DateTime.now();
          return false;
        } else {
          // Second tap within 2 seconds, exit the app
          SystemNavigator.pop();
          return true;
        }
      },
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(),
                    title: Text(currentusrdata['name']),
                    subtitle: Text(currentusrdata['email']),
                  ),
                )),
                ListTile(
                  trailing: Icon(
                    Icons.logout,
                  ),
                  onTap: () {
                    provider.signOutUser(context);
                  },
                  title: Text('LogOut'),
                )
              ],
            ),
          ),
          backgroundColor: Color.fromRGBO(62, 62, 61, 1),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color.fromARGB(255, 243, 250, 249)),
            backgroundColor: Color.fromARGB(255, 3, 157, 246),
            elevation: 0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildContainer(
                      context,
                      'Study Materials',
                      Icon(
                        Icons.book_sharp,
                        color: Colors.white,
                      ), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Chatbot()));
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  buildContainer(
                      context,
                      'Attendance',
                      Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ), () {
                    _launchUrl();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AttentenceWebScreen()));
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  buildContainer(
                      context,
                      'Notifications',
                      Icon(
                        Icons.notification_add,
                        color: Colors.white,
                      ), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StaffViewNotifivation()));
                  }),
                  SizedBox(
                    height: 30,
                  ),
                  buildContainer(
                      context,
                      'Ask Expert',
                      Icon(
                        Icons.chat_bubble_outlined,
                        color: Colors.white,
                      ), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AiScreen()));
                  }),
                  
                ],

              ),
            ),
          )),
    );
  }
}

