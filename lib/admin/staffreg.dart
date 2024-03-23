import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/customWidgets/textfield.dart';
import 'package:stdproject/model/dataModel.dart';
import 'package:stdproject/provider/myProvider.dart';

class StaffRegister extends StatefulWidget {
  StaffRegister({super.key});

  @override
  State<StaffRegister> createState() => _StaffRegisterState();
}

class _StaffRegisterState extends State<StaffRegister> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final teacheridController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool visibility = true;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
       backgroundColor: Color.fromRGBO(62, 62, 61, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "STAFF REGISTRATION",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  buildTextfield(
                      context,
                      Icon(
                        Icons.perm_identity,
                      ),
                      'Teacher\'s ID',
                      teacheridController,
                      false, (value) {
                    if (value!.isEmpty) {
                      return 'invalid';
                    }
                    return null;
                  }, SizedBox(),1),
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
                    if (value!.isEmpty) {
                      return 'invalid';
                    }
                    return null;
                  }, SizedBox(),1),
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
                  }, SizedBox(),1),
                  SizedBox(
                    height: 10,
                  ),
                  buildTextfield(context, Icon(Icons.lock), 'Password',
                      passwordController, visibility, (value) {
                    if (value!.isEmpty) {
                      return 'invalid';
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
                      ),1),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isloading = true;
                            });
                      
                            await provider.registerAndStoreData(
                              emailController.text,
                              passwordController.text,
                              Teacher(
                                teacherEmail: emailController.text,
                                name: nameController.text,
                                teacherId: teacheridController.text,
                              ).toJson(),
                              context,
                            );
                      
                            emailController.clear();
                            passwordController.clear();
                            nameController.clear();
                            teacheridController.clear();
                      
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        child: isloading
                            ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(child: CircularProgressIndicator()),
                            )
                            : Text("REGISTER"),
                      ),
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
