import 'dart:async';

import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'widget_rowData.dart';

class ListBuilderCommon extends StatefulWidget {
  final List datas;
  final toPage;
  final bool head;
  final bool popBack;

  const ListBuilderCommon(
      {Key key, this.datas, this.toPage, this.head, this.popBack})
      : super(key: key);
  @override
  _ListBuilderCommonState createState() => _ListBuilderCommonState();
}

int list_length;

String gs_sales_param1;
String gs_sales_param2;
String gs_sales_param3;
int gs_list_index;

class _ListBuilderCommonState extends State<ListBuilderCommon> {
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
    print(list_length.toString() + '/////');
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
        if (widget.head == true)
          Container(
              margin: EdgeInsets.only(top: 10.0, left: 10.0),
              child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
        _searchBar(),
        widget.head == true && gs_sales_param1 != null
            ? sales_head()
            : SizedBox(height: 5.0),
        if (_timer_ == true) if (list_length == 0) noValue(),
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
                gs_sales_param3 = _datasForDisplay[index].param3.toString();
                Navigator.pushNamed(context, toPage);
              } else if (pop == true) {
                gs_list_index = index;
                Navigator.of(context).pop(true);
              }
            },
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }
}
