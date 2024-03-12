import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:stdproject/provider/myProvider.dart';

class Message {
  final String text;
  final bool isQuestion;

  Message(this.text, this.isQuestion);
}

class AiScreen extends StatefulWidget {
  AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final gemini = Gemini.instance;
  List<Message> chatHistory = [];
  final TextEditingController inputController = TextEditingController();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text('Ai Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Expanded(
              child: ListView.builder(
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  Message message = chatHistory[index];
                  return Align(
                    alignment: message.isQuestion
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: message.isQuestion
                            ? Colors.blue[200]
                            : Colors.green[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message.text),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: inputController,
                      decoration: InputDecoration(
                        labelText: 'Ask something here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (inputController.text.isNotEmpty) {
                         setState(() {
                        isSending = true;
                      });
                      await sendDatatoAi();
                      setState(() {
                        isSending = false;
                      });
                      }
                     
                    },
                    icon: isSending
                        ? Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2,),
                          )
                        : Icon(
                            Icons.send,
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendDatatoAi() async {
    String question = inputController.text;
    chatHistory.add(Message(question, true));
    inputController.clear();

    try {
      var result = await gemini.text(question);
      String response = result?.output ?? 'Something went wrong';
      chatHistory.add(Message(response, false));
    } catch (e) {
      Provider.of<MyProvider>(context).showSnackbar(context, e.toString(), Colors.red);
      print(e);
    }

    setState(() {});
  }
}
