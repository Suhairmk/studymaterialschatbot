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


class StudentHome extends StatefulWidget {
  const StudentHome({super.key});
  

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [buildContainer(
                    context,
                    'ChatBoat',
                    Icon(
                      Icons.book,
                      color: Colors.white,
                    ), () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Chatbot()));
                }),
              
                buildContainer(
                    context,
                    'Attendance',
                    Icon(
                      Icons.book_online,
                      color: Colors.white,
                    ), () {
                  _launchUrl();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AttentenceWebScreen()));
                }),],),

                
                SizedBox(
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
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
                buildContainer(
                    context,
                    'Ai Chat',
                    Icon(
                      Icons.chat_bubble_outlined,
                      color: Colors.white,
                    ), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AiScreen()));
                })
                ],)
                
              ],
            ),
          )),
    );
  }
}

// class AttentenceWebScreen extends StatefulWidget {
//   AttentenceWebScreen({super.key});

//   @override
//   State<AttentenceWebScreen> createState() => _AttentenceWebScreenState();
// }

// class _AttentenceWebScreenState extends State<AttentenceWebScreen> {
//   late  WebViewController _webViewController = WebViewController();

//   @override
//   void initState() {
//     // https://teams.ac.in/index.php?r=site%2Fstudent-select-inst
//     _webViewController
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {},
//           onWebResourceError: (WebResourceError error) {},
          
//         ),
//       )
//       ..loadRequest(Uri.parse(
//           'https://teams.ac.in/index.php?r=site%2Fstudent-select-inst'));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: WebViewWidget(controller: _webViewController),
//     );
//   }
// }
