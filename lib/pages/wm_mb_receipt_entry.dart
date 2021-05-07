import 'dart:io';

import 'package:aware_van_sales/components/number_to_text.dart';
import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/wigdets/alert.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:ext_storage/ext_storage.dart';

class ReceiptEntry extends StatefulWidget {
  final ac_name;
  final outbal;
  final ac_code;

  const ReceiptEntry({
    Key key,
    this.ac_code,
    this.outbal,
    this.ac_name,
  }) : super(key: key);
  @override
  _ReceiptEntryState createState() => _ReceiptEntryState();
}

class _ReceiptEntryState extends State<ReceiptEntry> {
  TextEditingController customer = new TextEditingController();
  TextEditingController doc_no = new TextEditingController();
  TextEditingController ref_no = new TextEditingController();
  String _translatedValue = '';
  bool doc_generate = false;
  bool second_insert = false;
  bool third_insert = false;
  var lcur_amt;
  var docdate;
  var pdf_baltot;
  var pdf_orgtot;
  var pdf_amt;
  String remarks;
  double bamt = 0;
  double oamt = 0;
  double tot_amt = 0;
  double pdf_tot_amt = 0;
  int serial_no = 1;
  int det_serial_no = 0;
  List recHDR = List();
  List rec_inv_List = List();
  List pdf_List = List();
  List datacolumn = ["INV. NO", "INV. DATE", "AMT", "BAL AMT", "ORG AMT"];
  List<TextEditingController> _controller;
  @override
  void initState() {
    customer.text = widget.ac_name;
    // customer.text = widget.outbal;
    // receipt_HDR(docno).then((value) {
    //   recHDR.clear();
    //   recHDR.addAll(value);
    // });
    inv_List(widget.ac_code);
    super.initState();
  }

