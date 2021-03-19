import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_stock_transfer_entry.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'wm_mb_LoginPage.dart';
import 'wm_mb_sales.dart';

class Stocktransfer extends StatefulWidget {
  @override
  _StocktransferState createState() => _StocktransferState();
}

class _StocktransferState extends State<Stocktransfer> {
  List _datas = List();
  List _datasForDisplay = List();
  int length;
  bool _timer_ = false;
  @override
  void initState() {
    list();
    super.initState();
    new Timer(const Duration(milliseconds: 200), () {
      setState(() {
        _timer_ = true;
      });
    });

    super.initState();
  }

  list() {
    stocktransfer().then((value) {
      print("STock Transfer Report");
      setState(() {
        _datas.clear();
        _datas.addAll(value);
        _datasForDisplay = _datas;
        length = 0;
        length = _datas.length;
        print(length);
      });
    });
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            StocktransferEntry(doc_no: null))).then((value) {
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
        return Card(
          color: Colors.green[200],
          child: ListTile(
            subtitle: Column(
              children: <Widget>[
                align(Alignment.centerLeft,
                    datasForDisplay[index].val1.toString(), 14.0),
                if (datasForDisplay[index].val4 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val4.toString(), 14.0),
                rowData_2(datasForDisplay[index].val5.toString(),
                    datasForDisplay[index].val6.toString(), 14.0),
              ],
            ),
            onTap: () {
              var doc_no = _datasForDisplay[index].param1.toString();
              var from_zone = _datasForDisplay[index].param2.toString();
              var to_zone = _datasForDisplay[index].param3.toString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StocktransferEntry(doc_no: doc_no))).then((value) {
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
