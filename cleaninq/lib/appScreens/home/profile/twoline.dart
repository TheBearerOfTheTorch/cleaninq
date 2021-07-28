import 'package:flutter/cupertino.dart';

class TwoLineItem extends StatelessWidget {
  final String firstText, secondText;

  TwoLineItem({Key? key, required this.firstText, required this.secondText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: TextStyle(
            fontSize: 20
          ),
        ),
        Text(
          secondText,
          style: TextStyle(
              fontSize: 20
          ),
        ),
      ],
    );
  }
}