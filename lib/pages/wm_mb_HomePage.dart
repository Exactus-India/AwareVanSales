import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_customer.dart';
import 'package:aware_van_sales/pages/wm_mb_saleReturnCust.dart';
import 'package:aware_van_sales/pages/wm_mb_os_summary.dart';
import 'package:aware_van_sales/wigdets/card.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'wm_mb_receipt.dart';
import 'wm_mb_sales_summary.dart';
import 'wm_mb_stock_summary.dart';
import 'wm_mb_stock_transfer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    get_user_zonecode().then((value) {
      gs_zonecode = value[0]['DEFAULT_ZONE_CODE'];
      print("Zonecode " + gs_zonecode);
    });
    super.initState();
  }

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
            card("SALE", CustomerList(), Colors.blue[800], this.context,
                'sale.png'),

            //--------------------------RETURNS-------------------------
            card("RETURNS", SaleRetunCustomerList(), Colors.blue[800],
                this.context, 'sale_returns.jpg'),

            //--------------------------RECEIPT-------------------------
            card("RECEIPT", ReceiptList(), Colors.blue[800], this.context,
                'receipt.png'),

            //--------------------------SALE SUMMARY-------------------------
            card("SALE SUMMARY", SalesSummary(), Colors.blue[800], this.context,
                'sales_summary.png'),

            //--------------------------STOCK TRANSFER-------------------------
            card("STOCK TRANSFER", Stocktransfer(), Colors.blue[800],
                this.context, 'stock_transfer.png'),

            //--------------------------O/S AGEING-------------------------
            card("O/S AGEING", OsSummary(), Colors.blue[800], this.context,
                'os_ageing.png'),

            //--------------------------STOCK SUMMARY-------------------------
            card("STOCK SUMMARY", StockSummary(), Colors.blue[800],
                this.context, 'stock_summary.png'),

            //--------------------------DAILY ACTIVITY-------------------------
            // card("DAILY ACTIVITY", null, Colors.blue[800], this.context,
            //     'daily_activity.png')
          ],
        ),
      ),
    );
  }
}
