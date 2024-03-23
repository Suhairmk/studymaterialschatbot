import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stdproject/Dashboard.dart';
import 'package:stdproject/admin/adminmain.dart';
import 'package:stdproject/login.dart';
import 'package:stdproject/model/dataModel.dart';
import 'package:stdproject/staff/staffMain.dart';
import 'package:stdproject/student/studHome.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> currentusrdata = {};

class MyProvider extends ChangeNotifier {
  String text = 'START';
  List<Widget> widgetList = [];

  List<String> semList = [
    'sem 1',
    'sem 2',
    'sem 3',
    'sem 4',
    'sem 5',
    'sem 6',
  ];

  List<String> sem6sub = [
    'Entrepreurship & Startup',
    'Indian Constitution',
    'Internet of Things',
    'Server Administration',
    'Software Testing',
    'ELECTIVE',
  ];
  List<String> sem5sub = [
    'PMSE',
    'ES & RTOS',
    'Operating System',
    'Virtualisation Technology & Cloud Computing',
    'Artificial Intelligence & Machine Learning',
    'Ethical Hacking',
  ];

  List<String> sem4sub = [
    'OOP',
    'CCN',
    'Data structure',
    'CSIKs',
  ];

  List<String> sem3sub = [
    'Computer organisation',
    'Programming in C',
    'DBMS',
    'DCF',
  ];

  List<String> sem2sub = [
    'FEEE',
    'Mathematics II',
    'Applied Physics II',
    'Environment science',
    'Problem Solving & Programming',
  ];

  List<String> sem1sub = [
    'Communication Skill in Enghlish',
    'Mathematics I',
    'Applied Physics I',
    'Engineering Graphics',
  ];
  List<String> moduleList = [
    'Module 1',
    'Module 2',
    'Module 3',
    'Module 4',
    'Question Paper',
    'Syllabus'
  ];
  List<String> openElective = [
    'PRODUCT DESGN',
    'DISASTER MANAGEMENT',
    'ELECTRIFICATION OF RESIDENTAL BUILDING',
    'OPERATION RESEARCH',
    'SUSTAITABLE ENERGY'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void clearChat() {
    widgetList.clear();
    notifyListeners();
  }

//teacher registration
  Future<void> registerAndStoreData(email, password, data, context) async {
    try {
      // 1. Register the user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Store additional data in Firestore
      await _firestore.collection('teachers').doc(email).set(data);

      print('User registered and data stored: ${userCredential.user?.uid}');
      showSnackbar(context, 'successfully registered', Colors.green);
      // Navigate to the next screen or perform actions upon successful registration.
    } catch (e) {
      print('Error registering user: $e');
      showSnackbar(context, 'Error registering Teacher', Colors.red);
      // Handle registration failure here.
    }
    notifyListeners();
  }

//register students
  Future<void> registerStudent(email, password, data, context) async {
    UserCredential? userCredential;
    try {
      // 1. Register the user with email and password
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Store additional data in Firestore
      await _firestore.collection('students').doc(email).set(data);

      print('User registered and data stored: ${userCredential.user?.uid}');
      showCustomAlertDialog(
          context, Icons.verified_user_rounded, '', 'Registration Success');

      // Navigate to the next screen or perform actions upon successful registration.
    } catch (e) {
      print('Error registering user: $e');
      showSnackbar(context, 'Error registering ', Colors.red);
      // Handle registration failure here.
    }

    notifyListeners();
  }

// login function

  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // Sign in the user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Check the user's role based on the email domain
      if (userCredential.user != null) {
        String userEmail = userCredential.user!.email ?? '';

        // Check the collection name associated with the user's email
        String collectionName = await getUserCollectionName(
          userEmail,
        );

        showSnackbar(context, 'Login Success', Colors.green);
        // Navigate based on the collection name
        if (collectionName == 'teachers') {
          // Navigate to the teacher panel
          navigation(context, StaffMainScreen());
        } else if (collectionName == 'students') {
          if (userCredential.user!.emailVerified) {
            navigation(context, StudentHome());
          } else {
            showSnackbar(context, 'Email not verified', Colors.red);
            FirebaseAuth.instance.signOut();
          }
          // Navigate to the student panel
        } else if (collectionName == 'admin') {
          // Navigate to the student panel
          navigation(context, AdminMain());
        } else {
          // Handle other roles or scenarios
          print('Unknown role for user with email: $userEmail');
          showSnackbar(context, 'Can\'t find the user', Colors.red);
        }
      }
    } catch (e) {
      // Handle login errors
      print('Error during login: $e');
      showSnackbar(context, 'Login Error', Colors.red);
      // You can show a snackbar or dialog to notify the user about the error.
    }
  }

