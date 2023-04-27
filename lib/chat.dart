import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color biscuitGrey = Color.fromRGBO(47, 47, 47, 1.0);
  final List<Map<String, dynamic>> messages = [];

  TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) async {
    String url = 'http://localhost:3000/chat';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"text": message};

    setState(() {
      messages.add({'text': message, 'isMe': true});
    });
    _messageController.clear();

    http.Response response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String responseMessage = responseData['text'];

      setState(() {
        messages.add({'text': responseMessage, 'isMe': false});
      });

      _messageController.clear();
    } else {
      setState(() {
        messages.add({'text': 'Error: ${response.statusCode}', 'isMe': false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: biscuitGrey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Container(
                    alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: message['isMe'] ? Colors.green[300] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Text(
                        message['text'],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = _messageController.text;
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
