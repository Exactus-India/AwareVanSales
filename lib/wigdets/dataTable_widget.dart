import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class WidgetdataTable extends StatefulWidget {
  final List column;
  final List row;

  const WidgetdataTable({Key key, this.column, this.row}) : super(key: key);

  @override
  _WidgetdataTableState createState() => _WidgetdataTableState();
}

class _WidgetdataTableState extends State<WidgetdataTable> {
  static int numItems = 00;
  List<bool> selected;
  List rowList = List();
  @override
  void initState() {
    setState(() {
      rowList = widget.row;
      numItems = rowList.length;
      selected = List<bool>.generate(numItems, (index) => false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 20.0),
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: [
            for (int i = 0; i <= widget.column.length - 1; i++)
              DataColumn(
                label: text(widget.column[i], Colors.black),
              ),
          ],
          rows: List<DataRow>.generate(
            numItems,
            (index) => DataRow(cells: <DataCell>[
              DataCell(
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rowList[index].val1.toString()),
                        if (rowList[index].val2 != null &&
                            rowList[index].val3 != null)
                          Flexible(
                            fit: FlexFit.tight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(rowList[index].val2.toString()),
                                Text(rowList[index].val3.toString()),
                              ],
                            ),
                          )
                      ]),
                ),
              ),
              DataCell(Text(rowList[index].val4.toString())),
              if (rowList[index].val5 != null)
                DataCell(Text(rowList[index].val5.toString())),
              if (rowList[index].val6 != null)
                DataCell(Text(rowList[index].val6.toString())),
              if (rowList[index].val7 != null)
                DataCell(Text(rowList[index].val7.toString())),
            ]),
          )),
    );
  }
}
