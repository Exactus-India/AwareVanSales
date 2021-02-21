import 'dart:async';

import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'listing_Builder.dart';

class ListHorizontal extends StatefulWidget {
  final List datas;
  final bool popBack;

  const ListHorizontal({Key key, this.datas, this.popBack}) : super(key: key);
  @override
  _ListHorizontalState createState() => _ListHorizontalState();
}

class _ListHorizontalState extends State<ListHorizontal> {
  List _datas = List();
  bool _timer_ = false;

  @override
  void initState() {
    setState(() {
      _datas = widget.datas;
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
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          if (_timer_ == true)
            Expanded(
              child: listView(_datas),
            ),
        ],
      ),
    );
  }

  listView(List datasForDisplay) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.green[200],
          child: ListTile(
            subtitle: Expanded(
              child: Column(
                children: <Widget>[
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val1.toString(), 14.0),
                  align(Alignment.centerLeft,
                      datasForDisplay[index].val2.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val3.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val4.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val5.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val6.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val7.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val8.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val9.toString(), 14.0),
                  // align(Alignment.centerLeft,
                  //     datasForDisplay[index].val10.toString(), 14.0),
                ],
              ),
            ),
            onTap: () {
              gs_list_index = index;
              Navigator.of(context).pop(true);
            },
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }
}
