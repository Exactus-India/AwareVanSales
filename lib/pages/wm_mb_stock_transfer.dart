import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:flutter/material.dart';

class Stocktransfer extends StatefulWidget {
  @override
  _StocktransferState createState() => _StocktransferState();
}

class _StocktransferState extends State<Stocktransfer> {
  List _datas = List();
  @override
  void initState() {
    stocktransfer().then((value) {
      setState(() {
        _datas.clear();
        _datas.addAll(value);
        list_length = 0;
        list_length = _datas.length;
        print(list_length.toString() + '....');
      });
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Stock Transfer", style: TextStyle(color: Colors.white)),
          elevation: .1,
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  gs_sales_param1 = null;
                  Navigator.pushNamed(context, '/StockTransferEntry');
                },
                child: Icon(Icons.add)),
            SizedBox(width: 20.0),
          ]),
      body: ListBuilderCommon(
        datas: _datas,
        toPage: '/StockTransferEntry',
        head: false,
      ),
    );
  }
}
