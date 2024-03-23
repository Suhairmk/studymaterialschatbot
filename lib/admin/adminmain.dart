import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/Dashboard.dart';
import 'package:stdproject/admin/addNotification.dart';
import 'package:stdproject/admin/staffreg.dart';
import 'package:stdproject/admin/uploadformadmin.dart';
import 'package:stdproject/customWidgets/container.dart';
import 'package:stdproject/login.dart';
import 'package:stdproject/provider/myProvider.dart';

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

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
          backgroundColor: Color.fromRGBO(62, 62, 61, 1),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 3, 157, 246),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    provider.signOutUser(context);
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: Stack(
            children: [
              Container(),
              Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildContainer(
                          context,
                          'Upload or View',
                          Icon(
                            Icons.upload,
                            color: Colors.white,
                          ), () {
                        navigation(
                            UploadViewScreen(
                              role: 'admin',
                            ),
                            context);
                      }),
                      SizedBox(
                        height: 30,
                      ),
                      buildContainer(
                          context,
                          'Add Staff',
                          Icon(
                            Icons.person_add_alt_outlined,
                            color: Colors.white,
                          ), () {
                        navigation(StaffRegister(), context);
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
                        navigation(NotificationAdd(), context);
                      })
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void navigation(screen, context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
