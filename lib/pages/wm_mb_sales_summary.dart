import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widget_litView_row.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';
import '../data/future_db.dart';

class SalesSummary extends StatefulWidget {
  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);

class _SalesSummaryState extends State<SalesSummary> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  int totalCash = 0;
  List salesumm_1 = List();
  List salesumm_2 = List();

  String finalDate = '';

  @override
  void initState() {
    sales_sum_pro().then((value) {
      sales_sum1().then((value) {
        setState(() {
          salesumm_1.addAll(value);
          list_length = salesumm_1.length;
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
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 2, child: textField(formatter, date, false, true)),
                  Flexible(
                      child:
                          textField(gs_currentUser_empid, date, false, true)),
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
            rowData4("Sl.No", "Description   ", " Items", "Amount      ", 15.0),
            SizedBox(height: 10),
            Container(
                height: 110,
                width: 500,
                color: Colors.lightBlue[100],
                child: listView_row_4_fields(salesumm_2, 110.0)),
          ],
        ),
      )),
    );
  }
}
