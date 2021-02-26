import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

columnRow(val, pos, size, talign) {
  return Column(
    mainAxisAlignment: pos,
    children: <Widget>[textData(val, Colors.black, size)],
  );
}

rowData_3(first, middle, last, clr, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      columnRow(
          first.toString(), MainAxisAlignment.start, size, TextAlign.left),
      if (middle != null)
        columnRow(middle.toString(), MainAxisAlignment.center, size,
            TextAlign.center),
      if (last != null)
        columnRow(
            last.toString(), MainAxisAlignment.end, size, TextAlign.right),
    ],
  );
}

rowData_2(first, last, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      if (first != null || first != 'null')
        columnRow(
            first.toString(), MainAxisAlignment.start, size, TextAlign.left),
      if (last != null || last != 'null')
        columnRow(
            last.toString(), MainAxisAlignment.end, size, TextAlign.right),
    ],
  );
}

rowData3(first, middle, last, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(
              first.toString(), MainAxisAlignment.start, size, TextAlign.left)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(middle.toString(), MainAxisAlignment.center, size,
              TextAlign.center)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(last.toString(), MainAxisAlignment.spaceEvenly, size,
              TextAlign.right)),
    ],
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

listView_row_3_fields(List datasForDisplay, container_height) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Container(
        height: container_height,
        child: Card(
          child: ListTile(
            subtitle: rowData3(
                datasForDisplay[index].val1.toString(),
                datasForDisplay[index].val2.toString(),
                datasForDisplay[index].val3.toString(),
                14.0),
          ),
        ),
      );
    },
    itemCount: datasForDisplay.length,
  );
}
