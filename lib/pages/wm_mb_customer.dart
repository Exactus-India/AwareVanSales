import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'wm_mb_LoginPage.dart';

class CustomerList extends StatefulWidget {
  final toPage;

  const CustomerList({Key key, this.toPage}) : super(key: key);
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List _datas = List();
  List _datasForDisplay = List();
  bool _timer_ = false;

  @override
  void initState() {
    getdatas();
    super.initState();
  }

  getdatas() {
    return customersaleslist().then((value) {
      _datas.clear();
      _datasForDisplay.clear();
      setState(() {
        _datas.addAll(value);
        _datasForDisplay = _datas;
        list_length = 0;
        list_length = _datas.length;
        print(list_length.toString() + '....');
        _timer_ = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer List", style: TextStyle(color: Colors.white)),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
        _searchBar(),
        SizedBox(height: 5.0),
        if (_timer_ == true) if (list_length == 0) noValue(),
        if (_timer_ == true)
          Expanded(child: listView(_datasForDisplay, widget.toPage)),
      ]),
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

  listView(List datasForDisplay, toPage) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var val3;
        datasForDisplay[index].val3 is num
            ? val3 = getNumberFormat(datasForDisplay[index].val3)
            : val3 = datasForDisplay[index].val3;
        if (val3 == null) val3 = " ";
        return Card(
          color: Colors.green[200],
          child: ListTile(
            subtitle: Column(
              children: <Widget>[
                if (datasForDisplay[index].val1 != null)
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val1.toString(), 14.0),
                if (datasForDisplay[index].val2 != null)
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
              if (widget.toPage != null) {
                gs_sales_param1 = _datasForDisplay[index].param1.toString();
                gs_sales_param2 = _datasForDisplay[index].param2.toString();
                if (_datasForDisplay[index].param3 != null)
                  gs_sales_param3 = _datasForDisplay[index].param3.toString();
                if (_datasForDisplay[index].param4 != null)
                  gs_sales_param4 = _datasForDisplay[index].param4.toString();
                Navigator.pushNamed(context, toPage).then((value) {
                  setState(() {
                    _timer_ = false;
                    _searchBar();
                    getdatas();
                  });
                });
              }
            },
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }
}
