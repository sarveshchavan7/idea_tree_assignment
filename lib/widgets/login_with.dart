import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class LoginWithBtn extends StatelessWidget {
  final String imgUrl;
  final String btnText;
  final Function onPressed;
  LoginWithBtn(
      {@required this.imgUrl,
      @required this.btnText,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 325,
      child: FlatButton(
        color: Color(0xfffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(imgUrl),
            SizedBox(
              width: 10,
            ),
            Text(btnText),
          ],
        ),
      ),
    );
  }
}
