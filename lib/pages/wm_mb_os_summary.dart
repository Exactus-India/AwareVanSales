import 'package:aware_van_sales/wigdets/widget_litView_row.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';

class OsSummary extends StatefulWidget {
  @override
  _OsSummaryState createState() => _OsSummaryState();
}

class _OsSummaryState extends State<OsSummary> {
  List os_summary_report = List();
  TextEditingController userdate = TextEditingController();
  double total = 0, d1 = 0, d2 = 0, d3 = 0, d4 = 0;
  @override
  void initState() {
    os_summary_pro().then((value) {
      os_summary().then((value) {
        os_summary_report.clear();
        os_summary_report.addAll(value);
        setState(() {
          for (int i = 0; i < os_summary_report.length; i++) {
            total += os_summary_report[i].val3;
            d1 += os_summary_report[i].val4;
            d2 += os_summary_report[i].val5;
            d3 += os_summary_report[i].val6;
            d4 += os_summary_report[i].val7;
          }
          print(
              "os_summary list length " + os_summary_report.length.toString());
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OS Summary'),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(Icons.print),
            ),
          )
        ],
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gs_currentUser,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              textField("Date", userdate, false, true),
              SizedBox(height: 10),
              Container(
                color: Colors.grey[800],
                child: Card(
                  child: ListTile(
                    title: rowData5("Below 15", "16-30", "31-60", "Above 60  ",
                        "Total", 15.0, Colors.deepPurpleAccent),
                    subtitle: rowData5(
                        getNumberFormat(d1),
                        getNumberFormat(d2),
                        getNumberFormat(d3),
                        getNumberFormat(d4),
                        getNumberFormat(total),
                        12.0,
                        Colors.black),
                  ),
                ),
              ),
              Expanded(child: listView_row_6_fields(os_summary_report)),
            ],
          ),
        ),
      ),
    );
  }
}
