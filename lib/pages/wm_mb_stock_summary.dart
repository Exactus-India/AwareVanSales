import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';

class StockSummary extends StatefulWidget {
  @override
  _StockSummaryState createState() => _StockSummaryState();
}

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);

class _StockSummaryState extends State<StockSummary> {
  List stockreport = List();
  List column = [
    "PRODUCT",
    "OPENING STOCK",
    "QTY IN",
    "QTY OUT",
    "CLOSING STOCK"
  ];

  @override
  void initState() {
    stock_summary_pro(gs_date, gs_date_to)
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
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                  child: Text(
                    "Stock Report (${gs_zonecode})",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                    child: text("User: " + gs_currentUser, Colors.black)),
                Padding(
                    padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                    child: text("Date: " + formatter, Colors.black)),
                if (stockreport.isNotEmpty)
                  // WidgetdataTable(
                  //     column: column,
                  //     row: stockreport,
                  //     col_space: 15.0,
                  //     data_r_height: 50.0,
                  //     head_r_height: 35.0),
                  listView_row_5(column),
                if (stockreport.isNotEmpty)
                  Container(
                    height: 560,
                    width: 500,
                    color: Colors.lightBlue[100],
                    child: listView_row_5fields(
                      stockreport,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  listView_row_5fields(List datasForDisplay) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            child: ListTile(
              subtitle: rowData5(
                  datasForDisplay[index].val1.toString() +
                      "\n" +
                      datasForDisplay[index].val2.toString() +
                      " \n" +
                      datasForDisplay[index].val3.toString(),
                  datasForDisplay[index].val4.toString(),
                  datasForDisplay[index].val5.toString(),
                  datasForDisplay[index].val6.toString(),
                  datasForDisplay[index].val7.toString(),
                  12.5,
                  Colors.black),
            ),
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }

  listView_row_5(List datasForDisplay) {
    return Container(
      child: Card(
        color: Colors.green[300],
        child: ListTile(
          // title: Text(datasForDisplay[index].val1.toString()),

          subtitle: rowData5(
              datasForDisplay[0],
              datasForDisplay[1],
              datasForDisplay[2],
              datasForDisplay[3],
              datasForDisplay[4],
              12.5,
              Colors.black),
        ),
      ),
    );
  }
}

rowData5(first, second, third, fourth, last, size, color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: columnRow1(first.toString(), MainAxisAlignment.center, size,
              TextAlign.left, color)),
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: columnRow1(second.toString(), MainAxisAlignment.end, size,
              TextAlign.right, color)),
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: columnRow1(third.toString(), MainAxisAlignment.end, size,
              TextAlign.end, color)),
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: columnRow1(fourth.toString(), MainAxisAlignment.end, size,
              TextAlign.end, color)),
      if (last != null)
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: columnRow1(last.toString(), MainAxisAlignment.end, size,
                TextAlign.right, color)),
    ],
  );
}
