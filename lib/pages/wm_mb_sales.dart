import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesList extends StatefulWidget {
  @override
  _SalesListState createState() => _SalesListState();
}

String gs_ac_code;
String gs_party_address;

class _SalesListState extends State<SalesList> {
  List _datas = List();
  @override
  void initState() {
    saleslist(gs_sales_param1).then((value) {
      setState(() {
        _datas.addAll(value);
        if (_datas.isNotEmpty) {
          gs_ac_code = _datas[0].val9.toString();
          gs_party_address = gs_sales_param3;
        }
        list_length = 0;
        list_length = _datas.length;
        print(list_length.toString() + '....');
        print(gs_ac_code + '....' + gs_party_address);
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
