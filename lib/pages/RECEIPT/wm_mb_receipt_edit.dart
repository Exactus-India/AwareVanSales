import 'dart:io';

import 'package:aware_van_sales/components/number_to_text.dart';
import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/receipt_docsearch.dart';
import 'package:aware_van_sales/wigdets/salesreturnListBuilder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/future_db.dart';
import '../../wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:ext_storage/ext_storage.dart';

class ReceiptEntry_Edit extends StatefulWidget {
  final ac_name;
  final outbal;
  final ac_code;

  const ReceiptEntry_Edit({
    Key key,
    this.ac_code,
    this.outbal,
    this.ac_name,
  }) : super(key: key);
  @override
  _ReceiptEntry_EditState createState() => _ReceiptEntry_EditState();
}

class VatAmounts {
  String name;
  String amt;
  VatAmounts(this.name, this.amt);
}

String gs_cust;
String gs_docno;
String gs_refno;

class _ReceiptEntry_EditState extends State<ReceiptEntry_Edit> {
  TextEditingController customer = new TextEditingController();
  TextEditingController doc_no = new TextEditingController();
  TextEditingController ref_no = new TextEditingController();
  String _translatedValue = '';
  bool doc_generate = false;
  bool second_insert = false;
  bool third_insert = false;
  bool saves = false;
  var lcur_amt;
  var docdate;
  var pdf_baltot;
  var pdf_orgtot;
  var pdf_amt;
  String remarks;
  String _gscurrencycode = 'AED';
  double bamt = 0;
  double oamt = 0;
  double tot_amt = 0;
  double pdf_tot_amt = 0;
  int serial_no = 1;
  int det_serial_no = 0;
  List recHDR = List();
  List rec_inv_List = List();
  List pdf_List = List();
  List docsearch = List();
  List invlist = List();
  List datacolumn = ["INV. NO", "INV. DATE", "AMOUNT"];
  List<TextEditingController> _controller;
  @override
  void initState() {
    customer.text = widget.ac_name;
    // customer.text = widget.outbal;
    // receipt_HDR(docno).then((value) {
    //   recHDR.clear();
    //   recHDR.addAll(value);
    // });
    // inv_List(widget.ac_code);

    rec_doc_list(gs_currentUser).then((value) {
      docsearch.clear();
      docsearch.addAll(value);
      print(docsearch.length.toString());
      print("./../../../");
    });
    super.initState();
  }

