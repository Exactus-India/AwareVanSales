import 'package:aware_van_sales/wigdets/userListBuilder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class CustomerList_Returns extends StatefulWidget {
  @override
  _CustomerList_ReturnsState createState() => _CustomerList_ReturnsState();
}

class _CustomerList_ReturnsState extends State<CustomerList_Returns> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text("Customer List", Colors.white),
          elevation: .1,
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        ),
        body: Container(
          child: ListBuilder(pageno: 3),
        ));
  }
}
