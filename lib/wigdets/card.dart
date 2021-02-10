import 'package:flutter/material.dart';

card(text, page, _icon, color, context) {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page))
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(_icon, size: 70.0, color: color),
            Text(
              text,
              style: new TextStyle(fontFamily: 'Montserrat', fontSize: 13),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    ),
  );
}
