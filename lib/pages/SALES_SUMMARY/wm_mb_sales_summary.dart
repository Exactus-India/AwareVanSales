import 'dart:io';

import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/wigdets/spinkitLoading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../wigdets/widget_litView_row.dart';
import '../../wigdets/widget_rowData.dart';
import '../../wigdets/widgets.dart';
import '../wm_mb_LoginPage.dart';
import '../../data/future_db.dart';
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:ext_storage/ext_storage.dart';

class SalesSummary extends StatefulWidget {
  @override
  _SalesSummaryState createState() => _SalesSummaryState();
}

var now = new DateTime.now();
String formatter = DateFormat('yMd').format(now);
String datelabelformatter = gs_date;

class _SalesSummaryState extends State<SalesSummary> {
  TextEditingController date = TextEditingController();
  int totalCash = 0;
  List salesumm_1 = List();
  List salesumm_2 = List();
  bool loading = false;

  String finalDate = '';
  var _selectedDate;
  var _tot_cash;
  var _tot_credit;
  var _tot_sales;

  TextEditingController _datecontroller = new TextEditingController();
  TextEditingController userid = new TextEditingController();

  @override
  void initState() {
    _selectedDate = gs_date;
    userid.text = gs_currentUser_empid.toString();

    sales_sum_pro(_selectedDate, userid.text).then((value) {
      print("init" + _selectedDate);
      sales_sum1().then((value) {
        setState(() {
          salesumm_1.addAll(value);
          print("summary1 list length " + salesumm_1.length.toString());
        });
      });
      sales_sum2().then((value) {
        setState(() {
          salesumm_2.addAll(value);
          loading = true;
          print(salesumm_2);
          print("summary2 list length " + salesumm_2.length.toString());
        });
      });
    });

    super.initState();
  }

  retrive() {
    salesumm_1.clear();
    salesumm_2.clear();
    return sales_sum_pro(_selectedDate, userid.text).then((value) {
      print("init" + _selectedDate);
      sales_sum1().then((value) {
        setState(() {
          salesumm_1.addAll(value);
          loading = true;
          _tot_cash = salesumm_1[0].val3;
          _tot_credit = salesumm_1[1].val3;
          _tot_sales = salesumm_1[2].val3;
          print("summary1 list length " + salesumm_1.length.toString());
        });
      });
      sales_sum2().then((value) {
        setState(() {
          salesumm_2.addAll(value);
          loading = true;
          print(salesumm_2);
          print("summary2 list length " + salesumm_2.length.toString());
        });
      });
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((datePicker) {
      print(datePicker);
      setState(() {
        _selectedDate = DateFormat("dd-MMM-yyyy").format(datePicker);
      });
      print(_selectedDate);
    });
  }

  textFieldUser(_text, _controller, _validate, read) {
    return TextField(
      // onTap: () => _presentDatePicker(),
      readOnly: read,
      decoration: InputDecoration(
        labelText: _text,
        border: const OutlineInputBorder(),
        contentPadding: EdgeInsets.all(10),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        focusColor: Colors.blue,
        labelStyle: TextStyle(color: Colors.black54),
      ),
      controller: _controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Summary'),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: RaisedButton(
              color: Colors.green[400],
              onPressed: () {
                setState(() {
                  loading = false;
                  retrive();
                });
              },
              child: Text('Retrive'),
            ),
          ),
          SizedBox(
            width: 3.0,
          ),
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
                child: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: align(Alignment.topLeft, gs_currentUser, 18.0),
                      ),
                      Form(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                                flex: 3,
                                child: Row(
                                  children: <Widget>[
                                    Text(_selectedDate == null
                                        ? gs_date
                                        : _selectedDate),
                                    IconButton(
                                        icon: Icon(
                                          Icons.calendar_today,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _presentDatePicker();
                                          });
                                        })
                                  ],
                                )),
                            Flexible(
                                flex: 1,
                                child: textFieldUser(
                                    "SALESMAN ID", userid, false, false)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (salesumm_1.isNotEmpty)
                        Container(
                            height: 120,
                            width: 400,
                            color: Colors.lightBlue[100],
                            child: listView_row_3_fields(salesumm_1, 40.0)),
                      SizedBox(
                        height: 30,
                      ),
                      rowData4("Sl.No", "Description ", " Items",
                          "Amount      ", 14.0),
                      SizedBox(height: 10),
                      Container(
                        height: 400,
                        width: 560,
                        color: Colors.lightBlue[100],
                        child: listView_row_4_fields(salesumm_2),
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
                  pdfLib.Text("SALES SUMMARY "),
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
                pdfLib.Text("Date: " + _selectedDate),
                pdfLib.Text("Salesman Name: " + gs_currentUser),
              ]),
          pdfLib.SizedBox(height: 20.0),
          pdfLib.Table.fromTextArray(
              context: context,
              headers: <String>[
                'SNo',
                'SALES TYPE',
                'DESCRIPTION',
                'ITEMS',
                'AMOUNT'
              ],
              cellAlignment: pdfLib.Alignment.centerRight,
              data: <List<dynamic>>[
                ...salesumm_2.map((item) => [
                      item.val1.toString(),
                      item.val5.toString(),
                      item.val2.toString(),
                      item.val3.toString(),
                      getNumberFormat(item.val4).toString(),
                    ])
              ]),
          pdfLib.SizedBox(height: 10.0),
          pdfLib.Container(
            width: double.infinity,
            child:
                pdfLib.Column(crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                    // mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                    children: [
                  pdfLib.Text(
                    "Total Cash Sale :" + getNumberFormat(_tot_cash),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text(
                    "Total Credit Sale :" + getNumberFormat(_tot_credit),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text(
                    "Total Sale :" + getNumberFormat(_tot_sales),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                ]),
          ),

          // pdfLib.SizedBox(height: 320.0),

          // pdfLib.Footer()
        ],
      ),
    );
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print(path);
    String fileName = "/SALES_SUMMARY-" + gs_currentUser + ".pdf";
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
}
