import 'package:flutter/material.dart';

card(text, page, color, context, image) {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () => {
        page != null
            ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => page))
            : null
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset('assets/icons/$image', width: 150, height: 100),
            // Icon(_icon, size: 70.0, color: color),
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
