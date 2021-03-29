import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'widget_rowData.dart';

listView_row_3_fields(List datasForDisplay, container_height) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Container(
        height: container_height,
        child: Card(
          child: ListTile(
            subtitle: rowData3(
                datasForDisplay[index].val1.toString(),
                datasForDisplay[index].val2.toString(),
                getNumberFormat(datasForDisplay[index].val3),
                14.0),
          ),
        ),
      );
    },
    itemCount: datasForDisplay.length,
  );
}

listView_row_4_fields(List datasForDisplay) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Container(
        child: Card(
          child: ListTile(
            title: Text(datasForDisplay[index].val5.toString()),
            subtitle: rowData4(
                datasForDisplay[index].val1.toString(),
                datasForDisplay[index].val2.toString(),
                datasForDisplay[index].val3.toString(),
                getNumberFormat(datasForDisplay[index].val4),
                12.0),
          ),
        ),
      );
    },
    itemCount: datasForDisplay.length,
  );
}

listView_row_5_fields(datasForDisplay, container_height) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return Container(
        height: container_height,
        child: Card(
          child: ListTile(
            title:
                rowData_2(datasForDisplay[index], datasForDisplay[index], 15.0),
            subtitle: rowData4(
                ">15" + datasForDisplay[index],
                "16-30" + datasForDisplay[index],
                "31-60" + datasForDisplay[index],
                "Above 60" + datasForDisplay[index],
                14.0),
          ),
        ),
      );
    },
    itemCount: datasForDisplay.length,
  );
}

listView_row_6_fields(List datasForDisplay) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Container(
          color: Colors.blue[300],
          child: Card(
            child: ListTile(
              subtitle: rowData6(
                  datasForDisplay[index].val2.toString(),
                  datasForDisplay[index].val4 != 0
                      ? getNumberFormat(datasForDisplay[index].val4)
                      : datasForDisplay[index].val4.toStringAsFixed(2),
                  datasForDisplay[index].val5 != 0
                      ? getNumberFormat(datasForDisplay[index].val5)
                      : datasForDisplay[index].val5.toStringAsFixed(2),
                  datasForDisplay[index].val6 != 0
                      ? getNumberFormat(datasForDisplay[index].val6)
                      : datasForDisplay[index].val6.toStringAsFixed(2),
                  datasForDisplay[index].val7 != 0
                      ? getNumberFormat(datasForDisplay[index].val7)
                      : datasForDisplay[index].val7.toStringAsFixed(2),
                  datasForDisplay[index].val3 != 0
                      ? getNumberFormat(datasForDisplay[index].val3)
                      : datasForDisplay[index].val3.toStringAsFixed(2),
                  13.0),
            ),
          ));
    },
    itemCount: datasForDisplay.length,
  );
}
