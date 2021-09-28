import 'package:firebasechat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebasechat/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

User loggedUser;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.name});

  final String name;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final textEditionController = TextEditingController();

  String message;
  String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final _registerdUser = _auth.currentUser;
      if (_registerdUser != null) {
        loggedUser = _registerdUser;
        // userName = widget.name;
      }
      // print(loggedUser.email);
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (route) => false);
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
            Stream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditionController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        message = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      //Implement send functionality.

                      textEditionController.clear();

                      try {
                        await _firestore.collection('messages').add({
                          'sender': loggedUser.email,
                          'text': message,
                          'name': widget.name,
                          'time': FieldValue.serverTimestamp(),
                        });
                      } on Exception catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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

class Stream extends StatelessWidget {
  const Stream({
    Key key,
    @required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot) {
          List<MessageBuble> chatData = [];
          if (!AsyncSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final data = AsyncSnapshot?.data?.docs.reversed ?? '';

          for (var message in data) {
            final messageText = message?.get('text') ?? '';
            final senderEmail = message?.get('sender') ?? '';
            final senderName = message?.get('name') ?? '';

            final currentUser = loggedUser.email;

            final chatDataWidget = MessageBuble(
                messageText: messageText,
                senderEmail: senderEmail,
                senderName: senderName,
                isMe: currentUser == senderEmail);

            chatData.add(chatDataWidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              children: chatData,
            ),
          );
        });
  }
}

class MessageBuble extends StatelessWidget {
  MessageBuble({
    this.messageText,
    this.senderEmail,
    this.isMe,
    this.senderName,
  });
  String messageText;
  String senderEmail;
  bool isMe;
  // final Timestamp time; // add this
  String senderName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 13, right: 13),
            child: Text(
              '$senderEmail',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          SizedBox(height: 5.0),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Text(
                '$messageText',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
