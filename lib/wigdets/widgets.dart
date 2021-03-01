import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

Widget logo() {
  return Container(
    height: 150,
    child: Image.asset('assets/exactus_logo.png', width: 200, height: 65),
  );
}

textField(_text, _controller, _validate, read) {
  bool obs = false;
  if (_text == 'Password') obs = true;
  return TextField(
    readOnly: read,
    obscureText: obs,
    decoration: InputDecoration(
        labelText: _text,
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        focusColor: Colors.blue,
        labelStyle: TextStyle(color: Colors.black54)),
    controller: _controller,
  );
}

Widget text(_text, clr) {
  return Text(
    _text,
    style: TextStyle(
        fontFamily: 'Montserrat', fontWeight: FontWeight.bold, color: clr),
  );
}

textData(_text, clr, size) {
  return Text(
    _text,
    style: TextStyle(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        color: clr,
        fontSize: size),
  );
}

columnRow(val, cross_pos, pos, size, talign) {
  return Column(
    mainAxisAlignment: pos,
    crossAxisAlignment: cross_pos,
    children: <Widget>[textData(val, Colors.black, size)],
  );
}

columnRow1(val, pos, size, talign, color) {
  return Column(
    mainAxisAlignment: pos,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[textData(val, color, size)],
  );
}

noValue() {
  return Padding(
    padding: EdgeInsets.only(top: 100.0),
    child: textData("No Records Found", Colors.red, 22.0),
  );
}

align(alignment, _text, size) {
  if (_text == 'null' || _text == null) _text = ' ';
  return Align(
    alignment: alignment,
    child: textData(_text, Colors.black, size),
  );
}

labelWidget(clr, _controller) {
  return TextField(
    style: TextStyle(color: clr),
    decoration: InputDecoration(
      border: InputBorder.none,
    ),
    controller: _controller,
  );
}

showToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0);
}
