import 'package:aware_van_sales/pages/_wm_mb_salesentry.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_sales.dart';
import 'package:flutter/material.dart';

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
        '/SalesEntry': (context) => SalesEntry(),
      },
      home: Wm_mb_LoginPage(),
    );
  }
}
