import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'list.dart';

class ListBuilder extends StatefulWidget {
  final bool pagename;
  final String ac_code;

  const ListBuilder({Key key, this.pagename, this.ac_code}) : super(key: key);
  @override
  _ListBuilderState createState() => _ListBuilderState();
}

String gs_sales_customer_name;
String gs_sales_doc_date;

class _ListBuilderState extends State<ListBuilder> {
  List<Sales_Customer_Data> _datas = List<Sales_Customer_Data>();
  List<Sales_Customer_Data> _datasForDisplay = List<Sales_Customer_Data>();

  bool page = false;
  int flag = 0;

  @override
  void initState() {
    if (widget.pagename == true) page = true;
    page == true
        ? customerlist().then((value) {
            setState(() {
              _datas.addAll(value);
              _datasForDisplay = _datas;
            });
          })
        // : sales_list(widget.doc_type, widget.ac_code, widget.salesman_code)
        : sales_list('DN90', widget.ac_code, gs_currentUser_empid)
            .then((value) {
            setState(() {
              _datas.addAll(value);
              _datasForDisplay = _datas;
              if (_datas.isEmpty) gs_sales_customer_name = '';
              if (_datas.isEmpty) gs_sales_doc_date = '';
              if (_datas.isEmpty) flag = 1;
            });
          });

    super.initState();
    super.context;
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (flag == 0)
          Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0),
              child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
        SizedBox(height: 10),
        if (flag == 0) _searchBar(),
        page == false && gs_sales_customer_name == ''
            ? head()
            : SizedBox(height: 10.0),
        flag == 0
            ? Expanded(
                child: list(_datasForDisplay, page),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                    Center(
                      heightFactor: 12,
                      child: textData("No Datas", Colors.red, 30.0),
                    ),
                  ]),
      ],
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Country...'),
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _datasForDisplay = _datas.where((data) {
              var ac_code = data.ac_code.toString().toLowerCase();
              var doc_no = data.doc_no.toString().toLowerCase();
              if (ac_code.contains(text))
                return ac_code.contains(text);
              else
                return doc_no.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  head() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: textData(gs_sales_customer_name, Colors.black, 18.0)),
          Align(
              alignment: Alignment.centerLeft,
              child: textData(gs_sales_doc_date, Colors.black, 16.0)),
        ],
      ),
    );
  }
}
