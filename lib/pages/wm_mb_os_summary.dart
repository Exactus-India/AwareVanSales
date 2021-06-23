import 'dart:io';

import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:aware_van_sales/wigdets/widget_litView_row.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:ext_storage/ext_storage.dart';

class OsSummary extends StatefulWidget {
  @override
  _OsSummaryState createState() => _OsSummaryState();
}

class _OsSummaryState extends State<OsSummary> {
  List os_summary_report = List();
  TextEditingController userdate = TextEditingController();
  double total = 0, d1 = 0, d2 = 0, d3 = 0, d4 = 0;
  bool loading = false;
  @override
  void initState() {
    os_summary_pro().then((value) {
      os_summary().then((value) {
        os_summary_report.clear();
        os_summary_report.addAll(value);
        loading = true;
        setState(() {
          for (int i = 0; i < os_summary_report.length; i++) {
            total += os_summary_report[i].val3;
            d1 += os_summary_report[i].val4;
            d2 += os_summary_report[i].val5;
            d3 += os_summary_report[i].val6;
            d4 += os_summary_report[i].val7;
          }
          print(
              "os_summary list length " + os_summary_report.length.toString());
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OS Summary'),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          //   Padding(
          //     padding: EdgeInsets.only(right: 30.0),
          //     child: GestureDetector(
          //       onTap: () {},
          //       child: Icon(Icons.print),
          //     ),
          //   )
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
          : Container(
              child: Padding(
                padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gs_currentUser,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // textField("Date", userdate, false, true),

                    Container(
                      color: Colors.grey[800],
                      child: Card(
                        child: ListTile(
                          title: rowData5(
                              "Below 15",
                              "16-30",
                              "31-60",
                              "Above 60  ",
                              "Total",
                              15.0,
                              Colors.deepPurpleAccent),
                          subtitle: rowData5(
                              getNumberFormat(d1),
                              getNumberFormat(d2),
                              getNumberFormat(d3),
                              getNumberFormat(d4),
                              getNumberFormat(total),
                              12.0,
                              Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(child: listView_row_6_fields(os_summary_report)),
                  ],
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
                // mainAxisAlignment: pdfLib.MainAxisAlignment.center,
                children: [
                  // pdfLib.Align(alignment:  ),
                  pdfLib.Text("OS SUMMARY "),
                ]),
          ),
          pdfLib.SizedBox(height: 10.0),
          pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Text("Date: " + gs_date),
                pdfLib.Text("Salesman Name: " + gs_currentUser),
              ]),
          pdfLib.SizedBox(height: 20.0),
          pdfLib.Table.fromTextArray(
              context: context,
              headers: <String>[
                'AC NAME',
                'OS AMOUNT',
                'BELOW 15 DAYS',
                '16-30 DAYS',
                '31-60 DAYS',
                'ABOVE 60 DAYS'
              ],
              cellAlignment: pdfLib.Alignment.centerRight,
              data: <List<dynamic>>[
                ...os_summary_report.map((item) => [
                      item.val2.toString(),
                      getNumberFormat(item.val3).toString(),
                      getNumberFormat(item.val4).toString(),
                      getNumberFormat(item.val5).toString(),
                      getNumberFormat(item.val6).toString(),
                      getNumberFormat(item.val7).toString(),
                    ])
              ]),
          pdfLib.SizedBox(height: 30.0),

          pdfLib.Table.fromTextArray(
              headers: <String>[
                'BELOW 15 DAYS',
                '16-30 DAYS',
                '31-60 DAYS',
                'ABOVE 60 DAYS',
                'TOTAL',
              ],
              cellAlignment: pdfLib.Alignment.centerRight,
              context: context,
              data: <List<dynamic>>[
                [
                  getNumberFormat(d1),
                  getNumberFormat(d2),
                  getNumberFormat(d3),
                  getNumberFormat(d4),
                  getNumberFormat(total),
                ]
              ]),

          pdfLib.SizedBox(height: 30.0),
          pdfLib.Container(
            width: double.infinity,
          ),

          // pdfLib.SizedBox(height: 320.0),

          // pdfLib.Footer()
        ],
      ),
    );
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print(path);
    String fileName = "/OS_SUMMARY-" + gs_currentUser + ".pdf";
    // if (printed_y.toString() == "Y")
    // fileName = "/SALES_SUMMARY-" + doc_no.text + "-copy.pdf";
    final File file = File(path + fileName);
    // if (choice == Constants.DownloadPdf) await file.writeAsBytes(pdf.save());
    // if (choice == Constants.DownloadPdf) showToast("Downloaded to $path");
    if (choice == Constants.ViewPdf)
      Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    if (choice == Constants.SharePdf) {
      await Printing.sharePdf(bytes: pdf.save(), filename: fileName);
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.ViewPdf) {
      _generatePdfAndView(choice);
    } else {
      _generatePdfAndView(choice);
    }
  }
}
