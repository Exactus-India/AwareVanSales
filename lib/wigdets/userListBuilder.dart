import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_sales.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'list.dart';

class ListBuilder extends StatefulWidget {
  final int pageno;
  final String ac_code;

  const ListBuilder({Key key, this.pageno, this.ac_code}) : super(key: key);
  @override
  _ListBuilderState createState() => _ListBuilderState();
}

List<Sales_Customer_Data> salesListValues = List<Sales_Customer_Data>();

class _ListBuilderState extends State<ListBuilder> {
  int flag = 0;
  int list_no;
  List<Sales_Customer_Data> _datas = List<Sales_Customer_Data>();
  List<Sales_Customer_Data> _datasForDisplay = List<Sales_Customer_Data>();
  bool toPage = false;
  @override
  void initState() {
    salesListValues.clear();
    list_no = widget.pageno;
    list_db(list_no);
    print(list_no);
    super.initState();
    super.context;
  }

  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue[50],
      child: Column(
        children: <Widget>[
          if (flag == 0)
            Container(
                margin: EdgeInsets.only(top: 10.0, left: 10.0),
                child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
          if (flag == 0) _searchBar(),
          list_no == 2 && flag == 0 ? sales_head() : SizedBox(height: 10.0),
          if (flag == 0)
            Expanded(
              child: listNew(_datasForDisplay, list_no, toPage),
            ),
          if (flag == 1)
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    heightFactor: 12,
                    child: textData("No Records", Colors.red, 30.0),
                  ),
                ]),
        ],
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        onChanged: (text) {
          text = text.toUpperCase();
          setState(() {
            _datasForDisplay = _datas.where((data) {
              var ac_name = data.ac_name.toString().toUpperCase();
              var doc_no = data.doc_no.toString().toUpperCase();
              if (ac_name.contains(text))
                return ac_name.contains(text);
              else
                return doc_no.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  sales_head() {
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: align(Alignment.centerLeft, sales_customer_name, 18.0));
  }

  list_db(pageno) {
    if (pageno == 1 || pageno == 3)
      customersaleslist().then((value) {
        setState(() {
          _datas.addAll(value);
          _datasForDisplay = _datas;
          if (_datas.isEmpty) flag = 1;
          if (pageno == 1) toPage = true;
        });
      });
    if (pageno == 2)
      sales_list(widget.ac_code, gs_currentUser_empid).then((value) {
        setState(() {
          _datas.addAll(value);
          _datasForDisplay = _datas;
          if (_datas.isEmpty) flag = 1;
          salesListValues = _datas;
          toPage = true;
          print(sales_customer_name);
          print('....Length' + salesListValues.length.toString());
        });
      });
  }
}
