import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/Dashboard.dart';
import 'package:stdproject/admin/staffreg.dart';
import 'package:stdproject/admin/uploadformadmin.dart';
import 'package:stdproject/admin/viewUploads.dart';
import 'package:stdproject/customWidgets/container.dart';
import 'package:stdproject/login.dart';
import 'package:stdproject/provider/myProvider.dart';
import 'package:stdproject/staff/staffViewNotifi.dart';

class StaffMainScreen extends StatefulWidget {
  const StaffMainScreen({super.key});

  @override
  State<StaffMainScreen> createState() => _StaffMainScreenState();
}

class _StaffMainScreenState extends State<StaffMainScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context,listen: false);
     DateTime? currentBackPressTime;
    return WillPopScope(
       onWillPop: () async{
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
      child: Scaffold( backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    provider.signOutUser(context);
                    
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
        body: SafeArea(child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            buildContainer(
                  context,
                  'Upload',
                  
                  Icon(
                    Icons.upload,
                    color: Colors.white,
                  ), () {
                 navigation(UploadViewScreen(role: 'staff',));
              }),
             
              SizedBox(
                height: 30,
              ),
              buildContainer(
                  context,
                  'View',
                 
                  Icon(
                    Icons.view_carousel_outlined,
                    color: Colors.white,
                  ), () {
                 navigation(ViewStdMetreals(role: 'staff',));
              }),
             
              SizedBox(
                height: 30,),
              buildContainer(
                  context,
                  'Notifications',
                  
                  Icon(
                    Icons.notification_add,
                    color: Colors.white,
                  ), () {
                navigation(StaffViewNotifivation());
              })
          ],),
        )),),
    );
  }
   void navigation(screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}