import 'package:flutter/material.dart';

class WelcomeScreenButton extends StatelessWidget {
  WelcomeScreenButton({@required this.buttonText, @required this.onTap});
  String buttonText;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 18),
        child: Card(
          color: Colors.lightBlue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
