import 'package:aware_van_sales/wigdets/dataTable_widget.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:flutter/material.dart';

import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';
import '../data/future_db.dart';

class SalesSummary extends StatefulWidget {
  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

class _SalesSummaryState extends State<SalesSummary> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController date = TextEditingController();
  int totalCash = 0;
  List salesumm_1 = List();
  List salesumm_2 = List();
  List salessummary_col2 = ["Sl No.", "Description", "Items", "Amount"];
  List salessummary_col1 = ["", "", ""];
  String finalDate = '';
  getDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    setState(() {
      finalDate = formattedDate.toString();
      print(finalDate);
    });
  }

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
                      flex: 2, child: textField("DD-MM-YY", date, false, true)),
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
                  child: listView(salesumm_1)),
            if (salesumm_2.isNotEmpty)
              WidgetdataTable(
                column: salessummary_col2,
                row: salesumm_2,
              ),
          ],
        ),
      )),
    );
  }

  listView(datasForDisplay) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          height: 40,
          child: Card(
            child: ListTile(
              subtitle: rowData3(
                  datasForDisplay[index].val1.toString(),
                  datasForDisplay[index].val2.toString(),
                  datasForDisplay[index].val3.toString(),
                  14.0),
            ),
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }
}
