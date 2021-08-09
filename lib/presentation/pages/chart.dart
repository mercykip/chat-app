import 'package:chatting_app/application/themes/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatefulWidget {
  ChatApp({Key? key}) : super(key: key);
  static String id = 'chat';
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late String messageText;
  late User loggedInUser;

  final messageTextController = TextEditingController();

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() {
    _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  // _auth.signOut();
                  // Navigator.pop(context);
                  logout();
                  //   getMessages();
                  //Implement logout functionality
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('message')
                    .orderBy('created', descending: true)
                    .snapshots(),

                ///flutter aysnc snapshot
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  List<MessageBubble> messageWidgets = [];

                  /// reversed changes the order of the list and
                  ///  the latest added data will be displayed at the bottom of the screen
                  final messages = snapshot.data!.docs;

                  for (var message in messages) {
                    final messageText = (message.data() as dynamic)['message'];

                    final messageSender = (message.data() as dynamic)['sender'];
                    final currentUser = loggedInUser.email;

                    final messageBubble = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isLoggedIn: currentUser == messageSender,
                    );
                    messageWidgets.add(messageBubble);
                  }

                  return Expanded(
                    child: ListView(
                      ///makes the latest message be onto of a listview
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageWidgets,
                    ),
                  );
                },
                //   ),
                // ],
                //),
              ),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        _fireStore.collection('message').add({
                          'message': messageText,
                          'sender': loggedInUser.email,
                          'created': Timestamp.now(),
                        });
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender, required this.text, required this.isLoggedIn});
  final String sender;
  final String text;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isLoggedIn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender',
              style: TextStyle(fontSize: 15.0, color: Colors.black54)),
          Material(
              elevation: 5.0,
              borderRadius: isLoggedIn
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)),
              color: isLoggedIn ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$text',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: isLoggedIn ? Colors.white : Colors.black,
                    )),
              )),
        ],
      ),
    );
  }
}
