import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/login_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Hero(
                  tag: "logoAnimate",
                  child: Image.asset(
                    "assets/images/logo.png",
                    color: Colors.yellow,
                    height: 80,
                  ),
                ),
                Text(
                  "Flash Chat",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 45),
                ),
              ],
            ),
            SizedBox(height: 30),
            WelcomeScreenButton(
              buttonText: "Log In",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen())),
            ),
            WelcomeScreenButton(
              buttonText: "Register",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen())),
            )
          ],
        ),
      ),
    );
  }
}
