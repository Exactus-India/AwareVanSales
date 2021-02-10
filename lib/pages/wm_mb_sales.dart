import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/userListBuilder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesList extends StatefulWidget {
  final String ac_code;

  const SalesList({Key key, this.ac_code}) : super(key: key);
  @override
  _SalesListState createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: text("Sales List", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: Container(
          child: ListBuilder(
        pagename: false,
        ac_code: widget.ac_code,
      )),
    );
  }
}
