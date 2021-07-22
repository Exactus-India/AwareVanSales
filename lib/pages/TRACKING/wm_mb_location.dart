import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/TRACKING/wm_mb_mapview.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../wm_mb_LoginPage.dart';

class Location extends StatefulWidget {
  final toPage;
  const Location({Key key, this.toPage}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List _datas = List();
  List _datasForDisplay = List();
  List user_list = [];
  bool _timer_ = false;
  bool loading = false;
  int list_length;
  var _selectedDate;
  var user_selected;

  @override
  void initState() {
    getdatas(gs_date, gs_currentUser);
    getAllUserName().then(
      (value) {
        setState(() {
          user_list.clear();
          user_list.addAll(value);
          user_list.sort((a, b) => a['RPT_NAME'].compareTo(b['RPT_NAME']));
        });
      },
    );
    super.initState();
  }

  getdatas(getdate, user) {
    return salesman_tracking(getdate, user).then((value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TRACKING", style: TextStyle(color: Colors.white)),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: [
          RaisedButton(
            onPressed: () {
              setState(() {
                getdatas(_selectedDate, user_selected);
              });
            },
            child: Text('RETRIEVE'),
          )
        ],
      ),
      body: (loading == false)
          ? spinkitLoading()
          : Column(children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0),
                  child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
              _selection(),
              SizedBox(height: 5.0),
              if (_timer_ == true)
                if (list_length == 0) noValue(),
              if (_timer_ == true)
                Expanded(child: listView(_datasForDisplay, widget.toPage)),
            ]),
    );
  }

  dropDown_username() {
    return DropdownButton(
        isExpanded: true,
        value: user_selected,
        hint: Text('Select Username'),
        items: user_list.map((list) {
          return DropdownMenuItem(
              child: Text(list['RPT_NAME']),
              value: list['RPT_NAME'].toString());
        }).toList(),
        onChanged: (value) {
          setState(() {
            user_selected = value;
          });
          print(user_selected);
        });
  }

  _selection() {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            Flexible(flex: 2, child: dropDown_username()),
          ],
        ),
      ),
    );
  }

  listView(List datasForDisplay, toPage) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var val3;
        // datasForDisplay[index].val3 is num
        //     ? val3 = getNumberFormat(datasForDisplay[index].val3)
        //     : val3 = datasForDisplay[index].val3;
        if (val3 == null) val3 = " ";
        return Card(
          color: Colors.lightBlue[50],
          child: ListTile(
            subtitle: Column(
              children: <Widget>[
                // if (datasForDisplay[index].val1 != null)
                //   align(Alignment.centerRight,
                //       datasForDisplay[index].val1.toString(), 14.0),
                if (datasForDisplay[index].val2 != null)
                  align(Alignment.centerRight,
                      datasForDisplay[index].val2.toString(), 14.0),
                if (datasForDisplay[index].val3 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val3.toString(), 14.0),
                if (datasForDisplay[index].val4 != null)
                  align(
                      Alignment.centerLeft,
                      "DOC TYPE: " + datasForDisplay[index].val4.toString(),
                      14.0),
                if (datasForDisplay[index].val9 != null)
                  align(
                      Alignment.centerLeft,
                      datasForDisplay[index].val9.toString() +
                          "   " +
                          datasForDisplay[index].val10.toString(),
                      14.0),
              ],
            ),
            onTap: () {
              if (datasForDisplay[index].val5.toString() != " " ||
                  datasForDisplay[index].val5.toString() != null) {
                setState(() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MapView(
                        latitude: double.parse(
                            datasForDisplay[index].val5.toString()),
                        longitude: double.parse(
                            datasForDisplay[index].val6.toString()),
                        loc_addr: datasForDisplay[index].val3.toString(),
                      ),
                    ),
                  );
                });
              } else {
                // Navigator.of(context).pop(true);
                setState(() {
                  alert(context, "_msg", Colors.red);
                });
                // alert(context, "Status not available", Colors.red);
              }
            },
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }

  rowData_2(String string, String string2, double d) {}
}
