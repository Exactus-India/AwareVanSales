import 'package:flutter/material.dart';

alert(BuildContext context, _msg, _clr) {
  Widget okButton = FlatButton(
    child: Text("OK",
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
        )),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      _msg,
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: _clr[700]),
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
