import 'package:aware_van_sales/wigdets/dataTable_widget.dart';
import 'package:flutter/material.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';
import 'package:intl/intl.dart';

class StockSummary extends StatefulWidget {
  @override
  _StockSummaryState createState() => _StockSummaryState();
}

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);

class _StockSummaryState extends State<StockSummary> {
  List stockreport = List();
  List column = [
    "PRODUCT CODE",
    "OPENING STOCK",
    "QTY IN",
    "QTY OUT",
    "CLOSING STOCK"
  ];

  @override
  void initState() {
    stock_summary_pro(gs_date, gs_date)
        .then((value) => stock_summary().then((value) {
              setState(() {
                stockreport.addAll(value);
                print("size " + stockreport.length.toString());
              });
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Summary'),
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 13.0, right: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Stock Report (All)",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                text("User: " + gs_currentUser, Colors.black),
                text("Date: " + formatter, Colors.black),
                if (stockreport.isNotEmpty)
                  WidgetdataTable(column: column, row: stockreport),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