//getting user role(collection name)
  Future<String> getUserCollectionName(String userEmail) async {
    List<String> possibleCollections = ['teachers', 'students', 'admin'];

    try {
      for (String collectionName in possibleCollections) {
        // Query the Firestore collection to check if the user's document exists
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection(collectionName)
            .doc(userEmail)
            .get();
        print('Collection: $collectionName, Document: ${userDoc.data()}');

        // If the user document exists in the current collection, return the collection name
        if (userDoc.exists) {
          print('User found in $collectionName');
          // Extract data from the document if needed
          Map<String, dynamic>? userData = userDoc.data();
          if (userData != null) {
            currentusrdata = userData;
            print(currentusrdata);
          }
          return collectionName;
        }
      }
      // If the user document is not found in any collection
      print('User not found in any collection');
      return ''; // Return an empty string or handle appropriately
    } catch (e) {
      print("Error getting user collection name: $e");
      return ''; // Return an empty string or handle appropriately
    }
  }

//add notification
  Future<void> addNotification(context, String title, String body) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference notifications =
          FirebaseFirestore.instance.collection('notifications');
      String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      // Add a new document with a generated ID
      await notifications.doc(title).set({
        'title': title,
        'body': body,
        'timestamp': DateTime.now(),
        'time': time,
      });

      print('Notification added to Firestore collection.');
      showSnackbar(context, 'Added Notification', Colors.green);
    } catch (e) {
      print('Error adding notification to Firestore: $e');
      showSnackbar(context, 'Error Adding Notification', Colors.red);
    }
    notifyListeners();
  }

// view notifications
  Future<List<Map<String, dynamic>>> getNotifications(context) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference notifications =
          FirebaseFirestore.instance.collection('notifications');

      // Fetch documents from the collection and sort by timestamp in descending order
      QuerySnapshot querySnapshot =
          await notifications.orderBy('timestamp', descending: true).get();

      // Extract data from documents
      List<Map<String, dynamic>> notificationsData =
          querySnapshot.docs.map((doc) {
        return {
          'title': doc['title'],
          'body': doc['body'],
          'timestamp': doc['timestamp'],
          'time': doc['time'].toString(),
        };
      }).toList();

      notifyListeners();
      return notificationsData;
    } catch (e) {
      showSnackbar(context, 'Error fetching Notification', Colors.red);
      print('Error fetching notifications from Firestore: $e');
      return [];
    }
  }

//add study meterials

  Future<void> uploadStudyMaterial(context, StudyMaterial studyMaterial) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference studyMaterials =
          FirebaseFirestore.instance.collection('studymaterials');

      // Convert the StudyMaterial object to a JSON object
      Map<String, dynamic> studyMaterialJson = studyMaterial.toJson();

      // Add the JSON object to the collection
      await studyMaterials.doc(studyMaterial.title).set(studyMaterialJson);

      print('Study material uploaded successfully!');
      showSnackbar(context, 'uploaded Successfully', Colors.green);
    } catch (e) {
      print('Error uploading study material to Firestore: $e');
      // Handle the error as needed
    }
  }

//view all study meterials
  Future<List<StudyMaterial>> getStudyMaterials(BuildContext context) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference studyMaterialsRef =
          FirebaseFirestore.instance.collection('studymaterials');

      // Fetch documents from the collection
      QuerySnapshot querySnapshot = await studyMaterialsRef.get();

      //getDocumentId
      List<String> documentIds =
          querySnapshot.docs.map((doc) => doc.id).toList();

      // Extract data from documents
      List<StudyMaterial> studyMaterials = querySnapshot.docs.map((doc) {
        return StudyMaterial(
          sem: doc['sem'],
          subject: doc['subject'],
          title: doc['title'],
          file: doc['file'],
        );
      }).toList();

      print(studyMaterials.length);

      notifyListeners();
      return studyMaterials;
    } catch (e) {
      showSnackbar(context, 'Error fetching study materials', Colors.red);
      print('Error fetching study materials from Firestore: $e');
      return [];
    }
  }

