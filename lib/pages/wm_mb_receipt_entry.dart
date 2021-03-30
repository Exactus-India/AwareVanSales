import 'package:aware_van_sales/wigdets/alert.dart';

import '../data/future_db.dart';
import '../wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';

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
  bool doc_generate = false;
  bool second_insert = false;
  bool third_insert = false;
  var lcur_amt;
  String remarks;
  double tot_amt = 0;
  double bamt = 0;
  double oamt = 0;
  int serial_no = 1;
  int det_serial_no = 0;
  List recHDR = List();
  List rec_inv_List = List();
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
    rec_inv_Table(widget.ac_code).then((value) {
      setState(() {
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
    super.initState();
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
          SizedBox(width: 40.0)
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
                          if (index == itemCount - 1)
                            DataCell(textBold(" ")),
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
    );
  }

  save() async {
    var count = 0;
    tot_amt = 0.0;
    remarks = customer.text;

    for (int i = 0; i < rec_inv_List.length; i++)
      if (_controller[i].text.isNotEmpty)
        tot_amt += double.parse(_controller[i].text);
    for (int i = 0; i < rec_inv_List.length; i++) {
      count += 1;
      if (count == rec_inv_List.length) second_insert = true;
      if (_controller[i].text.isNotEmpty) {
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
          alert(context, "Datas Inserted", Colors.red);
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
      if (_controller[i].text.isNotEmpty)
        tot_amt += double.parse(_controller[i].text);
  }
}
