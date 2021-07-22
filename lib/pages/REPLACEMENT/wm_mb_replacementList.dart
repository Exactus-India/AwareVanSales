import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/SALES/wm_mb_salesentry.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'wm_mb_replacement.dart';

class ReplaceDocno extends StatefulWidget {
  @override
  _ReplaceDocnoState createState() => _ReplaceDocnoState();
}

String gs_rep_ac_code;
String gs_party_address;

class _ReplaceDocnoState extends State<ReplaceDocno> {
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
    replacement_hdr_get(0, gs_rep_ac_code).then((value) {
      setState(() {
        print("replacemntlist" + gs_sales_param1);
        if (value != null) {
          _datas.clear();
          _datas.addAll(value);
        }
        loading = true;
        gs_rep_ac_code = gs_sales_param4;
        gs_party_address = gs_sales_param3;
        if (_datas.isNotEmpty) {
          _datasForDisplay = _datas;
        }
        length = 0;
        length = _datas.length;
        print(length);
        print("length....");
        print(gs_rep_ac_code + '....' + gs_party_address);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Sales List", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                print(gs_rep_ac_code);
                print('gs_rep_ac_code');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Replacement(
                            doc_no: null,
                            party_address: gs_party_address,
                            ac_code: gs_rep_ac_code,
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
        datasForDisplay[index]['REF_NO'] is num
            ? val3 = getNumberFormat(datasForDisplay[index]['REF_NO'])
            : val3 = datasForDisplay[index]['REF_NO'];
        return Card(
          color: Colors.green[200],
          child: ListTile(
            subtitle: Column(
              children: <Widget>[
                align(
                    Alignment.centerLeft,
                    datasForDisplay[index]['DOC_DATE'].toString().split('T')[0],
                    14.0),
                SizedBox(
                  height: 8,
                ),
                rowData_2(datasForDisplay[index]['DOC_NO'].toString(),
                    val3.toString(), 14.0),
                // if (datasForDisplay[index]['REF_NO'] != null)
                //   align(Alignment.centerLeft,
                //       datasForDisplay[index].val4.toString(), 14.0),
                if (datasForDisplay[index]['CONFIRMED'] == 'Y')
                  alignCon(Alignment.centerLeft, "Confirmed", 14.0),
              ],
            ),
            onTap: () {
              var doc_no = _datasForDisplay[index]['DOC_NO'].toString();
              var partyaddress = _datasForDisplay[index][''].toString();
              var ac_name = _datasForDisplay[index]['AC_CODE'].toString();
              // var salestype = _datasForDisplay[index][].toString();
              var doc_date = _datasForDisplay[index]['DOC_DATE'].toString();
              // var last_dn_serialno=_datasForDisplay[index].val12.toString();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Replacement(
                            doc_no: doc_no,
                            party_address: gs_party_address,
                            ac_code: gs_rep_ac_code,
                            ac_name: ac_name,
                          ))).then((value) {
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
