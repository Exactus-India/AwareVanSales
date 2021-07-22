import 'dart:async';

import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:flutter/material.dart';

import 'wm_mb_receipt_edit.dart';
import 'wm_mb_receipt_entry.dart';
import '../../wigdets/widget_rowData.dart';
import '../../wigdets/widgets.dart';
import '../../data/future_db.dart';
import '../wm_mb_LoginPage.dart';

class ReceiptList extends StatefulWidget {
  @override
  _ReceiptListState createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  List _datas = List();
  List _datasForDisplay = List();
  int length;
  bool _timer_ = false;
  bool loading = false;
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
    receipt().then((value) {
      setState(() {
        print("Recipt");
        _datas.clear();
        _datas.addAll(value);
        loading = true;
        if (_datas.isNotEmpty) {
          _datasForDisplay = _datas;
        }
        length = 0;
        length = _datas.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Receipt List", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: [
          GestureDetector(
            child: FlatButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReceiptEntry_Edit())),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: (loading == false) ? spinkitLoading() : head(),
    );
  }

  head() {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
        _searchBar(),
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
            ? val3 = getNumberFormatRound(datasForDisplay[index].val3.round())
            : val3 = datasForDisplay[index].val3;
        return Card(
          color: Colors.green[200],
          child: ListTile(
            subtitle: Column(
              children: <Widget>[
                align(Alignment.centerLeft,
                    datasForDisplay[index].val1.toString(), 14.0),
                rowData_2(datasForDisplay[index].val2.toString(), val3, 14.0),
              ],
            ),
            onTap: () {
              var out_bal = _datasForDisplay[index].val3.toString();
              var ac_name = _datasForDisplay[index].val2.toString();
              var ac_code = _datasForDisplay[index].val1.toString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReceiptEntry(
                          ac_code: ac_code,
                          ac_name: ac_name,
                          outbal: out_bal))).then((value) {
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

  rowDataRound_2(first, last, size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (first != null || first != 'null')
          columnRow(first.toString(), CrossAxisAlignment.start,
              MainAxisAlignment.start, size, TextAlign.left),
        if (last != null || last != 'null')
          columnRow(last.round(), CrossAxisAlignment.start,
              MainAxisAlignment.end, size, TextAlign.right),
      ],
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
              var search = data.val2.toString().toUpperCase();
              return search.contains(text);
            }).toList();
          });
        },
      ),
    );
  }
}
