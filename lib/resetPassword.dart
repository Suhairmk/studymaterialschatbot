import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/customWidgets/textfield.dart';
import 'package:stdproject/provider/myProvider.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Reset Password'),
                SizedBox(
                  height: 20,
                ),
                buildTextfield(
                  context,
                  Icon(Icons.email),
                  'E-mail',
                  emailController,
                  false,
                  (value) {
                    if (value!.isEmpty) {
                      return 'invalid';
                    }
                    return null;
                  },
                  SizedBox(),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                    builder:
                        (BuildContext context, bool loading, Widget? child) {
                      return ElevatedButton(
                        onPressed: () async {
                          isLoading.value = true;
                          if (formKey.currentState!.validate()) {
                            await provider.resetPassword(
                                emailController.text, context);
                            Future.delayed(Duration(seconds: 2));
                            emailController.clear();
                            Future.delayed(Duration(seconds: 2));
                            Navigator.pop(context);
                          }
                          isLoading.value = false;
                        },
                        child: loading
                            ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    child: CircularProgressIndicator()),
                              )
                            : Text('Send'),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