  inv_List(ac_code) {
    tot_amt = 0;
    bamt = 0;
    oamt = 0;
    return rec_inv_Table(ac_code).then((value) {
      setState(() {
        rec_inv_List.clear();
        rec_inv_List.addAll(value);
        print(rec_inv_List.length);
        _controller = [
          for (int i = 0; i < rec_inv_List.length; i++) TextEditingController()
        ];
        for (int i = 0; i < rec_inv_List.length; i++) {
          bamt += rec_inv_List[i].val5;
          oamt += rec_inv_List[i].val6;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipt Entry"),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              if (doc_no.text.isNotEmpty) {
                save();
              } else {
                alert(context, "Doc no is Empty", Colors.red);
              }
            },
            child: Icon(Icons.save),
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
                listing(rec_inv_List.length + 1, rec_inv_List, datacolumn),
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
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: generate_docno())),
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

  generate_docno() {
    return GestureDetector(
        onTap: () {
          getRecDocno().then((value) {
            setState(() {
              if (value == null)
                doc_no.text = newDocNo();
              else {
                var docno = value.toInt() + 1;
                doc_no.text = docno.toString();
                print(docno.toString() + " notnull");
              }
              doc_generate = true;
              if (ref_no.text.isEmpty) {
                ref_no.text = doc_no.text;
              }

              print(doc_no.text);
            });
          });
        },
        child: Icon(Icons.build));
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
                              DataCell(Text(rowList[index].val2.toString(),
                                  style: TextStyle(fontSize: 12))),
                            if (index == itemCount - 1)
                              DataCell(textBold("TOTAL")),
                            //inv date
                            if (index != itemCount - 1)
                              DataCell(Text(rowList[index].val3.toString(),
                                  style: TextStyle(fontSize: 12))),
                            if (index == itemCount - 1) DataCell(textBold(" ")),
                            // amt
                            if (index != itemCount - 1)
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: textField_data(
                                      "00.00",
                                      _controller[index],
                                      TextAlign.right,
                                      rowList[index].val5))),
                            if (index == itemCount - 1)
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: textBold(
                                      getNumberFormat(tot_amt).toString()))),
                            //balance amount
                            if (index != itemCount - 1)
                              DataCell(
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          getNumberFormat(rowList[index].val5),
                                          style: TextStyle(fontSize: 12))),
                                  onTap: () {
                                setState(() {
                                  _controller[index].text =
                                      rowList[index].val5.toString();
                                  calculate(_controller[index].text,
                                      rowList[index].val5);
                                });
                                print(_controller[index].text);
                                print("done");
                              }),
                            if (index == itemCount - 1)
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: textBold(
                                      getNumberFormat(bamt).toString()))),
                            //origin amt
                            if (index != itemCount - 1)
                              DataCell(
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    getNumberFormat(rowList[index].val6),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            if (index == itemCount - 1)
                              DataCell(Align(
                                  alignment: Alignment.centerRight,
                                  child: textBold(
                                      getNumberFormat(oamt).toString()))),
                          ],
                        )))),
      ),
    );
  }

  save() async {
    var count = 0;
    tot_amt = 0.0;
    remarks = customer.text;
    pdf_baltot = 0;
    pdf_orgtot = 0;

    for (int i = 0; i < rec_inv_List.length; i++)
      if (_controller[i].text.isNotEmpty) {
        tot_amt += double.parse(_controller[i].text);
      }
    for (int i = 0; i < rec_inv_List.length; i++) {
      count += 1;
      if (count == rec_inv_List.length) second_insert = true;
      if (_controller[i].text.isNotEmpty) {
        pdf_List.add(rec_inv_List[i]);
        pdf_List[i].val4 = double.parse(_controller[i].text);
        pdf_tot_amt += pdf_List[i].val4.toDouble();
        pdf_baltot +=
            (rec_inv_List[i].val5.toDouble() - pdf_List[i].val4.toDouble());
        pdf_orgtot += rec_inv_List[i].val6;
        print('pdf_List.length');
        print(pdf_List.length);
        // for (int i = 0; i < pdf_List.length; i++) {
        // }
        remarks = " " + rec_inv_List[i].val2.toString();
        det_serial_no += 1;
        print(det_serial_no);
        print("det_serial_no");
        print(_controller[i].text);
        var amount = double.parse(_controller[i].text);
        // var loc_amt = amount * gl_EX_rate;
        lcur_amt = amount * gl_EX_rate;
        var resp = await rec_inv_det_insert(
            doc_no.text,
            serial_no,
            det_serial_no,
            widget.ac_code,
            rec_inv_List[i].val2,
            _controller[i].text,
            lcur_amt,
            -1);
        if (resp == 1) print("inserted ac_inv_detail");
        if (resp != 1) alert(context, "ERROR", Colors.red);
      }
    }
    if (second_insert == true) {
      lcur_amt = 0;
      // var loc_amt = tot_amt * gl_EX_rate;
      lcur_amt = (tot_amt * gl_EX_rate);
      await rec_docno_insert(
              doc_no.text, remarks, tot_amt, lcur_amt, 1, widget.ac_code, -1)
          .then((value) async {
        if (value == 1) {
          print("inserted ac_detail 2");
          // showToast("Inserted 1");
          await rec_docno_insert(
                  doc_no.text, remarks, tot_amt, lcur_amt, 9001, gl_ac_cash, 1)
              .then((value) {
            if (value == 1) {
              docdate = gs_date;
              second_insert = false;
              third_insert = true;
              print("inserted ac_detail 2");
              // showToast("Inserted 2");
            } else {
              showToast(value.toString());
            }
          });
        } else {
          showToast(value.toString());
        }
      });
    }
    if (third_insert == true)
      await rec_ac_hdr_insert(doc_no.text, remarks, ref_no.text, "ac_payee",
              gl_ac_cash, det_serial_no)
          .then((value) {
        if (value == 1) {
          second_insert = false;
          third_insert = false;
          // showToast("Inserted 2");
          inv_List(widget.ac_code);
          alert(context, "Datas Inserted", Colors.green);
        } else {
          showToast(value.toString());
        }
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
                  pdfLib.Text("INVOICE "),
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
              ]),
          pdfLib.SizedBox(height: 20.0),
          pdfLib.Table.fromTextArray(context: context, headers: <String>[
            'INVOICE NO',
            'INVOICE DATE',
            'AMOUNT',
            'BALANCE AMOUNT',
            'ORGIN AMOUNT'
          ], data: <List<dynamic>>[
            // for (int i = 0; i < rec_inv_List.length; i++)
            //   if (_controller[i].text.isNotEmpty)
            ...pdf_List.asMap().keys.toList().map((index) => [
                  pdf_List[index].val2.toString(),
                  pdf_List[index].val3.toString(),
                  pdf_List[index].val4.toString(),
                  (pdf_List[index].val5.toDouble() -
                          pdf_List[index].val4.toDouble())
                      .toString(),
                  getNumberFormat(pdf_List[index].val6).toString(),
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
                    "Total Amount " + getNumberFormat(pdf_tot_amt).toString(),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text(
                    "Total Balance  " + getNumberFormat(pdf_baltot).toString(),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text(
                    "Total Orgin Amount " +
                        getNumberFormat(pdf_orgtot).toString(),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.FittedBox(
                      child: pdfLib.Row(
                          mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                          children: [
                        pdfLib.Text(
                          "Amount(VAT Inclusive) In words : ",
                          style: pdfLib.TextStyle(
                            fontWeight: pdfLib.FontWeight.bold,
                          ),
                        ),
                        pdfLib.Text(
                          _translatedValue,
                          style: pdfLib.TextStyle(
                              fontWeight: pdfLib.FontWeight.bold,
                              fontSize: 9.0),
                        ),
                      ])),
                ]),
          ),

          // pdfLib.SizedBox(height: 320.0),

          // pdfLib.Footer()
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
                      pdfLib.Text("Received By: " + widget.ac_name),
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
    String fileName = "/SALES-" + doc_no.text + ".pdf";
    // if (printed_y.toString() == "Y")
    fileName = "/SALES-" + doc_no.text + "-copy.pdf";
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
      String _translated =
          NumberToText().convert(value: double.parse(pdf_orgtot.toString()));
      setState(() {
        _translatedValue = _translated;
      });
      _generatePdfAndView(choice);
    } else {
      String _translated =
          NumberToText().convert(value: double.parse(pdf_orgtot.toString()));
      setState(() {
        _translatedValue = _translated;
      });
      _generatePdfAndView(choice);
    }
  }
}
