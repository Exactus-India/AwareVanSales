import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesReturnList extends StatefulWidget {
  @override
  _SalesReturnListState createState() => _SalesReturnListState();
}

String gs_ac_code;
String gs_party_address;

class _SalesReturnListState extends State<SalesReturnList> {
  List _datas = List();
  @override
  void initState() {
    salesReturnlist(gs_sales_param1).then((value) {
      setState(() {
        _datas.addAll(value);
        gs_ac_code = gs_sales_param4;
        gs_party_address = gs_sales_param3;
        if (_datas.isNotEmpty) {
          gs_ac_code = _datas[0].val9.toString();
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
        title: text("SalesReturn List", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                gs_sales_param1 = null;
                Navigator.pushNamed(context, '/SalesReturnEntry');
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
        ],
      ),
      body: ListBuilderCommon(
          toPage: '/SalesReturnEntry', datas: _datas, head: true),
    );
  }
}
