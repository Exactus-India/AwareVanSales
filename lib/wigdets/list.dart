import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/pages/wm_mb_sales.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

list(List<Sales_Customer_Data> datasForDisplay, listbool) {
  return Column(
    children: <Widget>[
      Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) {
          String val1;
          String val2;
          String val3;
          listbool == true
              ? val1 = datasForDisplay[index].ac_code.toString()
              : val1 = datasForDisplay[index].doc_no.toString();
          listbool == true
              ? val2 = datasForDisplay[index].os_amt.toString()
              : val2 = datasForDisplay[index].sale_type.toString();
          listbool == true
              ? val3 = datasForDisplay[index].ac_name.toString()
              : val3 = datasForDisplay[index].ref_no.toString();

          if (val2 == 'null') val2 = '';
          return Card(
            child: ListTile(
              subtitle: Column(
                children: <Widget>[
                  rowData_2(val1, val2, 14.0),
                  align(Alignment.centerLeft, val3, 14.0),
                  if (listbool == true)
                    align(Alignment.centerLeft,
                        datasForDisplay[index].contact_person.toString(), 14.0),
                  if (listbool == true)
                    align(Alignment.centerLeft,
                        datasForDisplay[index].address_one.toString(), 14.0),
                ],
              ),
              onTap: () {
                listbool
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesList(
                                ac_code:
                                    datasForDisplay[index].ac_code.toString())))
                    : null;
              },
            ),
          );
        },
        itemCount: datasForDisplay.length,
      ))
    ],
  );
}
