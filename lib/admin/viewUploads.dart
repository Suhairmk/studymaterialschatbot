import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stdproject/customWidgets/dropdown.dart';
import 'package:stdproject/customWidgets/list.dart';
import 'package:stdproject/customWidgets/pdf.dart';
import 'package:stdproject/model/dataModel.dart';
import 'package:stdproject/provider/myProvider.dart';

class ViewStdMetreals extends StatefulWidget {
  const ViewStdMetreals({Key? key, required this.role}) : super(key: key);
  final role;

  @override
  State<ViewStdMetreals> createState() => _ViewStdMetrealsState();
}

class _ViewStdMetrealsState extends State<ViewStdMetreals> {
  Future<List<StudyMaterial>>? studyMaterialsFuture;
  String selectedSem = 'Select Sem';
  String selectedSubject = 'Select subject';
  List<String> subjects = ['Select subject'];

  @override
  void initState() {
    studyMaterialsFuture = fetchStudyMaterials();
    super.initState();
  }

  Future<List<StudyMaterial>> fetchStudyMaterials() async {
    var provider = Provider.of<MyProvider>(context, listen: false);
    return provider.getStudyMaterials(context);
  }

  void updateSubjects(String selectedSemester) {
    setState(() {
      if (selectedSemester == 'sem 1') {
        subjects = [...sem1sub];
      } else if (selectedSemester == 'sem 6') {
        subjects = [...sem6sub];
      } else if (selectedSemester == 'sem 2') {
        subjects = [...sem2sub];
      } else if (selectedSemester == 'sem 3') {
        subjects = [...sem3sub];
      } else if (selectedSemester == 'sem 4') {
        subjects = [...sem4sub];
      } else if (selectedSemester == 'sem 5') {
        subjects = [...sem5sub];
      } else {
        subjects = ['Select subject'];
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(62, 62, 61, 1),
          title: Text(
            'Filter Options',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 250,
                child: Column(
                  children: [
                    BuildDropdown(
                      items: semList,
                      selecedValue: selectedSem,
                      onchanged: (value) {
                        setState(() {
                          selectedSem = value;
                          updateSubjects(selectedSem);
                          selectedSubject = 'Select subject';
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    BuildDropdown(
                      items: subjects,
                      selecedValue: selectedSubject,
                      onchanged: (value) {
                        setState(() {
                          selectedSubject = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  studyMaterialsFuture = fetchStudyMaterials();
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Apply filters and update UI

                setState(() {
                  studyMaterialsFuture = _applyFilters();
                });
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Future<List<StudyMaterial>> _applyFilters() async {
    // Replace this with your logic to filter the study materials
    var provider = Provider.of<MyProvider>(context, listen: false);
    var allStudyMaterials = await provider.getStudyMaterials(context);

    // Apply filters based on selectedSem and selectedSubject
    var filteredMaterials = allStudyMaterials.where((material) {
      return (selectedSem.isEmpty || material.sem == selectedSem) &&
          (selectedSubject.isEmpty || material.subject == selectedSubject);
    }).toList();

    return filteredMaterials;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color.fromRGBO(62, 62, 61, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 157, 246),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
        title: Text('Uploads'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<StudyMaterial>>(
                future: studyMaterialsFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<StudyMaterial>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ); // Loading indicator while data is being fetched
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<StudyMaterial> uploadList = snapshot.data!;

                    if (uploadList.isEmpty) {
                      // Display a message when there are no results
                      return Center(
                        child: Text(
                          'No results',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(142, 0, 0, 0)),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: uploadList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(uploadList[index].subject),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(uploadList[index].title),
                                Text(uploadList[index].sem),
                              ],
                            ),
                            leading: Icon(
                              Icons.file_present_sharp,
                              size: 50,
                              color: Colors.red,
                            ),
                            trailing: widget.role == 'admin'
                                ? IconButton(
                                    onPressed: () async {
                                      bool confirmDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirm Delete'),
                                            content: Text(
                                                'Are you sure you want to delete this document?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // User tapped No
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      true); // User tapped Yes
                                                },
                                                child: Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (confirmDelete == true) {
                                        // User tapped Yes, delete the document
                                        CollectionReference studyMaterialsRef =
                                            FirebaseFirestore.instance
                                                .collection('studymaterials');

                                        // Fetch documents from the collection
                                        QuerySnapshot querySnapshot =
                                            await studyMaterialsRef.get();

                                        //getDocumentId
                                        List<String> documentIds = querySnapshot
                                            .docs
                                            .map((doc) => doc.id)
                                            .toList();
                                        provider.deleteDocument(
                                            'studymaterials',
                                            documentIds[index]);
                                        setState(() {
                                          studyMaterialsFuture =
                                              fetchStudyMaterials();
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                  )
                                : SizedBox(),
                            onTap: () {
                              print('taped on pdf');

                              provider.navigation(
                                  context,
                                  Pdf(
                                    url: uploadList[index].file,
                                  ));
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
