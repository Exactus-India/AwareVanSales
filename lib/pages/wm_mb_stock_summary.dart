import 'package:flutter/material.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';
import 'package:intl/intl.dart';

class StockSummary extends StatefulWidget {
  @override
  _StockSummaryState createState() => _StockSummaryState();
}

List stocksummary = [
  {
    "PROD_CODE": 45,
    "PROD_NAME": "hgfg",
    "P_UOM": "pcs",
    "QTY_PUOM": 54,
    "L_UOM": 34
  },
  {
    "PROD_CODE": 45,
    "PROD_NAME": "hgfg",
    "P_UOM": "pcs",
    "QTY_PUOM": 54,
    "L_UOM": 34
  },
  {
    "PROD_CODE": 45,
    "PROD_NAME": "hgfg",
    "P_UOM": "pcs",
    "QTY_PUOM": 54,
    "L_UOM": 34
  }
];

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);

class _StockSummaryState extends State<StockSummary> {
  List stockreport = List();
  @override
  void initState() {
    setState(() {
      stock_summary().then((value) {
        stockreport.addAll(value);
      });
    });

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
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20.0),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: [
                        DataColumn(
                          label: text("PRODUCT\nCODE", Colors.black),
                        ),
                        DataColumn(label: text("OPEN\nSTOCK", Colors.black)),
                        DataColumn(
                          label: text("QTY\nIN", Colors.black),
                        ),
                        DataColumn(
                          label: text("QTY\nOUT", Colors.black),
                        ),
                        DataColumn(
                            label: text("CLOSING\nSTOCK", Colors.black),
                            numeric: true),
                      ],
                      rows: stockreport
                          .map(
                            (stocksum) => DataRow(cells: <DataCell>[
                              DataCell(
                                Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(stocksum['PROD_NAME'].toString()),
                                        // Text(stocksum['PROD_CODE'].toString()),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(stocksum['PROD_CODE']
                                                .toString()),
                                            Text(stocksum['L_UOM'].toString()),
                                          ],
                                        )
                                      ]),
                                ),
                              ),
                              DataCell(Text(stocksum['OP_STK'].toString())),
                              DataCell(Text(stocksum['IN_QTY'].toString())),
                              DataCell(Text(stocksum['OUT_QTY'].toString())),
                              DataCell(Text(stocksum['CL_STOCK'].toString())),
                            ]),
                          )
                          .toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