//view spesific study meterials
  Future<List<StudyMaterial>> getSpesificStudyMaterials(
      BuildContext context, sem, subject, module) async {
    try {
      // Get a reference to the Firestore collection
      Query studyMaterialsQuery = FirebaseFirestore.instance
          .collection('studymaterials')
          .where('sem', isEqualTo: sem)
          .where('subject', isEqualTo: subject)
          .where('title', isEqualTo: module);

      // Fetch documents from the query
      QuerySnapshot querySnapshot = await studyMaterialsQuery.get();

      // Extract data from documents
      List<StudyMaterial> studyMaterials = querySnapshot.docs.map((doc) {
        return StudyMaterial(
          sem: doc['sem'],
          subject: doc['subject'],
          title: doc['title'],
          file: doc['file'],
        );
      }).toList();

      print('rrrrrrrrrrrrrrrrrr');
      print(studyMaterials.length);

      notifyListeners();
      return studyMaterials;
    } catch (e) {
      showSnackbar(context, 'Error fetching study materials', Colors.red);
      print('Error fetching study materials from Firestore: $e');
      return [];
    }
  }

//delete data from firebase
  Future<void> deleteDocument(String collection, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .delete();
      notifyListeners();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
      // Handle the error as needed
    }
  }

//log out user

  void signOutUser(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout Confirmation'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Return false to indicate cancel
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  try {
                    await auth.signOut();
                    print('User signed out successfully.');
                    showSnackbar(context, 'User Signed Out', Colors.white);
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Dashboard())); // Return true to indicate logout
                },
                child: Text('Logout'),
              ),
            ],
          );
        });
  }

//download to phone
  Future<void> downloadFile(String downloadUrl, context, name) async {
    try {
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        // Extract Content-Type header
        print(response.body);

        String extension = '';
        if (downloadUrl.toLowerCase().contains('.pdf')) {
          extension = '.pdf';
        } else if (downloadUrl.toLowerCase().contains('.jpg')) {
          extension = '.jpg';
        }
        if (downloadUrl.toLowerCase().contains('.png')) {
          extension = '.png';
        }
        if (downloadUrl.toLowerCase().contains('.gif')) {
          extension = '.gif';
        }
        if (downloadUrl.toLowerCase().contains('.jpeg')) {
          extension = '.jpg';
        }
        if (downloadUrl.toLowerCase().contains('.doc')) {
          extension = '.doc';
        }
        if (downloadUrl.toLowerCase().contains('.ppt')) {
          extension = '.ppt';
        }
        if (downloadUrl.toLowerCase().contains('.txt')) {
          extension = '.txt';
        }
        // Determine file extension based on Content-Type

        var status = await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          print("Permissions granted");
        } else {
          print("Permissions denied");
        }

        

        final appDir = '/storage/emulated/0/StudyMaterials';
        Directory directory = Directory(appDir);
        await directory.create(recursive: true);

        final filePath = '$appDir/$name$extension';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // File downloaded successfully
        print('File downloaded to: $filePath');
        showSnackbar(context, 'Downloaded', Colors.white);
      } else {
        // Handle HTTP error
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('Error downloading file: $e');
    }
  }

//forgot password
  Future<void> resetPassword(String email, context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
      showSnackbar(
          context, 'Password reset email sent to $email', Colors.green);
      showCustomAlertDialog(context, Icons.mail_outlined,
          'Password reset email sent to $email', 'Email Sent');
      notifyListeners();
    } catch (e) {
      print('Error sending password reset email: $e');
      showSnackbar(context, 'Error sending password reset email', Colors.red);

      // You can handle errors or display a message to the user here
    }
  }

  void addWidget(widget) {
    widgetList.add(widget);
    notifyListeners();
  }

  void removeWidget(widget) {
    widgetList.remove(widget);
    notifyListeners();
  }

  void click() {
    text = (text == 'EXIT') ? 'START' : 'EXIT';
    notifyListeners();
  }

  //snackBar
  void showSnackbar(BuildContext context, String message, color) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color),
      ),
      duration: Duration(seconds: 3), // Adjust the duration as needed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    notifyListeners();
  }

  //alert dialog
  void showCustomAlertDialog(
      BuildContext context, IconData icon, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Icon(
                icon,
                size: 70,
                color: Colors.green,
              ),
              SizedBox(height: 15.0),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // You can add additional actions or navigation logic here
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    notifyListeners();
  }

  void navigation(context, screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
