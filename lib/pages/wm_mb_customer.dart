import 'package:aware_van_sales/wigdets/userListBuilder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text("Customer List", Colors.white),
          elevation: .1,
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        ),
        body: Container(
          child: ListBuilder(pagename: true),
        ));
  }
}
