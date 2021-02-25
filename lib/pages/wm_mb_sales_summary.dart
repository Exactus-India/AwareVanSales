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
    "PROD_CODE": 46,
    "PROD_NAME": "hgfg",
    "P_UOM": "pcs",
    "QTY_PUOM": 58,
    "L_UOM": 34
  },
  {
    "PROD_CODE": 47,
    "PROD_NAME": "hgfg",
    "P_UOM": "pcs",
    "QTY_PUOM": 58,
    "L_UOM": 34
  }
];

class _SalesSummaryState extends State<SalesSummary> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  TextEditingController empid = TextEditingController();
  TextEditingController totalamount = TextEditingController();
  TextEditingController labelcash = TextEditingController();
  int totalCash = 0;
  @override
  void initState() {
    setState(() {
      totalamount.clear();
      labelcash.text = 'TOTAL CASH';
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
            align(Alignment.centerLeft, gs_currentUser, 18.0),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 2, child: textField("Date", date, false, true)),
                  Flexible(child: textField("Emp id", empid, false, true)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: labelWidget(Colors.blue[500], labelcash)),
                Flexible(
                    flex: 2, child: labelWidget(Colors.blue[500], totalamount)),
              ],
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
                  totalamount.clear();
                  totalCash = salessum['QTY_PUOM'] + totalCash;
                  totalamount.text = totalCash.toString();
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