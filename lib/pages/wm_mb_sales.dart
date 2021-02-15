import 'package:aware_van_sales/wigdets/salesentry.dart';
import 'package:aware_van_sales/wigdets/userListBuilder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesList extends StatefulWidget {
  final String ac_code;
  final String customer;

  const SalesList({Key key, this.ac_code, this.customer}) : super(key: key);
  @override
  _SalesListState createState() => _SalesListState();
}

String sales_customer_name;

class _SalesListState extends State<SalesList> {
  @override
  void initState() {
    setState(() {
      sales_customer_name = widget.customer;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Sales List", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SalesEntry(index: null)));
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
        ],
      ),
      body: ListBuilder(
        pageno: 2,
        ac_code: widget.ac_code,
      ),
    );
  }
}
