import 'package:aware_van_sales/pages/wm_mb_customer.dart';
import 'package:aware_van_sales/wigdets/card.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: text("Menu", Colors.white),
        centerTitle: true,
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          //padding: EdgeInsets.all(13.0),
          children: <Widget>[
            //--------------------------SALE-------------------------
            card("SALE", CustomerList(pageno: 1), Icons.attach_money,
                Colors.blue[800], this.context),

            //--------------------------RETURNS-------------------------
            card("RETURNS", CustomerList(pageno: 3), Icons.restore,
                Colors.blue[800], this.context),

            //--------------------------RECEIPT-------------------------
            card(
                "RECEIPT", null, Icons.receipt, Colors.blue[800], this.context),

            //--------------------------SALE SUMMARY-------------------------
            card("SALE SUMMARY", null, Icons.pages, Colors.blue[800],
                this.context),

            //--------------------------STOCK TRANSFER-------------------------
            card("STOCK TRANSFER", null, Icons.transform, Colors.blue[800],
                this.context),

            //--------------------------O/S AGEING-------------------------
            card("O/S AGEING", null, Icons.group, Colors.blue[800],
                this.context),

            //--------------------------STOCK SUMMARY-------------------------
            card("STOCK SUMMARY", null, Icons.pages, Colors.blue[800],
                this.context),

            //--------------------------DAILY ACTIVITY-------------------------
            card("DAILY ACTIVITY", null, Icons.details, Colors.blue[800],
                this.context)
          ],
        ),
      ),
    );
  }
}
