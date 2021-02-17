import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesList extends StatefulWidget {
  final String ac_code;
  final String customer;

  const SalesList({Key key, this.ac_code, this.customer}) : super(key: key);
  @override
  _SalesListState createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  List _datas = List();
  @override
  void initState() {
    saleslist(gs_sales_param1).then((value) {
      setState(() {
        _datas.addAll(value);
        list_length = 0;
        list_length = _datas.length;
        print(list_length.toString() + '....');
      });
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
                gs_sales_param1 = null;
                Navigator.pushNamed(context, '/SalesEntry');
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
        ],
      ),
      body: ListBuilderCommon(toPage: '/SalesEntry', datas: _datas, head: true),
    );
  }
}
