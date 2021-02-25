import 'package:flutter/material.dart';

import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';

class SalesSummary extends StatefulWidget {
  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

List salessummary = [
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

class _SalesSummaryState extends State<SalesSummary> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  TextEditingController totalcash = TextEditingController();
  int totalCash = 0;
  @override
  void initState() {
    setState(() {
      totalcash.text = totalCash.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Summary'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {},
              child: Text('Prev.Day'),
            ),
          )
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            textData(gs_currentUser, Colors.black, 18.0),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 2, child: textField("abcd", date, false, true)),
                  Flexible(child: textField("fg", date, false, true)),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(
                        children: [textData("Cash Sales", Colors.black, 20.0)]),
                    Column(children: [
                      textData("Credit Sales", Colors.black, 20.0)
                    ]),
                    Column(children: [
                      textData("Total Sales", Colors.black, 20.0)
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [textData("1", Colors.grey, 20.0)]),
                    Column(children: [textData("0", Colors.grey, 20.0)]),
                    Column(children: [textData("1", Colors.grey, 20.0)]),
                  ]),
                  TableRow(children: [
                    Column(children: [textData("525", Colors.grey, 20.0)]),
                    Column(children: [textData("0", Colors.grey, 20.0)]),
                    Column(children: [textData("525", Colors.grey, 20.0)]),
                  ]),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 2, child: labelWidget(Colors.blue[500], totalcash)),
                Flexible(child: labelWidget(Colors.blue[500], totalcash)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('Sno')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Items')),
                DataColumn(label: Text('Amount')),
              ],
              rows: salessummary.map((salessum) {
                setState(() {
                  totalcash.clear();
                  totalCash = salessum['QTY_PUOM'] + totalCash;
                  totalcash.text = totalcash.toString();
                });
                return DataRow(cells: <DataCell>[
                  // totalCash+=salessum['QTY_PUOM'];
                  DataCell(Text(salessum['PROD_CODE'].toString())),
                  DataCell(Text(salessum['PROD_NAME'].toString())),
                  DataCell(Text(salessum['P_UOM'].toString())),
                  DataCell(Text(salessum['QTY_PUOM'].toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
