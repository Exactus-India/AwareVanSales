import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_saleReturn_entry.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
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
  List _datasForDisplay = List();
  int length;
  bool _timer_ = false;
  @override
  void initState() {
    list();
    super.initState();
    new Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _timer_ = true;
      });
    });

    super.initState();
  }

  list() {
    salesReturnlist(gs_sales_param1).then((value) {
      setState(() {
        _datas.clear();
        _datas.addAll(value);
        gs_ac_code = gs_sales_param4;
        gs_party_address = gs_sales_param3;
        if (_datas.isNotEmpty) {
          gs_ac_code = _datas[0].val9.toString();
          _datasForDisplay = _datas;
        }
        length = 0;
        length = _datas.length;
        print(list_length.toString() + '....');
        print(gs_ac_code + '....' + gs_party_address);
      });
    });
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SalesEntryComman(
                            doc_no: null,
                            party_address: gs_party_address,
                            ac_code: gs_ac_code,
                            ac_name: gs_sales_param2))).then((value) {
                  setState(() {
                    list();
                    _searchBar();
                  });
                });
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
        ],
      ),
      body: head(),
    );
  }

  head() {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
        _searchBar(),
        Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: align(Alignment.centerLeft, gs_sales_param2, 18.0)),
        SizedBox(height: 5.0),
        if (_timer_ == true && length == 0) noValue(),
        if (_timer_ == true)
          Expanded(
            child: listView(_datasForDisplay),
          ),
      ],
    );
  }

  listView(List datasForDisplay) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var val3;
        datasForDisplay[index].val3 is num
            ? val3 = getNumberFormat(datasForDisplay[index].val3)
            : val3 = datasForDisplay[index].val3;
        return Card(
          color: Colors.green[200],
          child: ListTile(
            subtitle: Column(
              children: <Widget>[
                align(Alignment.centerLeft,
                    datasForDisplay[index].val1.toString(), 14.0),
                rowData_2(datasForDisplay[index].val2.toString(),
                    val3.toString(), 14.0),
                if (datasForDisplay[index].val4 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val4.toString(), 14.0),
              ],
            ),
            onTap: () {
              var doc_no = datasForDisplay[index].param1.toString();
              var partyaddress = _datasForDisplay[index].param2.toString();
              var ac_name = _datasForDisplay[index].val8.toString();
              var ac_code = _datasForDisplay[index].val9.toString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesEntryComman(
                          doc_no: doc_no,
                          party_address: partyaddress,
                          ac_code: ac_code,
                          ac_name: ac_name))).then((value) {
                setState(() {
                  _searchBar();
                  list();
                });
              });
            },
          ),
        );
      },
      itemCount: datasForDisplay.length,
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
              var search = data.search.toString().toUpperCase();
              return search.contains(text);
            }).toList();
          });
        },
      ),
    );
  }
}
