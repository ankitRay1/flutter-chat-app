import 'package:firebasechat/screens/login_screen.dart';
import 'package:firebasechat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/login_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/constant.dart';

import 'chat_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedUser;
  String name;
  String email;
  String password;
  String confirmPassword;

  void getCurrentUser() {
    final _registerdUser = _auth.currentUser;
    if (_registerdUser != null) {
      loggedUser = _registerdUser;
    }
    print(loggedUser.email);
  }

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
    // getCurrentUser();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                name = value;
              },
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black),
              enableSuggestions: true,
              decoration:
                  KTextFielddecoration.copyWith(hintText: "Enter Your name"),
            ),
            SizedBox(height: 15),
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
              enableSuggestions: true,
              decoration:
                  KTextFielddecoration.copyWith(hintText: "Enter your email"),
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
            SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: (value) {
                confirmPassword = value;
              },
              obscureText: true,
              style: TextStyle(color: Colors.black),
              enableSuggestions: true,
              decoration: KTextFielddecoration.copyWith(
                  hintText: "Enter Your Password"),
            ),
            SizedBox(height: 22),
            WelcomeScreenButton(
                buttonText: "Register",
                onTap: () async {
                  if (email != null &&
                      email.contains('@') &&
                      password.length >= 6 &&
                      confirmPassword == password) {
                    try {
                      final registerUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      registerUser.additionalUserInfo;

                      if (registerUser != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(name: name)));
                      }
                    } on Exception catch (e) {
                      // TODO
                      showSnacbar("$e");
                    }
                  } else if (email != null && confirmPassword != password) {
                    showSnacbar("Please check password and  email");
                  } else if (password.length < 6 &&
                      confirmPassword != password) {
                    showSnacbar("Password should be greator than 5 digits");
                  } else {
                    showSnacbar("Please check the details again");
                  }
                }),
            WelcomeScreenButton(
                buttonText: "Return to Login",
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())))
          ],
        ),
      ),
    );
  }
}
