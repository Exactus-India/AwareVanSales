import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:flutter/material.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List _datas = List();
  @override
  void initState() {
    customersaleslist().then((value) {
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
        title: Text("Customer List", style: TextStyle(color: Colors.white)),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: ListBuilderCommon(datas: _datas, toPage: '/SalesList', head: false),
    );
  }
}
