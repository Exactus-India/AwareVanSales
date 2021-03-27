import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

rowData_3(first, middle, last, clr, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      columnRow(first.toString(), CrossAxisAlignment.start,
          MainAxisAlignment.start, size, TextAlign.left),
      if (middle != null)
        columnRow(middle.toString(), CrossAxisAlignment.start,
            MainAxisAlignment.center, size, TextAlign.center),
      if (last != null)
        columnRow(last.toString(), CrossAxisAlignment.start,
            MainAxisAlignment.end, size, TextAlign.right),
    ],
  );
}

rowData_2(first, last, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      if (first != null || first != 'null')
        columnRow(first.toString(), CrossAxisAlignment.start,
            MainAxisAlignment.start, size, TextAlign.left),
      if (last != null || last != 'null')
        columnRow(last.toString(), CrossAxisAlignment.start,
            MainAxisAlignment.end, size, TextAlign.right),
    ],
  );
}

rowData3(first, middle, last, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(first.toString(), CrossAxisAlignment.start,
              MainAxisAlignment.start, size, TextAlign.left)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(middle.toString(), CrossAxisAlignment.center,
              MainAxisAlignment.center, size, TextAlign.center)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(last.toString(), CrossAxisAlignment.end,
              MainAxisAlignment.spaceAround, size, TextAlign.right)),
    ],
  );
}

rowData4(first, second, third, last, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Flexible(
          // flex: 1,
          fit: FlexFit.loose,
          child: columnRow(first.toString(), CrossAxisAlignment.start,
              MainAxisAlignment.spaceEvenly, size, TextAlign.left)),
      Flexible(
          flex: 2,
          // fit: FlexFit.tight,
          child: columnRow(second.toString(), CrossAxisAlignment.center,
              MainAxisAlignment.spaceEvenly, size, TextAlign.left)),
      Flexible(
          flex: 1,
          // fit: FlexFit.tight,
          child: columnRow(third.toString(), CrossAxisAlignment.center,
              MainAxisAlignment.center, size, TextAlign.center)),
      Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: columnRow(last.toString(), CrossAxisAlignment.end,
              MainAxisAlignment.spaceEvenly, size, TextAlign.center)),
    ],
  );
}

rowData5(first, second, third, fourth, last, size, color) {
  var flex = FlexFit.tight;
  if (last == null) flex = FlexFit.loose;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
          fit: FlexFit.tight,
          child: columnRow1(first.toString(), MainAxisAlignment.center, size,
              TextAlign.left, color)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow1(second.toString(), MainAxisAlignment.center, size,
              TextAlign.center, color)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow1(third.toString(), MainAxisAlignment.center, size,
              TextAlign.center, color)),
      Flexible(
          fit: flex,
          child: columnRow1(fourth.toString(), MainAxisAlignment.center, size,
              TextAlign.right, color)),
      if (last != null)
        Flexible(
            fit: FlexFit.tight,
            child: columnRow1(last.toString(), MainAxisAlignment.center, size,
                TextAlign.right, color)),
    ],
  );
}

rowData6(first, second, third, fourth, fivth, last, size) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: columnRow(first.toString(), CrossAxisAlignment.start,
                MainAxisAlignment.start, 16.0, TextAlign.left),
          ),
          Flexible(child: textData(last.toString(), Colors.black, 15.0))
        ],
      ),
      SizedBox(
        height: 10,
      ),
      rowData5("<15 Days", "16-30 Days", "31-60 Days", "Above 60 Days", null,
          13.0, Colors.deepPurpleAccent),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
              fit: FlexFit.tight,
              child: columnRow(second.toString(), CrossAxisAlignment.start,
                  MainAxisAlignment.spaceEvenly, size, TextAlign.left)),
          Flexible(
              fit: FlexFit.tight,
              child: columnRow(third.toString(), CrossAxisAlignment.start,
                  MainAxisAlignment.spaceEvenly, size, TextAlign.center)),
          Flexible(
              fit: FlexFit.tight,
              child: columnRow(fourth.toString(), CrossAxisAlignment.start,
                  MainAxisAlignment.spaceEvenly, size, TextAlign.center)),
          Flexible(
              fit: FlexFit.loose,
              child: columnRow(fivth.toString(), CrossAxisAlignment.start,
                  MainAxisAlignment.spaceEvenly, size, TextAlign.center)),
        ],
      ),
    ],
  );
}

rowData(first, second, third, last, size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    // crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
          width: 50,
          padding: EdgeInsets.only(left: 5.0),
          child: columnRow(first.toString(), CrossAxisAlignment.start,
              MainAxisAlignment.spaceEvenly, size, TextAlign.left)),
      Container(
          width: 140,
          child: columnRow(second.toString(), CrossAxisAlignment.center,
              MainAxisAlignment.spaceEvenly, size, TextAlign.left)),
      Flexible(
          fit: FlexFit.tight,
          child: columnRow(third.toString(), CrossAxisAlignment.center,
              MainAxisAlignment.center, size, TextAlign.center)),
      Container(
          // width: 50,
          padding: EdgeInsets.only(right: 8.0),
          child: columnRow(last.toString(), CrossAxisAlignment.end,
              MainAxisAlignment.spaceEvenly, size, TextAlign.center)),
    ],
  );
}
