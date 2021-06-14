import 'dart:async';

import '../data/future_db.dart';
import '../data/salesproducts.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_salesentry.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';
import '../pages/wm_mb_saleReturn_entry.dart';

import '../pages/wm_mb_saleReturn_entry.dart';
import '../pages/wm_mb_saleReturn_entry.dart';
import '../pages/wm_mb_saleReturn_entry.dart';
import 'widget_rowData.dart';

class SalesReturnListingBuilder extends StatefulWidget {
  final List datas;
  final toPage;
  final bool head;
  final bool popBack;

  const SalesReturnListingBuilder(
      {Key key, this.datas, this.toPage, this.head, this.popBack})
      : super(key: key);
  @override
  _SalesReturnListingBuilderState createState() =>
      _SalesReturnListingBuilderState();
}

int list_length1;

String gs_sales_param1;
String gs_sales_param2;
String gs_sales_param3;
String gs_sales_param4;
int gs_list_index1;

class _SalesReturnListingBuilderState extends State<SalesReturnListingBuilder> {
  List _datas = List();
  List _datasForDisplay = List();
  bool _timer_ = false;
  bool pop = false;

  @override
  void initState() {
    setState(() {
      if (widget.popBack == true) pop = true;
      _datas = widget.datas;
      _datasForDisplay = _datas;
    });
    print(list_length1.toString() + '/////');
    super.initState();
    new Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _timer_ = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
        _searchBar(),
        widget.head == true && gs_sales_param1 != null
            ? sales_head()
            : SizedBox(height: 5.0),
        if (_timer_ == true)
          if (list_length1 == 0) noValue(),
        if (_timer_ == true)
          Expanded(
            child: listView(_datasForDisplay, widget.toPage),
          ),
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
            // _datasForDisplay.clear();
            _datasForDisplay = _datas.where((data) {
              var search = data.search.toString().toUpperCase();
              return search.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  sales_head() {
    return Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: align(Alignment.centerLeft, gs_sales_param2, 18.0));
  }

  listView(List datasForDisplay, toPage) {
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
                if (datasForDisplay[index].val1 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val1.toString(), 14.0),
                if (datasForDisplay[index].val2 != null &&
                    datasForDisplay[index].val3 != null)
                  rowData_2(datasForDisplay[index].val2.toString(),
                      val3.toString(), 14.0),
                if (datasForDisplay[index].val4 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val4.toString(), 14.0),
                if (datasForDisplay[index].val5 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val5.toString(), 14.0),
                if (datasForDisplay[index].val6 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val6.toString(), 14.0),
              ],
            ),
            onTap: () {
              if (widget.toPage != null && pop == false) {
                gs_sales_param1 = _datasForDisplay[index].param1.toString();
                gs_sales_param2 = _datasForDisplay[index].param2.toString();
                if (_datasForDisplay[index].param3 != null)
                  gs_sales_param3 = _datasForDisplay[index].param3.toString();
                if (_datasForDisplay[index].param4 != null)
                  gs_sales_param4 = _datasForDisplay[index].param4.toString();
                Navigator.pushNamed(context, toPage);
              } else if (pop == true) {
                gs_list_index1 = index;
                gs_sales_param1 = _datasForDisplay[index].param1.toString();

                gs_sales_param1 = _datasForDisplay[index].param1.toString();
                gs_sales_param2 = _datasForDisplay[index].param2.toString();
                // ref_doc_no.text =
                //     search_ref_datas[gs_list_index].val2.toString();
                // ref_no.text =
                //     search_ref_datas[gs_list_index].val4.toString();
                // selectedtype =
                //     search_ref_datas[gs_list_index].val3.toString();

                // print(index.toString());
                // print(gs_list_index.toString());
                // gs_prod_code = _datasForDisplay[index].val2;
                gs_sr_doc_no = _datasForDisplay[index].val2;
                gs_sr_doc_salestype = _datasForDisplay[index].val3;
                gs_sr_doc_date = gs_date;
                gs_sr_doc_refno = _datasForDisplay[index].val4;
                // gs_puom = _datasForDisplay[index].val8;
                gs_stk_puom = _datasForDisplay[index].val7;

                Navigator.of(context).pop(true);
                // alert(context, gs_list_index.toString(), Colors.red);

              }
            },
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }
}
