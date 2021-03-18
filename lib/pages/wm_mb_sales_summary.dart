import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../wigdets/widget_litView_row.dart';
import '../wigdets/widget_rowData.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';
import '../data/future_db.dart';

class SalesSummary extends StatefulWidget {
  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);
String datelabelformatter = gs_date;

class _SalesSummaryState extends State<SalesSummary> {
  TextEditingController date = TextEditingController();
  int totalCash = 0;
  List salesumm_1 = List();
  List salesumm_2 = List();

  String finalDate = '';
  var _selectedDate;

  TextEditingController _datecontroller = new TextEditingController();
  TextEditingController userid = new TextEditingController();

  @override
  void initState() {
    _selectedDate = gs_date;
    userid.text = gs_currentUser_empid.toString();
    super.initState();
  }

  retrive() {
    salesumm_1.clear();
    salesumm_2.clear();
    return sales_sum_pro(_selectedDate, userid.text).then((value) {
      print("init" + _selectedDate);
      sales_sum1().then((value) {
        setState(() {
          salesumm_1.addAll(value);
          print("summary1 list length " + salesumm_1.length.toString());
        });
      });
      sales_sum2().then((value) {
        setState(() {
          salesumm_2.addAll(value);
          print(salesumm_2);
          print("summary2 list length " + salesumm_2.length.toString());
        });
      });
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((datePicker) {
      print(datePicker);
      setState(() {
        _selectedDate = DateFormat("dd-MMM-yyyy").format(datePicker);
      });
      print(_selectedDate);
    });
  }

  textFieldDate(_text, _controller, _validate, read) {
    return TextField(
      // onTap: () => _presentDatePicker(),
      readOnly: read,
      decoration: InputDecoration(
        labelText: _text,
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        focusColor: Colors.blue,
        labelStyle: TextStyle(color: Colors.black54),
      ),
      controller: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Summary'),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: RaisedButton(
              color: Colors.green[400],
              onPressed: () {
                retrive();
              },
              child: Text('Retrive'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: new Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15.0),
              child: align(Alignment.topLeft, gs_currentUser, 18.0),
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Text(_selectedDate == null ? gs_date : _selectedDate),
                          IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                size: 30.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  _presentDatePicker();
                                });
                              })
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      child: textFieldDate("salesmanid", userid, false, false)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (salesumm_1.isNotEmpty)
              Container(
                  height: 120,
                  width: 400,
                  color: Colors.lightBlue[100],
                  child: listView_row_3_fields(salesumm_1, 40.0)),
            if (salesumm_2.isNotEmpty)
              SizedBox(
                height: 30,
              ),
            rowData4("Sl.No", "Description   ", " Items", "Amount      ", 14.0),
            SizedBox(height: 10),
            Container(
              height: 1000,
              width: 500,
              color: Colors.lightBlue[100],
              child: listView_row_4_fields(salesumm_2),
            ),
          ],
        ),
      )),
    );
  }
}
