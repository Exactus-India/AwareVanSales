import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/SALES/wm_mb_sales.dart';
import 'package:aware_van_sales/pages/SALESRETURN/wm_mb_saleReturnList.dart';
import 'package:flutter/material.dart';

import 'pages/REPLACEMENT/wm_mb_replacementList.dart';
import 'pages/TRACKING/wm_mb_mapview.dart';
import 'pages/STOCK_TRANSFER/wm_mb_stock_transfer_entry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aware Van Sales',
      initialRoute: '/',
      routes: {
        '/SalesList': (context) => SalesList(),
        '/SalesReturnList': (context) => SalesReturnList(),
        '//Maplist': (context) => MapView(),
        '/StockTransferEntry': (context) => StocktransferEntry(),
        '/replace_doc': (context) => ReplaceDocno(),
      },
      home: Wm_mb_LoginPage(),
    );
  }
}