  rec_inv_list() {
    edit_rec_invlist(doc_no.text).then((value) {
      setState(() {
        tot_amt = 0;
        invlist.clear();
        invlist.addAll(value);
        print(invlist.length.toString());
        print("./././invlist");
        docdate = invlist[0].val7;
        print(docdate);
        for (int i = 0; i < invlist.length; i++) {
          tot_amt += invlist[i].val3;
        }
      });
    });
  }

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    setState(() {
      currentPosition = position;
      geoLocation = "${position.latitude},${position.longitude}";

      _getAddressFromLatLng();
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        // _currentAddress = "${place.locality}, ${place.country}";
        currentAddress =
            "${place.name},${place.street},${place.locality}, ${place.postalCode},${place.administrativeArea}, ${place.country}";
        country_name = '${place.country}';
      });
      print(currentAddress);
    } catch (e) {
      print(e);
    }
  }

  // inv_List(ac_code) {
  //   tot_amt = 0;
  //   bamt = 0;
  //   oamt = 0;
  //   return rec_inv_Table(ac_code).then((value) {
  //     setState(() {
  //       rec_inv_List.clear();
  //       rec_inv_List.addAll(value);
  //       print(rec_inv_List.length);

  //       _controller = [
  //         for (int i = 0; i < rec_inv_List.length; i++) TextEditingController()
  //       ];
  //       for (int i = 0; i < rec_inv_List.length; i++) {
  //         bamt += rec_inv_List[i].val5;
  //         oamt += rec_inv_List[i].val6;
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt"),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              if (doc_no.text.isNotEmpty) {
                setState(() {
                  delete();
                  tot_amt = 0;
                  invlist.clear();
                });
              } else {
                alert(context, "Doc no is Empty", Colors.red);
              }
            },
            child: Icon(Icons.delete),
          ),
          SizedBox(width: 20.0),
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
          SizedBox(width: 20.0),
        ],
      ),
      body: SingleChildScrollView(
        child: new Padding(
          padding: new EdgeInsets.only(top: 14.0),
          child: new Form(
            child: Column(
              children: [
                // SizedBox(height: 5),
                head(),
                SizedBox(height: 15),
                if (invlist.isNotEmpty)
                  listing(invlist.length + 1, invlist, datacolumn),
                SizedBox(height: 10),
                // RaisedButton(
                //   onPressed: null,
                //   child: Text(
                //     "View Invoice",
                //     style: TextStyle(color: Colors.black),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  head() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        textField("Customer", customer, false, true),
        SizedBox(height: 4),
        Row(
          children: [
            Flexible(
                flex: 1,
                child:
                    textField1("DOC NO", doc_no, false, true, TextAlign.left)),
            if (doc_generate != true) SizedBox(width: 4.0),
            if (doc_generate == false)
              Flexible(
                  child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showDialog(
                                context: context,
                                builder: (BuildContext context) => docnolist())
                            .then((value) {
                          setState(() {
                            // if (gs_list_index != null) {
                            customer.clear();
                            doc_no.clear();
                            ref_no.clear();
                            if (gs_cust != 'null') customer.text = gs_cust;
                            if (gs_docno != 'null') doc_no.text = gs_docno;
                            if (gs_refno != 'null') ref_no.text = gs_refno;
                            rec_inv_list();
                            print("Accordingly");

                            // }
                          });
                        });
                      })),
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Row(children: <Widget>[
          Flexible(
              flex: 1,
              child: textField1("REF NO", ref_no, false, true, TextAlign.left)),
          // Flexible(
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 20.0),
          //     child: IconButton(
          //         icon: Icon(
          //           Icons.print,
          //           size: 30.0,
          //         ),
          //         onPressed: () {}),
          //   ),
          // )
        ]),
      ]),
    );
  }

  docnolist() {
    return AlertDialog(
      content: Container(
        height: 400.0,
        width: 300.0,
        child: Doc_search(
            datas: docsearch, toPage: null, head: false, popBack: true),
      ),
    );
  }

  listing(itemCount, rowList, column) {
    print(_controller);
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: FittedBox(
        fit: BoxFit.contain,
        child: CustomDataTable(
            headerColor: Colors.lightBlueAccent[100],
            rowColor1: Colors.grey.shade300,
            dataTable: DataTable(
                headingRowHeight: 35.0,
                dataRowHeight: 35,
                columnSpacing: 11.0,
                showCheckboxColumn: false,
                columns: [
                  for (int i = 0; i <= column.length - 1; i++)
                    DataColumn(label: text(column[i], Colors.black))
                ],
                rows: List<DataRow>.generate(
                    itemCount,
                    (index) => DataRow(
                          // onSelectChanged: (va) {
                          // },
                          cells: <DataCell>[
                            //inv no.

                            if (index != itemCount - 1)
                              DataCell(Text(rowList[index].val1.toString(),
                                  style: TextStyle(fontSize: 12))),
                            if (index == itemCount - 1)
                              DataCell(textBold("TOTAL")),
                            //inv date
                            if (index != itemCount - 1)
                              DataCell(Text(rowList[index].val2.toString(),
                                  style: TextStyle(fontSize: 12))),
                            if (index == itemCount - 1) DataCell(textBold(" ")),
                            // amt
                            if (index != itemCount - 1)
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    getNumberFormat(rowList[index].val3),
                                    style: TextStyle(fontSize: 12),
                                  ))),
                            if (index == itemCount - 1)
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: textBold(getNumberFormatRound(tot_amt)
                                      .toString()))),
                            //balance amount
                          ],
                        )))),
      ),
    );
  }

  delete() async {
    rec_list_delete(doc_no.text).then((value) {
      if (value == 'true') {
        print("Deleted Successfully");
      } else {
        alert(context, value, Colors.red);
      }
    }).then((value) {
      rec_list_detail_delete(doc_no.text).then((value) {
        if (value == 'true') {
          print("Detail Deleted Successfully");
          doc_no.clear();
          customer.clear();
          ref_no.clear();
        } else {
          alert(context, value, Colors.red);
        }
      });
    }).then((value) {
      rec_list_invdetail_delete(doc_no.text).then((value) {
        if (value == 'true') {
          alert(context, ' Deleted Successfully', Colors.red);
        } else {
          alert(context, value, Colors.red);
        }
      });
    });
  }

  textField_data(_label, _controller_, _align, bal_amt) {
    return TextField(
      controller: _controller_,
      textAlign: _align,
      style: TextStyle(fontSize: 12),
      onChanged: (value) {
        setState(() {
          calculate(value, bal_amt);
        });
      },
      decoration: InputDecoration(border: InputBorder.none, hintText: _label),
    );
  }

  calculate(value, bal_amt) {
    if (double.parse(value) > bal_amt) {
      alert(context, "Available balance " + bal_amt.toString(), Colors.orange);
    }
    tot_amt = 0;
    for (int i = 0; i < rec_inv_List.length; i++)
      if (_controller[i].text.isNotEmpty) {
        tot_amt += double.parse(_controller[i].text);
      }
  }

  _generatePdfAndView(String choice) async {
    final pdf = pdfLib.Document();
    print(getNumberFormatRound(tot_amt));
    final valamounts = [
      // VatAmounts(" ", " "),
      // VatAmounts("Total Balance ", getNumberFormat(pdf_baltot).toString()),
      // VatAmounts(" ", " "),
      VatAmounts('Total Amount', getNumberFormatRound(tot_amt))
    ];
    // final headvat = ['Total Amount', getNumberFormat(tot_amt).toString()];

    final vatdat =
        valamounts.map((vatamnt) => [vatamnt.name, vatamnt.amt]).toList();

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
                  pdfLib.Text("RECEIPT"),
                  // if (printed_y.toString() == "Y")
                  // pdfLib.Center(
                  //     child: pdfLib.Text("Duplicate copy",
                  //         style: pdfLib.TextStyle(fontSize: 10.0))),
                ]),
          ),
          pdfLib.SizedBox(height: 10.0),
          pdfLib.Container(
            margin: pdfLib.EdgeInsets.all(5.0),
            padding: pdfLib.EdgeInsets.all(55.0),
            decoration: pdfLib.BoxDecoration(
                border: pdfLib.Border.all(color: PdfColors.black)),
            child: pdfLib.Column(
                crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                children: [
                  pdfLib.Text("Doc No: " + doc_no.text),
                  pdfLib.Row(
                      mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfLib.Text("Doc Date: " + docdate.toString()),
                        pdfLib.Text("Ref No " + ref_no.text),
                      ]),
                  pdfLib.Row(
                      mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfLib.Text("Customer: " + customer.text),
                        // pdfLib.Text("Sale Tyoe: " + selectedtype),
                      ]),
                  pdfLib.Text("Salesman Name: " + gs_currentUser),

                  pdfLib.SizedBox(height: 20.0),
                  pdfLib.Table.fromTextArray(
                      context: context,
                      border: null,
                      // border: pdfLib.TableBorder.symmetric(
                      //     outside: pdfLib.BorderSide(
                      //         width: 1, style: pdfLib.BorderStyle.solid)),
                      headerStyle:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                      headerDecoration:
                          pdfLib.BoxDecoration(color: PdfColors.grey300),
                      headers: <String>['INVOICE NO', 'INVOICE DATE', 'AMOUNT'],
                      cellAlignment: pdfLib.Alignment.center,
                      data: <List<dynamic>>[
                        // for (int i = 0; i < rec_inv_List.length; i++)
                        //   if (_controller[i].text.isNotEmpty)
                        ...invlist.asMap().keys.toList().map((index) => [
                              invlist[index].val1.toString(),
                              invlist[index].val2.toString(),
                              invlist[index].val3.toString(),
                            ])
                      ]),

                  // pdfLib.SizedBox(height: 10.0),
                  // pdfLib.Container(
                  //   width: double.infinity,
                  // child:
                  //     pdfLib.Column(crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                  //         // mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                  //         children: [
                  //       pdfLib.Text(
                  //         "Total Amount " +
                  //             "AED " +
                  //             getNumberFormat(pdf_tot_amt).toString(),
                  //         style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  //       ),
                  //       pdfLib.Text(
                  //         "Total Balance  " +
                  //             "AED " +
                  //             getNumberFormat(pdf_baltot).toString(),
                  //         style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  //       ),
                  //       pdfLib.Text(
                  //         "Total Orgin Amount " +
                  //             "AED " +
                  //             getNumberFormat(pdf_orgtot).toString(),
                  //         style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  //       ),
                  //       pdfLib.FittedBox(
                  //           child: pdfLib.Row(
                  //               mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                  //               children: [
                  //             pdfLib.Text(
                  //               "Amount(VAT Inclusive) In words : ",
                  //               style: pdfLib.TextStyle(
                  //                 fontWeight: pdfLib.FontWeight.bold,
                  //               ),
                  //             ),
                  //             pdfLib.Text(
                  //               _translatedValue,
                  //               style: pdfLib.TextStyle(
                  //                   fontWeight: pdfLib.FontWeight.bold,
                  //                   fontSize: 9.0),
                  //             ),
                  //           ])),
                  //     ]),
                  // ),

                  // pdfLib.SizedBox(height: 320.0),

                  // pdfLib.Footer()

                  pdfLib.Row(
                      crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                      mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                      children: [
                        pdfLib.SizedBox(height: 180.0),
                        pdfLib.Table.fromTextArray(
                          headerStyle: pdfLib.TextStyle(
                              fontWeight: pdfLib.FontWeight.bold),
                          oddCellStyle: pdfLib.TextStyle(
                              fontWeight: pdfLib.FontWeight.bold),
                          // defaultColumnWidth: 30,
                          cellAlignment: pdfLib.Alignment.centerRight,

                          data: vatdat,
                        ),
                      ]),
                  pdfLib.SizedBox(height: 10.0),
                  pdfLib.Container(
                      width: double.infinity,
                      child: pdfLib.Column(
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                          mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                          children: [
                            pdfLib.Text(
                              _gscurrencycode +
                                  " " +
                                  _translatedValue +
                                  " ONLY",
                              style: pdfLib.TextStyle(
                                  fontWeight: pdfLib.FontWeight.bold,
                                  fontSize: 9.0),
                            ),
                          ])),
                ]),
          ),
        ],
        footer: (context) {
          return pdfLib.Column(
              crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
              children: [
                pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                    children: [
                      pdfLib.Text(
                          "Issued by: " + "Island Valley Electronics L.L.C"),
                      pdfLib.Text("Received By: " + customer.text),
                    ]),
                pdfLib.Text("Salesman name: " + gs_currentUser),
                pdfLib.Text("Today: " + gs_date),
              ]);
        },
      ),
    );
    var path = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    print(path);
    String fileName = "/RECEIPT-" + doc_no.text + ".pdf";
    // if (printed_y.toString() == "Y")
    fileName = "/RECEIPT-" + doc_no.text + "-copy.pdf";
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
    if ((choice == Constants.ViewPdf || choice == Constants.SharePdf) &&
        doc_no.text.isNotEmpty) {
      String _translated = NumberToText().convert(value: tot_amt);
      setState(() {
        _translatedValue = _translated;
      });
      _generatePdfAndView(choice);
    } else {
      alert(context, "Select the DocNo", Colors.red);
    }
  }
}
