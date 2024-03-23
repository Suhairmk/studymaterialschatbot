import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/login.dart';
import 'package:stdproject/provider/myProvider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  void navigation(screen,context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        navigation(login(
                          text: 'Teacher',
                        ),context);
                      },
                      child: Text("TEACHER"))),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        navigation(login(
                          text: 'Student',
                        ),context);
                      },
                      child: Text("STUDENT"))),
              SizedBox(
                height: 20,
              ),
             
            ],
          ),
        )),
      ),
    );
  }
}
