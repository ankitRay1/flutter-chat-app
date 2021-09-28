import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/screens/chat_screen.dart';
import 'package:firebasechat/widgets/login_button.dart';
import 'package:flutter/material.dart';

import 'package:firebasechat/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool progress = false;

  void showSnacbar(String showText) {
    final snackBar = SnackBar(
        content: Text(
      showText,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.center,
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: progress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "logoAnimate",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                enableSuggestions: true,
                decoration:
                    KTextFielddecoration.copyWith(hintText: "Enter Your Email"),
              ),
              SizedBox(height: 15),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                style: TextStyle(color: Colors.black),
                enableSuggestions: true,
                decoration: KTextFielddecoration.copyWith(
                    hintText: "Enter Your Password"),
              ),
              SizedBox(height: 22),
              WelcomeScreenButton(
                  buttonText: "Login",
                  onTap: () async {
                    setState(() {
                      progress = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (user != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen()));
                      }
                      setState(() {
                        print("mai trigger hua");
                        progress = false;
                      });
                    } on Exception catch (e) {
                      setState(() {
                        print("mai trigger hua");
                        progress = false;
                      });

                      showSnacbar("$e");
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
