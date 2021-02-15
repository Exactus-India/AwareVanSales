import 'package:aware_van_sales/pages/wm_mb_sales.dart';
import 'package:aware_van_sales/wigdets/salesentry.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

listNew(List datasForDisplay, pageno, toPage) {
  return ListView.builder(
    itemBuilder: (context, index) {
      return Card(
        color: Colors.green[200],
        child: ListTile(
          subtitle: Column(
            children: <Widget>[
              if (pageno == 1 || pageno == 3)
                customerList(datasForDisplay, index),
              if (pageno == 2) salesList(datasForDisplay, index),
            ],
          ),
          onTap: () {
            if (pageno == 1 && toPage != false)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesList(
                          ac_code: datasForDisplay[index].ac_code.toString(),
                          customer:
                              datasForDisplay[index].ac_name.toString())));
            if (pageno == 2 && toPage != false) {
              int saletype_index;
              datasForDisplay[index].sale_type.toString() == 'CASH'
                  ? saletype_index = 0
                  : saletype_index = 1;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesEntry(
                          index: saletype_index,
                          doc_no: datasForDisplay[index].doc_no.toString())));
            }
          },
        ),
      );
    },
    itemCount: datasForDisplay.length,
  );
}

customerList(List datasForDisplay, index) {
  var val2 = datasForDisplay[index].os_amt;
  if (val2 != null) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: val2.toDouble());
    val2 = fmf.output.nonSymbol;
  }
  val2 == null || val2 == '0.00'
      ? val2 = ''
      : val2 = 'O/S amout: ' + val2.toString();
  return Column(
    children: <Widget>[
      rowData_2(datasForDisplay[index].ac_code, val2, 14.0),
      align(Alignment.centerLeft, datasForDisplay[index].ac_name, 14.0),
      align(Alignment.centerLeft,
          datasForDisplay[index].contact_person.toString(), 14.0),
      align(Alignment.centerLeft, datasForDisplay[index].address_one.toString(),
          14.0),
    ],
  );
}

salesList(List datasForDisplay, index) {
  String val2 = datasForDisplay[index].sale_type.toString();
  String date = datasForDisplay[index].doc_date.toString();
  return Column(
    children: <Widget>[
      align(Alignment.centerLeft, date, 14.0),
      rowData_2(datasForDisplay[index].doc_no, val2, 14.0),
      align(
          Alignment.centerLeft, datasForDisplay[index].ref_no.toString(), 14.0),
    ],
  );
}

// list(List datasForDisplay, listbool) {
//   return Column(
//     children: <Widget>[
//       Expanded(
//           child: ListView.builder(
//         itemBuilder: (context, index) {
//           String val1;
//           String val2;
//           String val3;
//           listbool == true
//               ? val1 = datasForDisplay[index].ac_code.toString()
//               : val1 = datasForDisplay[index].doc_no.toString();
//           listbool == true
//               ? val2 = datasForDisplay[index].os_amt.toString()
//               : val2 = datasForDisplay[index].sale_type.toString();
//           listbool == true
//               ? val3 = datasForDisplay[index].ac_name.toString()
//               : val3 = datasForDisplay[index].ref_no.toString();

//           if (val2 == 'null') val2 = '';
//           return Card(
//             child: ListTile(
//               subtitle: Column(
//                 children: <Widget>[
//                   rowData_2(val1, val2, 14.0),
//                   align(Alignment.centerLeft, val3, 14.0),
//                   if (listbool == true)
//                     align(Alignment.centerLeft,
//                         datasForDisplay[index].contact_person.toString(), 14.0),
//                   if (listbool == true)
//                     align(Alignment.centerLeft,
//                         datasForDisplay[index].address_one.toString(), 14.0),
//                 ],
//               ),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => SalesList(
//                             ac_code:
//                                 datasForDisplay[index].ac_code.toString())));
//               },
//             ),
//           );
//         },
//         itemCount: datasForDisplay.length,
//       ))
//     ],
//   );
// }
