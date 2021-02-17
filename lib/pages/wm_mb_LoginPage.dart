import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_HomePage.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class Wm_mb_LoginPage extends StatefulWidget {
  @override
  _Wm_mb_LoginPageState createState() => _Wm_mb_LoginPageState();
}

String message;
String gs_Route;
String gs_currentUser;
String gs_currentUser_empid;

class _Wm_mb_LoginPageState extends State<Wm_mb_LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List user_list = List();
  List route_list = List();

  TextEditingController _password = new TextEditingController();
  String selectedUser;
  String selectedRoute;

  bool _validatePassword = false;
  @override
  void initState() {
    _password.clear();
    getAllUserName().then((value) {
      setState(() {
        user_list.addAll(value);
        user_list.sort((a, b) => a['RPT_NAME'].compareTo(b['RPT_NAME']));
      });
    });
    getAllRouteName().then((value) {
      setState(() {
        route_list.addAll(value);
        route_list.sort((a, b) => a['ROUTE_NAME'].compareTo(b['ROUTE_NAME']));
      });
    });
    super.initState();
  }

  dropDown_username() {
    return DropdownButton(
        isExpanded: true,
        value: selectedUser,
        hint: Text('Select Username'),
        items: user_list.map((list) {
          return DropdownMenuItem(
              child: Text(list['RPT_NAME']),
              value: list['RPT_NAME'].toString());
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedUser = value;
          });
          print(selectedUser);
        });
  }

  dropDown_route() {
    return DropdownButton(
        isExpanded: true,
        value: selectedRoute,
        hint: Text('Select Route'),
        items: route_list.map((list) {
          return DropdownMenuItem(
              child: Text(list['ROUTE_NAME']),
              value: list['ROUTE_NAME'].toString());
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRoute = value;
          });
          print(selectedRoute);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Aware Van Sales", Colors.white),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                // --------------------Key----------------------
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo(),
                    SizedBox(height: 20.0),
                    Container(
                      child: Column(
                        children: <Widget>[
                          dropDown_username(),
                          SizedBox(height: 10.0),
                          textField(
                              "Password", _password, _validatePassword, false),
                          SizedBox(height: 10.0),
                          dropDown_route(),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0),
                    loginButton()
                  ],
                ),
              ),
            ),
          )),
    );
  }

  loginButton() {
    return ButtonTheme(
        minWidth: 105.0,
        height: 45.0,
        child: new RaisedButton(
            color: Colors.green,
            hoverColor: Colors.green[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23.0),
            ),
            child: text('Login', Colors.white),
            onPressed: () async {
              if (_password.text.isEmpty) {
                setState(() {
                  _password.text.isEmpty
                      ? _validatePassword = true
                      : _validatePassword = false;
                });
              } else {
                // ---------------------Login Success--------------------------
                setState(() {
                  message = 'Loading....';
                });
                var resp =
                    await loginCheck(selectedUser.toString(), _password.text);
                if (resp == 1) {
                  setState(() {
                    message = "Login Success";
                  });
                  gs_currentUser = selectedUser.toString();
                  gs_currentUser_empid = _password.text;
                  gs_Route = selectedRoute.toString();
                  if (gs_Route == 'null') gs_Route = 'All';
                  print(gs_Route + '.....');

                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()))
                      .then((value) {
                    _password.clear();
                    user_list.clear();
                    route_list.clear();
                  });
                } else if (resp == 0) {
                  setState(() {
                    message = 'No Internet Connection';
                  });
                  alert(context, message, Colors.green);
                }
                // ------------------Incorrect-------------------
                else if (resp == 2) {
                  setState(() {
                    message = 'User id or Password Incorrect';
                  });
                  alert(context, message, Colors.red);
                }
              }
            }));
  }
}
