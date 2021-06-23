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

textField1(_text, _controller, _validate, read, align) {
  return Container(
    height: 40.0,
    child: TextField(
      textAlign: align,
      readOnly: read,
      style: TextStyle(fontSize: 13),
      decoration: InputDecoration(
          labelText: _text,
          border: const OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10),
          errorText: _validate ? 'Value Can\'t Be Empty' : null,
          focusColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.black54)),
      controller: _controller,
    ),
  );
}

textArea(_text, _controller, _validate, read, maxlength, max) {
  bool obs = false;
  if (_text == 'Password') obs = true;
  return TextField(
    maxLength: maxlength,
    maxLines: max,
    keyboardType: TextInputType.multiline,
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

alignCon(alignment, _text, size) {
  if (_text == 'null' || _text == null) _text = ' ';
  return Align(
    alignment: alignment,
    child: textData(_text, Colors.red, size),
  );
}

labelWidget(clr, _controller, size) {
  return Container(
      height: 30.0,
      child: TextField(
        readOnly: true,
        style: TextStyle(color: clr, fontSize: size),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        controller: _controller,
      ));
}

showToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

textBold(_text) {
  return Text(
    _text,
    style: TextStyle(fontWeight: FontWeight.bold),
  );
}

getNumberFormat(number) {
  return NumberFormat("#,##,##0.00", "en_US").format(number);
}

getNumberFormatRound(number) {
  return NumberFormat("#,##,##0", "en_US").format(number);
}

numberWithCommas(x) {
  return x.toString().replaceAll(',', '');
}

textTitle(
    _text1, _text2, clr1, clr2, tsize1, tsize2, talign, cwidth, cheight, pval) {
  return Container(
    padding: EdgeInsets.only(top: pval),
    child: Center(
      child: Container(
        height: cheight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text_1(_text1, clr1, tsize1, talign),
            text_1(_text2, clr2, tsize2, talign)
          ],
        ),
      ),
    ),
  );
}

text_1(_text, clr, size, talign) {
  return Text(
    _text,
    textAlign: talign,
    style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: clr),
  );
}

String newDocNo() {
  var doc_no;
  var ls_date = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
  var ls_mth_code = ls_date[6] + ls_date[8] + ls_date[9];
  ls_mth_code = ls_mth_code + "10";
  doc_no = ls_mth_code.toString() + "0001";
  return doc_no;
}
