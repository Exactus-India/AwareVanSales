import 'package:flutter/material.dart';

import '../data/future_db.dart';
import '../wigdets/listing_Builder.dart';

class ReceiptList extends StatefulWidget {
  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  List _datas = List();
  @override
  void initState() {
    receipt().then((value) {
      setState(() {
        _datas.clear();
        _datas.addAll(value);
        list_length = 0;
        list_length = _datas.length;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt List", style: TextStyle(color: Colors.white)),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: ListBuilderCommon(datas: _datas, toPage: null, head: true),
    );
  }
}
