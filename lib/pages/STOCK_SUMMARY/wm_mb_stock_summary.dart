import 'dart:io';

import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import '../../data/future_db.dart';
import '../../wigdets/widgets.dart';
import '../wm_mb_LoginPage.dart';

class StockSummary extends StatefulWidget {
  @override
  _StockSummaryState createState() => _StockSummaryState();
}

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);

class _StockSummaryState extends State<StockSummary> {
  bool loading = false;
  List stockreport = List();
  List column = [
    "PRODUCT",
    "OPENING STOCK",
    "QTY IN",
    "QTY OUT",
    "CLOSING STOCK"
  ];

  @override
  void initState() {
    stock_summary_pro(gs_date, gs_date_to)
        .then((value) => stock_summary().then((value) {
              setState(() {
                stockreport.addAll(value);
                loading = true;
                print("size " + stockreport.length.toString());
              });
            }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Summary'),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          // Padding(
          //   padding: EdgeInsets.only(right: 30.0),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Icon(Icons.print),
          //   ),
          // )

          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: (loading == false)
          ? spinkitLoading()
          : SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                        child: Text(
                          "Stock Report (${gs_zonecode})",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 13.0, right: 13.0),
                          child: text("User: " + gs_currentUser, Colors.black)),
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 13.0, right: 13.0),
                          child: text("Date: " + formatter, Colors.black)),
                      if (stockreport.isNotEmpty)
                        // WidgetdataTable(
                        //     column: column,
                        //     row: stockreport,
                        //     col_space: 15.0,
                        //     data_r_height: 50.0,
                        //     head_r_height: 35.0),
                        listView_row_5(column),
                      if (stockreport.isNotEmpty)
                        Container(
                          height: 560,
                          width: 500,
                          color: Colors.lightBlue[100],
                          child: listView_row_5fields(
                            stockreport,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  _generatePdfAndView(String choice) async {
    final pdf = pdfLib.Document();
    String now = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    // ignore: deprecated_member_use
    final PdfImage assetImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: const AssetImage('assets/BMK.png'),
    );
    pdf.addPage(
      pdfLib.MultiPage(
        header: (context) {
          pdfLib.Text(now);
          return pdfLib.Row(children: [
            pdfLib.ClipRRect(
                child: pdfLib.Container(
                    // ignore: deprecated_member_use
                    child: pdfLib.Image(assetImage),
                    width: 150)),
            pdfLib.SizedBox(width: 15.0),
            pdfLib.Column(
                crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                children: [
                  pdfLib.Text(
                    "Island Valley Electronics L.L.C",
                    style: pdfLib.TextStyle(
                        fontSize: 18.0, fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text("Address :" +
                      "Office No.306,\nAl Habtoor Naif Building\nBaniyas Square\nDubai U.A.E"),
                  pdfLib.Text("Tel : " + " 04-2324747"),
                  pdfLib.Text("TRN_NO : " + "100299579100003"),
                ])
          ]);
        },
        build: (context) => [
          pdfLib.SizedBox(height: 15.0),
          pdfLib.Center(
            child: pdfLib.Column(
                crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                children: [
                  // pdfLib.Align(alignment:  ),
                  pdfLib.Text("STOCK SUMMARY " + '(${gs_zonecode})'),
                  // if (printed_y.toString() == "Y")
                  // pdfLib.Center(
                  //     child: pdfLib.Text("Duplicate copy",
                  //         style: pdfLib.TextStyle(fontSize: 10.0))),
                ]),
          ),
          pdfLib.SizedBox(height: 10.0),
          pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text("Date: " + gs_Route),
                pdfLib.Text("Salesman Name: " + gs_currentUser),
              ]),
          pdfLib.SizedBox(height: 20.0),
          pdfLib.Table.fromTextArray(
              context: context,
              headers: <String>[
                'PRODUCT',
                'OPENING STOCK',
                'QTY IN',
                'QTY OUT',
                'CLOSING STOCK'
              ],
              cellAlignment: pdfLib.Alignment.center,
              // cellAlignments: Map<int,pdfLib.Alignment>(),
              data: <List<dynamic>>[
                ...stockreport.map((item) => [
                      item.val1.toString() +
                          '\n' +
                          item.val2.toString() +
                          '\n' +
                          item.val3.toString(),
                      item.val4.toString(),
                      item.val5.toString(),
                      item.val6.toString(),
                      item.val7.toString(),
                    ])
              ]),
          pdfLib.SizedBox(height: 10.0),

          // pdfLib.SizedBox(height: 320.0),

          // pdfLib.Footer()
        ],
      ),
    );
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print(path);
    String fileName = "/STOCK_SUMMARY-" + gs_currentUser + ".pdf";
    // if (printed_y.toString() == "Y")
    // fileName = "/SALES_SUMMARY-" + doc_no.text + "-copy.pdf";
    final File file = File(path + fileName);
    // if (choice == Constants.DownloadPdf) await file.writeAsBytes(pdf.save());
    // if (choice == Constants.DownloadPdf) showToast("Downloaded to $path");
    if (choice == Constants.ViewPdf)
      Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    if (choice == Constants.SharePdf) {
      await Printing.sharePdf(bytes: pdf.save(), filename: fileName);
      // if (printed_y == "N")
      //   setState(() {
      //     printed_y = "Y";
      //     updateHdr();
      //   });
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.ViewPdf) {
      _generatePdfAndView(choice);
    } else {
      _generatePdfAndView(choice);
    }
  }

  listView_row_5fields(List datasForDisplay) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          child: Card(
            child: ListTile(
              subtitle: rowData5(
                  datasForDisplay[index].val1.toString() +
                      "\n" +
                      datasForDisplay[index].val2.toString() +
                      " \n" +
                      datasForDisplay[index].val3.toString(),
                  datasForDisplay[index].val4.toString(),
                  datasForDisplay[index].val5.toString(),
                  datasForDisplay[index].val6.toString(),
                  datasForDisplay[index].val7.toString(),
                  12.5,
                  Colors.black),
            ),
          ),
        );
      },
      itemCount: datasForDisplay.length,
    );
  }

  listView_row_5(List datasForDisplay) {
    return Container(
      child: Card(
        color: Colors.green[300],
        child: ListTile(
          // title: Text(datasForDisplay[index].val1.toString()),

          subtitle: rowData5(
              datasForDisplay[0],
              datasForDisplay[1],
              datasForDisplay[2],
              datasForDisplay[3],
              datasForDisplay[4],
              12.5,
              Colors.black),
        ),
      ),
    );
  }
}

rowData5(first, second, third, fourth, last, size, color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Flexible(
          fit: FlexFit.tight,
          flex: 2,
          child: columnRow1(first.toString(), MainAxisAlignment.center, size,
              TextAlign.left, color)),
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: columnRow1(second.toString(), MainAxisAlignment.end, size,
              TextAlign.right, color)),
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: columnRow1(third.toString(), MainAxisAlignment.end, size,
              TextAlign.end, color)),
      Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: columnRow1(fourth.toString(), MainAxisAlignment.end, size,
              TextAlign.end, color)),
      if (last != null)
        Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: columnRow1(last.toString(), MainAxisAlignment.end, size,
                TextAlign.right, color)),
    ],
  );
}
