import 'package:aware_van_sales/data/stock_sum_data.dart';
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
  // List<StockSum> stockreport = List<StockSum>();

  List<DataRow> rows = [];

  @override
  void initState() {
    stock_summary_pro("12-FEB-2021", "12-FEB-2021")
        .then((value) => stock_summary().then((value) {
              setState(() {
                stockreport.addAll(value);
                print("size " + stockreport.length.toString());
                _getData01(stockreport);
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
                _getData01(stockreport),
                SingleChildScrollView(
                  padding: EdgeInsets.only(top: 20.0),
                  scrollDirection: Axis.horizontal,
                  child: DataTable(columns: [
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
                  ], rows: rows
                      //  stockreport.forEach((stat) {
                      // stat.item.forEach((row) {
                      //   rows.add( DataRow(cells: <DataCell>[
                      //                         DataCell(
                      //                           Container(
                      //                             child: Column(
                      //                                 crossAxisAlignment:
                      //                                     CrossAxisAlignment.start,
                      //                                 children: [
                      //                                   Text(row.prod_code.toString()),
                      //                                   // Text(stocksum['PROD_CODE'].toString()),
                      //                                   Row(
                      //                                     mainAxisAlignment:
                      //                                         MainAxisAlignment.spaceBetween,
                      //                                     children: [
                      //                                       Text(row.prod_name.toString()),
                      //                                       Text(row.l_uom.toString()),
                      //                                     ],
                      //                                   )
                      //                                 ]),
                      //                           ),
                      //                         ),
                      //                         DataCell(Text(row.op_stk.toString())),
                      //                         DataCell(Text(row.in_qty.toString())),
                      //                         DataCell(Text(row.out_qty.toString())),
                      //                         DataCell(Text(row.cl_stock.toString())),
                      //                       ]),
                      //                    );
                      //                   });}),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getData01(List listOfData) {
    listOfData.forEach((stat) {
      stat.item.forEach((row) {
        rows.add(DataRow(cells: [
          DataCell(
            Text(row.prod_name),
          ),
          DataCell(
            Text(row.prod_name),
          ),
          // DataCell(
          //   Text("${row.symbol}"),
          // ),
        ]));
      });
    });

    // return DataTable(
    //   columns: listOfData
    //       .map((column) => DataColumn(
    //             label: Container(),
    //           ))
    //       .toList(),
    //   rows: rows,
    // );
  }
}
