import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

BuildContext context;
getContext(conText) {
  context = conText;
}

Future<bool> onWillPop() async {
  return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to Sign Out?'),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('No'),
            ),
            new ElevatedButton(
              onPressed: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              // onPressed: () => Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => LoginPage())),
              child: new Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}

DateTime backButtonPressedTime;

Future<bool> onBackPress() async {
  DateTime currentTime = DateTime.now();
  bool backButton = backButtonPressedTime == null ||
      currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);

  if (backButton) {
    backButtonPressedTime = currentTime;
    Fluttertoast.showToast(
        msg: "Double Click to Exit App",
        backgroundColor: Colors.black,
        textColor: Colors.white);
    return false;
  }
  return true;
}
