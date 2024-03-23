import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:stdproject/Dashboard.dart';
import 'package:stdproject/admin/adminmain.dart';

import 'package:stdproject/provider/myProvider.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stdproject/staff/staffMain.dart';

import 'package:stdproject/student/studHome.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: 'AIzaSyBj3aubGBooDX7b0re9SJYa155tWMv7_lQ');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late User? user;
  Widget initialscreen =
      Scaffold(body: Center(child: CircularProgressIndicator()));
  Widget splashscreen = Scaffold(body: Center(child: Container(child: Image.asset('assets/images/logo.png'),)));

  Future<Widget> getUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? email = user.email;
      String collection = await Provider.of<MyProvider>(context, listen: false)
          .getUserCollectionName(email!);

      if (collection == 'students') {
        return StudentHome();
      } else if (collection == 'teachers') {
        return StaffMainScreen();
      } else if (collection == 'admin') {
        return AdminMain();
      } else {
        return Dashboard();
      }
    } else {
      return Dashboard();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    Widget screen = await getUser();
    setState(() {
      initialscreen = splashscreen;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      initialscreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: initialscreen);
  }
}



//   AIzaSyBj3aubGBooDX7b0re9SJYa155tWMv7_lQ