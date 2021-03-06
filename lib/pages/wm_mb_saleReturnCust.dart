import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:flutter/material.dart';

class SaleRetunCustomerList extends StatefulWidget {
  @override
  _SaleRetunCustomerListState createState() => _SaleRetunCustomerListState();
}

class _SaleRetunCustomerListState extends State<SaleRetunCustomerList> {
  List _datas = List();
  bool loading = false;
  @override
  void initState() {
    customersalesReturnlist().then((value) {
      setState(() {
        _datas.addAll(value);
        loading = true;
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
      body: (loading == false)
          ? spinkitLoading()
          : ListBuilderCommon(
              datas: _datas, toPage: '/SalesReturnList', head: false),
    );
  }
}
