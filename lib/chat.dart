import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

bool isTyping = false;
bool isTyping0 = false;
bool isTyping1 = false;
bool isTyping2 = false;

class Chat extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Chat> {
  final ScrollController _scrollController = ScrollController();
  Color biscuitGrey = const Color.fromRGBO(47, 47, 47, 1.0);
  Color BiscuitOrange = const Color.fromRGBO(240, 174, 131, 1.0);
  final List<Map<String, dynamic>> messages = [];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) async {
    String url = 'https://react.biscuitbobby.me/chat';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"text": message};

    setState(() {
      messages.add({'text': message, 'isMe': true, 'icon': 'assets/user.png'});
    });
    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });

    isTyping = true;

    Timer blink = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        isTyping0 = !isTyping0;
      });
    });
    Timer blink1 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      Future.delayed(const Duration(milliseconds: 250)).then((value) {
        setState(() {
          isTyping1 = !isTyping1;
        });
      });
    });
    Timer blink2 = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      Future.delayed(const Duration(milliseconds: 450)).then((value) {
        setState(() {
          isTyping2 = !isTyping2;
        });
      });
    });

    http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String responseMessage = responseData['text'];

      setState(() {
        messages.add({
          'text': responseMessage,
          'isMe': false,
          'icon': 'assets/logo.png'
        });
      });

      _messageController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    } else {
      setState(() {
        messages.add({
          'text': 'Unable to reach server \n[Error: ${response.statusCode}]',
          'isMe': false,
          'icon': 'assets/logo.png'
        });
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
    isTyping = false;
    blink.cancel();
    blink1.cancel();
    blink2.cancel();
    isTyping0 = false;
    isTyping1 = false;
    isTyping2 = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: biscuitGrey,
      ),
      body: Container(
        color: biscuitGrey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Container(
                    alignment: message['isMe']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!message['isMe'])
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 21.0,
                                backgroundImage: AssetImage(
                                  message['icon'],
                                ),
                              ),
                            ),
                          Expanded(
                              child: Container(
                                  alignment: message['isMe']
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                125,
                                      ),
                                      decoration: BoxDecoration(
                                        color: message['isMe']
                                            ? BiscuitOrange
                                            : Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8.0),
                                      child: Text(
                                        message['text'],
                                        style: TextStyle(fontSize: 16.0),
                                      )))),
                        ]),
                  );
                },
              ),
            ),
            Visibility(
              visible: isTyping,
              child: Row(
                children: [
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 15)),
                  Visibility(
                    visible: isTyping0,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RefreshProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isTyping1,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RefreshProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isTyping2,
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RefreshProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: BiscuitOrange,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        String message = _messageController.text;
                        if (message.isNotEmpty) {
                          _sendMessage(message);
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
