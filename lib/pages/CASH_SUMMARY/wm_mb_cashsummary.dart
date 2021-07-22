import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/data/os_summ.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:aware_van_sales/wigdets/widget_litView_row.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../wm_mb_LoginPage.dart';

class Cash_Summary extends StatefulWidget {
  const Cash_Summary({Key key}) : super(key: key);

  @override
  _Cash_SummaryState createState() => _Cash_SummaryState();
}

class _Cash_SummaryState extends State<Cash_Summary> {
  TextEditingController userid = new TextEditingController();
  List<CashSummary> cash_sum = List();
  var date;
  var empid;
  var _selectedDate;
  bool loading = false;
  @override
  void initState() {
    userid.text = gs_currentUser_empid;
    cash_sum_pro(gs_currentUser_empid).then((value) {
      if (value == 1) {
        cash_summary().then((value) {
          setState(() {
            cash_sum.clear();
            cash_sum.addAll(value);
            loading = true;
            print(cash_sum.length);
          });
        });
      }
    });
    // loading = true;

    super.initState();
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
        title: Text('Cash Summary'),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          SizedBox(
            width: 3.0,
          ),
          // PopupMenuButton<String>(
          //   onSelected: choiceAction,
          //   itemBuilder: (BuildContext context) {
          //     return Constants.choices.map((String choice) {
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),
        ],
      ),
      body: (loading == false)
          ? spinkitLoading()
          : SingleChildScrollView(
              child: Container(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Flexible(
                            // flex: 2,
                            // child: Row(
                            //   children: <Widget>[
                            //     Text(_selectedDate == null
                            //         ? gs_date
                            //         : _selectedDate),
                            //     IconButton(
                            //         icon: Icon(
                            //           Icons.calendar_today,
                            //           size: 30.0,
                            //         ),
                            //         onPressed: () {
                            //           setState(() {
                            //             _presentDatePicker();
                            //           });
                            //         })
                            //   ],
                            // )),
                            Flexible(
                                flex: 1,
                                child: textFieldUser(
                                    "SALESMAN ID", userid, false, false)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (cash_sum.isNotEmpty)
                        Container(
                            height: 1000,
                            // width: 400,

                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                    color: Colors.blue[300],
                                    child: Column(
                                      children: [
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CREDIT AMT",
                                                cash_sum[0].val2 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val2)
                                                    : Text(""),
                                                16.0),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CREDIT RETURN AMT",
                                                cash_sum[0].val3 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val3)
                                                    : Text(""),
                                                16.0),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CASH  AMT",
                                                cash_sum[0].val4 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val4)
                                                    : Text(""),
                                                16.0),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CASH RETURN AMT",
                                                cash_sum[0].val5 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val5)
                                                    : Text(""),
                                                16.0),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CHEQUE AMT",
                                                cash_sum[0].val6 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val6)
                                                    : Text(""),
                                                16.0),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CASH COLLECTED AMT",
                                                cash_sum[0].val7 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val7)
                                                    : Text(""),
                                                16.0),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            subtitle: rowData_2(
                                                "CASH ON HAND",
                                                cash_sum[0].val8 != null
                                                    ? getNumberFormat(
                                                        cash_sum[0].val8)
                                                    : "0.00",
                                                16.0),
                                          ),
                                        ),
                                      ],
                                    ));
                              },
                              itemCount: cash_sum.length,
                            )),
                      // if (cash_sum.isEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.all(150.0),
                      //     child: Container(
                      //       child: Text(
                      //         "No Records",
                      //         style: TextStyle(
                      //           color: Colors.red,
                      //           fontSize: 16.0,
                      //         ),
                      //       ),
                      //     ),
                      //   )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  textFieldUser(_text, _controller, _validate, read) {
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
}
