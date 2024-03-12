import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/admin/adminmain.dart';
import 'package:stdproject/customWidgets/textfield.dart';
import 'package:stdproject/provider/myProvider.dart';
import 'package:stdproject/resetPassword.dart';
import 'package:stdproject/staff/staffMain.dart';
import 'package:stdproject/student/studHome.dart';
import 'package:stdproject/student/studentreg.dart';

class login extends StatefulWidget {
  login({super.key, required this.text});
  final text;
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool visibility = true;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.text} Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 40,
                ),
                buildTextfield(
                  context,
                  Icon(
                    Icons.email,
                  ),
                  'Email',
                  emailController,
                  false,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter something';
                    } else if (value.length < 3) {
                      return 'Must be at least 3 characters long';
                    }
                    return null;
                  },
                  SizedBox(),
                ),
                SizedBox(
                  height: 10,
                ),
                buildTextfield(context, Icon(Icons.lock), 'Password',
                    passwordController, visibility, (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter something';
                  } else if (value.length < 3) {
                    return 'Must be at least 3 characters long';
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
                            ? Icon(Icons.visibility_off_outlined)
                            : Icon(Icons.visibility_outlined))),
                Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Text('Forgot password ?'))),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          Widget screen = StudentHome();
                          if (_formKey.currentState!.validate()) {
                            
                            
                            print('hello validate');
                            setState(() {
                              isloading = true;
                            });
                            await provider.loginUser(emailController.text,
                                passwordController.text, context);
                          
                            setState(() {
                              isloading = false;;
                            });
                          }
                        },
                        child: isloading
                              ? Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Text("LOGIN"))),
                widget.text == 'Student'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t You Have An Account'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Studentreg()));
                              },
                              child: Text("Register")),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
