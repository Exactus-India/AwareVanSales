import 'dart:convert';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../wm_mb_LoginPage.dart';

class Log_details extends StatefulWidget {
  const Log_details({Key key}) : super(key: key);

  @override
  _Log_detailsState createState() => _Log_detailsState();
}

class _Log_detailsState extends State<Log_details> {
  TextEditingController customer_remarks = TextEditingController();
  String Customer;
  List _datas = List();
  List _datasForDisplay = List();
  bool _timer_ = false;
  bool loading = false;
  int list_length;
  List<String> cus = ["Data", "Carryon", "Come in"];

  bool isSwitched = false;
  var textValue = ' ';

  @override
  void initState() {
    customerlist().then((value) {
      _datas.clear();
      _datasForDisplay.clear();
      setState(() {
        _datas.addAll(value);
        loading = true;
        _datasForDisplay = _datas;

        list_length = 0;
        list_length = _datas.length;
        print(list_length.toString() + '....');
        _timer_ = true;
      });
    });
    super.initState();
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      currentPosition = position;
      geoLocation = "${position.latitude},${position.longitude}";

      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        // _currentAddress = "${place.locality}, ${place.country}";
        currentAddress =
            "${place.name},${place.street},${place.locality}, ${place.postalCode},${place.administrativeArea}, ${place.country}";
        country_name = '${place.country}';
      });
      print(currentAddress);
    } catch (e) {
      print(e);
    }
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'VISITED';
        _getCurrentLocation();
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = ' ';
      });
      print('Switch Button is OFF');
    }
  }

  textField(_text, _controller, _validate, read) {
    bool obs = false;
    if (_text == 'Password') obs = true;
    return TextField(
      minLines: 1,
      maxLines: 5,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOG ENTRY"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: GestureDetector(
              onTap: () {
                gs_date_insert =
                    DateFormat("dd-MMM-yyyy kk:mm:ss").format(DateTime.now());
                print(Customer);
                print('Customer');
                print(customer_remarks.text);
                log_details(
                        geoLocation,
                        brand,
                        model.split('_')[0],
                        ipAddress,
                        currentAddress,
                        ' ',
                        gs_date_insert,
                        Customer,
                        customer_remarks.text,
                        country_name)
                    .then((value) {
                  if (value == 1) showToast("Updated successfully");
                });
              },
              child: Icon(
                Icons.save,
                size: 28,
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // DropDownField(
              //     onValueChanged: (dynamic value) {
              //       Customer = value;
              //     },
              //     value: Customer,
              //     required: false,
              //     hintText: 'Select the Customer',
              //     labelText: 'Customer',
              //     items: cus),
              DropdownButton(
                  isExpanded: true,
                  value: Customer,
                  menuMaxHeight: 400.2,
                  hint: Text('Select Customer'),
                  items: _datas.map((list) {
                    print(list.length);
                    return DropdownMenuItem(
                        child: Text(list['AC_NAME']),
                        value: list['AC_NAME'].toString());
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      Customer = value;
                    });
                    print(Customer);
                  }),
              SizedBox(
                height: 10,
              ),
              textField(
                "Customer Remarks",
                customer_remarks,
                false,
                false,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$textValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    // activeColor: Colors.blue,
                    // activeTrackColor: Colors.yellow,
                    // inactiveThumbColor: Colors.redAccent,
                    // inactiveTrackColor: Colors.orange,
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
