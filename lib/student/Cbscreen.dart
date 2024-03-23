import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/customWidgets/pdf.dart';
import 'package:stdproject/model/dataModel.dart';

import 'package:stdproject/provider/myProvider.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  ScrollController _scrollController = ScrollController();
  String? selectedSem;
  String? selectedModule;
  String? selectedSubject;
  List<StudyMaterial> studyMaterialList = [];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);

    // Scroll to the end of the ListView when it is rebuilt
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edubot'),
        actions: [
          IconButton(
              onPressed: () {
                provider.clearChat();
              },
              icon: Icon(Icons.rotate_left_sharp))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/chatbg.png'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //List the Widgets
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.widgetList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [provider.widgetList[index]],
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.0),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // add sem LIst
                            provider.click();
                            provider.text == 'EXIT'
                                ? provider.addWidget(SizedBox(
                                    height: 20,
                                  ))
                                : SizedBox();
                            provider.text == 'EXIT'
                                ? provider.addWidget(Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.8,
                                    child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 0,
                                        crossAxisSpacing: 0,
                                        childAspectRatio: 2.5,
                                      ),
                                      itemCount: provider.semList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              padding: EdgeInsets.zero,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    String selectedYear =
                                                        provider.semList[index];
                                                    selectedSem = selectedYear;
                                                    provider.addWidget(Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              selectedYear,
                                                            ),
                                                          )),
                                                    ));
                                                    List<String>
                                                        selectedSubList = [];
                                                    if (selectedYear ==
                                                        'sem 1') {
                                                      selectedSubList =
                                                          provider.sem1sub;
                                                    } else if (selectedYear ==
                                                        'sem 2') {
                                                      selectedSubList =
                                                          provider.sem2sub;
                                                    } else if (selectedYear ==
                                                        'sem 3') {
                                                      selectedSubList =
                                                          provider.sem3sub;
                                                    } else if (selectedYear ==
                                                        'sem 4') {
                                                      selectedSubList =
                                                          provider.sem4sub;
                                                    } else if (selectedYear ==
                                                        'sem 5') {
                                                      selectedSubList =
                                                          provider.sem5sub;
                                                    } else if (selectedYear ==
                                                        'sem 6') {
                                                      selectedSubList =
                                                          provider.sem6sub;
                                                    }

                                                    provider.addWidget(
                                                      Column(
                                                        children: [
                                                          Container(
                                                            height:
                                                                selectedSubList
                                                                        .length *
                                                                    80,
                                                            child: ListView
                                                                .builder(
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  selectedSubList
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              200,
                                                                          child: ElevatedButton(
                                                                              onPressed: () {
                                                                                if (selectedSubList[index] == 'ELECTIVE') {
                                                                                  provider.addWidget(Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: Card(
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(selectedSubList[index]),
                                                                                        )),
                                                                                  ));

                                                                                  provider.addWidget(Container(
                                                                                    height: provider.openElective.length * 70,
                                                                                    child: ListView.builder(
                                                                                      physics: NeverScrollableScrollPhysics(),
                                                                                      itemCount: provider.openElective.length,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        return Column(
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: Alignment.topLeft,
                                                                                              child: Container(
                                                                                                height: 50,
                                                                                                width: 200,
                                                                                                margin: EdgeInsets.all(5),
                                                                                                child: ElevatedButton(
                                                                                                    onPressed: () {
                                                                                                      provider.addWidget(Align(
                                                                                                        alignment: Alignment.topRight,
                                                                                                        child: Card(
                                                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                              child: Text(provider.openElective[index]),
                                                                                                            )),
                                                                                                      ));
                                                                                                      selectedSubject = provider.openElective[index];
                                                                                                      provider.addWidget(Container(
                                                                                                        height: provider.moduleList.length * 80,
                                                                                                        child: ListView.builder(
                                                                                                          physics: NeverScrollableScrollPhysics(),
                                                                                                          itemCount: provider.moduleList.length,
                                                                                                          itemBuilder: (BuildContext context, int index) {
                                                                                                            return Column(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.topLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                                    child: Container(
                                                                                                                        height: 50,
                                                                                                                        width: 150,
                                                                                                                        child: ElevatedButton(
                                                                                                                            onPressed: () async {
                                                                                                                              provider.addWidget(Align(
                                                                                                                                alignment: Alignment.topRight,
                                                                                                                                child: Card(
                                                                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                                                                    child: Padding(
                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                      child: Text(provider.moduleList[index]),
                                                                                                                                    )),
                                                                                                                              ));
                                                                                                                              selectedModule = provider.moduleList[index];
                                                                                                                              studyMaterialList = await provider.getSpesificStudyMaterials(context, selectedSem, selectedSubject, selectedModule);
                                                                                                                              print(selectedSem);
                                                                                                                              print(selectedSubject);
                                                                                                                              print(selectedModule);
                                                                                                                              print(studyMaterialList.length);
                                                                                                                              provider.addWidget(Container(
                                                                                                                                height: studyMaterialList.length * 170,
                                                                                                                                child: ListView.builder(
                                                                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                                                                  itemCount: studyMaterialList.length,
                                                                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                                                                    return Align(
                                                                                                                                      alignment: Alignment.topLeft,
                                                                                                                                      child: Padding(
                                                                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                                                                        child: Column(
                                                                                                                                          children: [
                                                                                                                                            InkWell(
                                                                                                                                              onTap: () {
                                                                                                                                                provider.navigation(context, Pdf(url: studyMaterialList[index].file));
                                                                                                                                              },
                                                                                                                                              child: Card(
                                                                                                                                                child: Padding(
                                                                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                                                                  child: Column(
                                                                                                                                                    children: [
                                                                                                                                                      Icon(Icons.file_copy_rounded),
                                                                                                                                                      SizedBox(
                                                                                                                                                        height: 3,
                                                                                                                                                      ),
                                                                                                                                                      Text(studyMaterialList[index].title),
                                                                                                                                                    ],
                                                                                                                                                  ),
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                            TextButton(
                                                                                                                                                onPressed: () async {
                                                                                                                                                  await provider.downloadFile(studyMaterialList[index].file, context, studyMaterialList[index].subject + studyMaterialList[index].title);
                                                                                                                                                },
                                                                                                                                                child: Text('Download')),
                                                                                                                                            SizedBox(
                                                                                                                                              height: 8,
                                                                                                                                            )
                                                                                                                                          ],
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                    );
                                                                                                                                  },
                                                                                                                                ),
                                                                                                                              ));
                                                                                                                            },
                                                                                                                            child: Text(provider.moduleList[index]))),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  height: 8,
                                                                                                                )
                                                                                                              ],
                                                                                                            );
                                                                                                          },
                                                                                                        ),
                                                                                                      ));
                                                                                                    },
                                                                                                    child: Text(provider.openElective[index])),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ));
                                                                                } else {
                                                                                  provider.addWidget(Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: Card(
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                        child: Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Text(selectedSubList[index]),
                                                                                        )),
                                                                                  ));
                                                                                  selectedSubject = selectedSubList[index];
                                                                                  provider.addWidget(Container(
                                                                                    height: provider.moduleList.length * 80,
                                                                                    child: ListView.builder(
                                                                                      physics: NeverScrollableScrollPhysics(),
                                                                                      itemCount: provider.moduleList.length,
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        return Column(
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: Alignment.topLeft,
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.all(8.0),
                                                                                                child: Container(
                                                                                                    height: 50,
                                                                                                    width: 150,
                                                                                                    child: ElevatedButton(
                                                                                                        onPressed: () async {
                                                                                                          provider.addWidget(Align(
                                                                                                            alignment: Alignment.topRight,
                                                                                                            child: Card(
                                                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                                                                                                child: Padding(
                                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                                  child: Text(provider.moduleList[index]),
                                                                                                                )),
                                                                                                          ));
                                                                                                          selectedModule = provider.moduleList[index];
                                                                                                          studyMaterialList = await provider.getSpesificStudyMaterials(context, selectedSem, selectedSubject, selectedModule);
                                                                                                          print(selectedSem);
                                                                                                          print(selectedSubject);
                                                                                                          print(selectedModule);
                                                                                                          print(studyMaterialList.length);

                                                                                                          provider.addWidget(Container(
                                                                                                            height: studyMaterialList.length * 170,
                                                                                                            child: ListView.builder(
                                                                                                              physics: NeverScrollableScrollPhysics(),
                                                                                                              itemCount: studyMaterialList.length,
                                                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                                                return Align(
                                                                                                                  alignment: Alignment.topLeft,
                                                                                                                  child: Padding(
                                                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                                                    child: Column(
                                                                                                                      children: [
                                                                                                                        InkWell(
                                                                                                                          onTap: () {
                                                                                                                            provider.navigation(context, Pdf(url: studyMaterialList[index].file));
                                                                                                                          },
                                                                                                                          child: Card(
                                                                                                                            child: Padding(
                                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                                              child: Column(
                                                                                                                                children: [
                                                                                                                                  Icon(Icons.file_copy_rounded),
                                                                                                                                  SizedBox(
                                                                                                                                    height: 3,
                                                                                                                                  ),
                                                                                                                                  Text(studyMaterialList[index].title),
                                                                                                                                ],
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        TextButton(
                                                                                                                            onPressed: () async {
                                                                                                                              await provider.downloadFile(studyMaterialList[index].file, context, studyMaterialList[index].subject + studyMaterialList[index].title);
                                                                                                                            },
                                                                                                                            child: Text('Download')),
                                                                                                                        SizedBox(
                                                                                                                          height: 8,
                                                                                                                        )
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                );
                                                                                                              },
                                                                                                            ),
                                                                                                          ));
                                                                                                        },
                                                                                                        child: Text(provider.moduleList[index]))),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 8,
                                                                                            )
                                                                                          ],
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  ));
                                                                                }
                                                                              },
                                                                              child: Text(selectedSubList[index])),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    print(provider
                                                        .widgetList.length);
                                                  },
                                                  child: Text(
                                                      provider.semList[index])),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ))
                                : provider.addWidget(Text('Chat Ended.!',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500)));
                            print(provider.widgetList.length);
                          },
                          child: Text(provider.text),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
