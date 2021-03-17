import '../wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';

class WidgetdataTable extends StatefulWidget {
  final List column;
  final List row;
  final double head_r_height;
  final double data_r_height;
  final double col_space;

  const WidgetdataTable(
      {Key key,
      this.column,
      this.row,
      this.head_r_height,
      this.data_r_height,
      this.col_space})
      : super(key: key);

  @override
  _WidgetdataTableState createState() => _WidgetdataTableState();
}

class _WidgetdataTableState extends State<WidgetdataTable> {
  static int numItems = 00;
  List<bool> selected;
  List rowList = List();
  List columnList = List();
  @override
  void initState() {
    setState(() {
      columnList = widget.column;
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
      child: Column(
        children: <Widget>[
          if (columnList.length <= 7)
            dataTablecolumn_7(numItems, rowList, widget.column,
                widget.head_r_height, widget.data_r_height, widget.col_space),
          if (columnList.length > 7)
            CustomDataTable(
                headerColor: Colors.green[200],
                rowColor1: Colors.grey.shade300,
                dataTable: dataTablecolumn_10(
                    numItems,
                    rowList,
                    widget.column,
                    widget.head_r_height,
                    widget.data_r_height,
                    widget.col_space))
        ],
      ),
    );
  }

  dataTablecolumn_7(
      numItems, rowList, column, h_row_height, d_row_height, col_space) {
    return DataTable(
        headingRowHeight: h_row_height,
        // dataRowHeight: d_row_height,
        columnSpacing: col_space,
        showCheckboxColumn: false,
        columns: [
          for (int i = 0; i <= column.length - 1; i++)
            DataColumn(
              label: text(column[i], Colors.black),
            ),
        ],
        rows: List<DataRow>.generate(
          numItems,
          (index) => DataRow(cells: <DataCell>[
            DataCell(
              SizedBox(
                width: 150.0,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rowList[index].val1.toString()),
                        if (rowList[index].val2 != null &&
                            rowList[index].val3 != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(rowList[index].val2.toString()),
                              Text(rowList[index].val3.toString()),
                            ],
                          )
                      ]),
                ),
              ),
            ),
            DataCell(Align(
                alignment: Alignment.centerRight,
                child: Text(rowList[index].val4.toString()))),
            if (rowList[index].val5 != null)
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(rowList[index].val5.toString()))),
            if (rowList[index].val6 != null)
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(rowList[index].val6.toString()))),
            if (rowList[index].val7 != null)
              DataCell(Align(
                  alignment: Alignment.centerRight,
                  child: Text(rowList[index].val7.toString()))),
          ]),
        ));
  }

  dataTablecolumn_10(
      numItems, rowList, column, h_row_height, d_row_height, col_space) {
    return DataTable(
        headingRowHeight: h_row_height,
        dataRowHeight: d_row_height,
        columnSpacing: col_space,
        showCheckboxColumn: false,
        columns: [
          for (int i = 0; i <= column.length - 1; i++)
            DataColumn(
              label: text(column[i], Colors.black),
            ),
        ],
        rows: List<DataRow>.generate(
          numItems,
          (index) => DataRow(cells: <DataCell>[
            DataCell(Text(rowList[index].val1.toString())),
            DataCell(Text(rowList[index].val2.toString())),
            DataCell(Text(rowList[index].val3.toString())),
            DataCell(Text(rowList[index].val4.toString())),
            DataCell(Text(rowList[index].val5.toString())),
            DataCell(Text(rowList[index].val6.toString())),
            DataCell(Text(rowList[index].val7.toString())),
            DataCell(Text(rowList[index].val8.toString())),
            DataCell(Text(rowList[index].val9.toString())),
            DataCell(Text(rowList[index].val10.toString())),
          ]),
        ));
  }
}
