import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/customWidgets/textfield.dart';
import 'package:stdproject/login.dart';
import 'package:stdproject/model/dataModel.dart';
import 'package:stdproject/provider/myProvider.dart';

class Studentreg extends StatefulWidget {
  Studentreg({super.key});

  @override
  State<Studentreg> createState() => _StudentregState();
}

class _StudentregState extends State<Studentreg> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final registernoController = TextEditingController();

  bool visibility = true;
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "STUDENT REGISTRATION",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  buildTextfield(
                      context,
                      Icon(
                        Icons.perm_identity_rounded,
                      ),
                      'RegNo',
                      registernoController,
                      false, (value) {
                    if (value!.isEmpty) {
                      return 'invalid';
                    }
                    return null;
                  }, SizedBox(), 1),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextfield(
                      context,
                      Icon(
                        Icons.person_2,
                      ),
                      'Name',
                      nameController,
                      false, (value) {
                    if (value == null || value.isEmpty) {
                      return 'invalid';
                    }
                    return null;
                  }, SizedBox(), 1),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextfield(
                      context,
                      Icon(
                        Icons.email,
                      ),
                      'Email',
                      emailController,
                      false, (value) {
                    if (value!.isEmpty) {
                      return 'invalid';
                    }
                    return null;
                  }, SizedBox(), 1),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextfield(context, Icon(Icons.lock), 'Password',
                      passwordController, visibility, (value) {
                    if (value!.isEmpty) {
                      return 'invalid';
                    } else if (value.length <= 5) {
                      return 'password must be greater than 6';
                    }
                    return null;
                  },
                      IconButton(
                        onPressed: () {
                          setState(() {
                            visibility = !visibility;
                          });
                        },
                        icon: visibility
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      1),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              await provider.registerStudent(
                                  emailController.text,
                                  passwordController.text,
                                  Student(
                                          email: emailController.text,
                                          name: nameController.text,
                                          regNo: registernoController.text)
                                      .toJson(),
                                  context);
                              Future.delayed(Duration(seconds: 2));

                              emailController.clear();

                              passwordController.clear();

                              nameController.clear();

                              registernoController.clear();
                              setState(() {
                                isloading = false;
                              });
                              User user = FirebaseAuth.instance.currentUser!;
                              await user.sendEmailVerification();

                              // Refresh user data

                              Future.delayed(Duration(seconds: 1));
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Set to false to disable dismissing
                                builder: (context) {
                                  return Material(
                                    type: MaterialType.transparency,
                                    child: AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Column(
                                        children: [
                                          Icon(
                                            Icons.mark_email_unread_outlined,
                                            size: 50,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Verify Email',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                      content: Text(
                                        'Verify your Email to continue',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            await user.reload();

                                            if (FirebaseAuth.instance
                                                .currentUser!.emailVerified) {
                                              Navigator.pop(context);
                                              provider.navigation(context,
                                                  login(text: 'Student'));
                                              FirebaseAuth.instance.signOut();
                                            } else {
                                              provider.showSnackbar(
                                                  context,
                                                  'Email Not verified!',
                                                  Colors.red);
                                            }
                                          },
                                          child: Text('ok'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: isloading
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Text("REGISTER"))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an Account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        login(text: 'Student')));
                          },
                          child: Text("Login")),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
