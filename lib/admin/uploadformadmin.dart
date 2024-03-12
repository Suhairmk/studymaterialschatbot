import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/admin/viewUploads.dart';
import 'package:stdproject/customWidgets/dropdown.dart';
import 'package:stdproject/customWidgets/list.dart';
import 'package:stdproject/customWidgets/textfield.dart';
import 'package:stdproject/model/dataModel.dart';
import 'package:stdproject/provider/myProvider.dart';

class UploadViewScreen extends StatefulWidget {
  UploadViewScreen({super.key, required this.role});
  final role;

  @override
  State<UploadViewScreen> createState() => _UploadViewScreenState();
}

class _UploadViewScreenState extends State<UploadViewScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final nameController = TextEditingController();

  final teacheridController = TextEditingController();

  String selectedSem = 'Select Sem';
  bool isLosding = false;

  String selectedModule = 'Select Module';
  String selectedSub = 'Select subject';
  String selectedElective = 'Select Subject';
  List<String> subjects = ['Select subject'];
  late String filePath = 'No file selected';

 
  void updateSubjects(String selectedSemester) {
    setState(() {
      if (selectedSemester == 'sem 1') {
        subjects = [...sem1sub];
      } else if (selectedSemester == 'sem 6') {
        subjects = [...sem6sub];
      }
      else if (selectedSemester == 'sem 2') {
        subjects = [...sem2sub];
      }
      else if (selectedSemester == 'sem 3') {
        subjects = [...sem3sub];
      }
      else if (selectedSemester == 'sem 4') {
        subjects = [...sem4sub];
      }
      else if (selectedSemester == 'sem 5') {
        subjects = [...sem5sub];
      } else {
        subjects = ['Select subject'];
      }
    });
  }
//pick file

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          filePath = result.files.single.path!;
        });
        // Do something with the file path
        print('File picked: $filePath');
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

// Upload image and get download URL
  Future<String?> uploadImageAndGetDownloadURL(File imageFile) async {
    try {
      String fileName = imageFile.path;
      Reference storageReference =
          FirebaseStorage.instance.ref().child('your_storage_path/$fileName');

      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e, stackTrace) {
      print('Error uploading image: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text(
                "UPLOAD STUDY MATERIALS",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 40,
              ),
              BuildDropdown(
                items: semList,
                selecedValue: selectedSem,
                onchanged: (value) {
                  setState(() {
                    selectedSem = value;
                    updateSubjects(selectedSem);
                    selectedSub = 'Select subject';
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),

              BuildDropdown(
                items: subjects,
                selecedValue: selectedSub,
                onchanged: (value) {
                  setState(() {
                    selectedSub = value;
                    updateSubjects(selectedSem);
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              selectedSub == 'ELECTIVE'
                  ? BuildDropdown(
                      items: openElective,
                      selecedValue: selectedElective,
                      onchanged: (value) {
                        setState(() {
                          selectedElective = value;
                          updateSubjects(selectedSem);
                        });
                      },
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              BuildDropdown(
                items: moduleList,
                selecedValue: selectedModule,
                onchanged: (value) {
                  setState(() {
                    selectedModule = value;
                    updateSubjects(selectedSem);
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),

              //container for attatch file
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 28,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Selected File Path:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(filePath),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: pickFile,
                      child: Text('Choose File'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (selectedSem == 'Select Sem' ||
                            selectedModule == 'Select Module' ||
                            selectedSub == 'Select subject' ||
                            filePath == 'No file selected') {
                          provider.showSnackbar(
                              context, 'Select an item', Colors.red);
                        }
                        if (filePath != null) {
                          setState(() {
                            isLosding = true;
                          });
                          File selectedFile = File(filePath);
                          String? downloadURL =
                              await uploadImageAndGetDownloadURL(selectedFile);

                          if (downloadURL != null) {
                            // You can use the downloadURL as needed, for example, store it in Firestore.
                            print('Image Download URL: $downloadURL');
                            print('Submitting PDF: $filePath');
                            await provider.uploadStudyMaterial(
                                context,
                                StudyMaterial(
                                    sem: selectedSem,
                                    subject: selectedSub == 'ELECTIVE'
                                        ? selectedElective
                                        : selectedSub,
                                    title: selectedModule,
                                    file: downloadURL));
                            setState(() {
                              selectedSem = 'Select Sem';

                              selectedModule = 'Select Module';
                              selectedSub = 'Select subject';
                              selectedElective = 'Select Subject';
                              subjects = ['Select subject'];
                              filePath = 'No file selected';
                              isLosding = false;
                            });
                          } else {
                            setState(() {
                              isLosding = false;
                            });
                            print('Image upload failed');
                          }
                        } else {
                          // Show an error or prompt the user to pick a file
                          print('Please pick a PDF file before submitting.');
                          provider.showSnackbar(
                              context,
                              'Please pick a PDF file before submitting.',
                              Colors.red);
                        }
                      },
                      child: isLosding
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Text("UPLOAD"))),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.role == 'admin'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewStdMetreals(
                              role: widget.role,
                            )));
              },
              label: Text('View Uploads'))
          : SizedBox(),
    );
  }
}
