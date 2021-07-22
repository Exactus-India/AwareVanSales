import 'dart:async';

import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/REPLACEMENT/wm_mb_replacementList.dart';
import 'package:aware_van_sales/pages/SALES/wm_mb_salesentry.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';

class Replacement extends StatefulWidget {
  final String doc_no;
  final String party_address;
  final String ac_code;
  final String ac_name;
  const Replacement(
      {this.ac_code, this.ac_name, this.doc_no, this.party_address});

  @override
  _ReplacementState createState() => _ReplacementState();
}

class _ReplacementState extends State<Replacement> {
  bool doc_generate = false;
  TextEditingController doc_no = new TextEditingController();
  TextEditingController store_prod = new TextEditingController();
  TextEditingController van_prod = new TextEditingController();
  TextEditingController store_prod_code = new TextEditingController();
  TextEditingController van_prod_code = new TextEditingController();
  TextEditingController amt = new TextEditingController();
  TextEditingController p_qty = new TextEditingController();
  TextEditingController l_qty = new TextEditingController();
  TextEditingController qty = new TextEditingController();
  TextEditingController refno = new TextEditingController();
  TextEditingController remarks = new TextEditingController();

  List storeproduct = List();
  List vanproduct = List();
  List rep_hdr = List();
  List details = List();
  List salesmiddleList = List();
  var list_serial_no;
  bool details_list = false;
  bool delete = false;
  var confirmed = 'N';
  var van_luom;
  var van_puom;
  var van_pqty;
  var van_lqty;
  var van_unitrate;
  var van_qty;
  var van_uppp;
  var van_amt;
  var replacement_type;
  int van_signind;
  var store_luom;
  var store_puom;
  var store_pqty;
  var store_lqty;
  var store_unitrate;
  var store_qty;
  var store_uppp;
  var store_amt;
  int store_signind;
  int signind;
  int serialno;
  bool confirm = false;
  int _pqty;
  int _lqty;
  var _amt;
  var signqty;

  double _tot;
  List saleslog_col = [
    "SNO",
    "PRODUCT",
    "QTY",
    "TOTAL",
    "PROD NAME"
    // "QTY PUOM",
    // "QTY LUOM",
    // "AMOUNT ",
  ];
  int lst_det_sno;
  List replacement_type_drop = ["RETURN", 'ISSUE'];

  //

  @override
  void initState() {
    van_luom = "LUOM";
    van_puom = "PUOM";
    replacement_type = "ISSUE";
    if (widget.doc_no != null) doc_no.text = widget.doc_no;
    mse_product().then((value) {
      setState(() {
        storeproduct.clear();
        storeproduct.addAll(value);
      });
    });
    if (widget.doc_no != null) {
      replacement_hdr_get(doc_no.text, gs_rep_ac_code).then((value) {
        setState(() {
          print("serialno");
          rep_hdr.clear();
          rep_hdr.addAll(value);
          print(rep_hdr.length);
          refno.text = rep_hdr[0]['REF_NO'];
          confirmed = rep_hdr[0]['CONFIRMED'];
          print(refno.text);
        });
      });
      fetch_saleseEntry(widget.doc_no);
    }
    getAllProduct().then((value) {
      setState(() {
        vanproduct.clear();
        vanproduct.addAll(value);
      });
    });

    // getReplacementMaxSerial().then((value) {
    //   if (value == null) lst_det_sno = 1;
    //   if (value != null) lst_det_sno = value + 1;
    // });

    super.initState();
  }

  dropDown_replacement_type() {
    return Padding(
      padding: new EdgeInsets.only(left: 10.0),
      child: new DropdownButton(
        isExpanded: true,
        value: replacement_type,
        onChanged: (newValue) {
          setState(() {
            replacement_type = newValue;
          });
          print(replacement_type);
        },
        items: replacement_type_drop.map((valueItem) {
          return DropdownMenuItem(
            value: valueItem,
            child: Text(valueItem),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Replacement"),
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          // if (saves == false)
          if (confirmed == 'N' && details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    replacement_pro(doc_no.text).then((value) {
                      setState(() {
                        if (value == 1) {
                          confirm = false;
                          confirmed = 'Y';

                          alert(
                              context, 'Confirmed Successfully', Colors.green);
                        }
                      });
                    });
                    // getdatas(_selectedDate, user_selected);
                  });
                },
                child: Text('CONFIRM'),
              ),
            ),
          SizedBox(width: 15.0),
          if (confirmed == 'N' || confirm == true)
            GestureDetector(
              onTap: () async {
                if (doc_no.text.isNotEmpty && p_qty.text.isNotEmpty) {
                  save();
                } else {
                  alert(context, "DocNo and Qty is required", Colors.red);
                }
              },
              child: Icon(
                Icons.save,
                size: 30,
              ),
            ),
          SizedBox(width: 15.0),
          // if (editing == true && newEntry == false)
          if (confirmed == 'N' || confirm == true)
            GestureDetector(
                onTap: () {
                  if ((van_prod.text != null || store_prod.text != null) &&
                      details_list == true)
                    replacementDetDelete(list_serial_no, doc_no.text)
                        .then((value) {
                      setState(() {
                        delete = value;
                        if (delete == true) {
                          fetch_saleseEntry(doc_no.text);
                          showToast('Deleted Succesfully');
                          print(serialno.toString() + " new after delete");
                          clearFields();
                        } else {
                          showToast('Deletion Failed');
                        }
                      });
                    });
                },
                child: Icon(Icons.delete)),

          SizedBox(width: 15.0),
          // PopupMenuButton<String>(
          //   onSelected: choiceAction,
          //   itemBuilder: (BuildContext context) {
          //     return Constants.choices.map((String choice) {
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),
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
                if (details_list != false) list(),
                // listing(rec_inv_List.length + 1, rec_inv_List, datacolumn),

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

  clearFields() {
    van_prod.clear();
    store_prod.clear();
    van_prod_code.clear();
    store_prod_code.clear();
    p_qty.clear();
  }

  head() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(
          children: [
            Flexible(
                flex: 4,
                child:
                    textField1("DOC NO", doc_no, false, true, TextAlign.left)),
            if (doc_generate != true) SizedBox(width: 4.0),
            if (doc_generate == false && doc_no.text.isEmpty)
              Flexible(
                  child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: generate_docno())),
          ],
        ),
        SizedBox(
          height: 4.0,
        ),
        Row(children: [
          Flexible(
            flex: 4,
            child: textField1("REF NO", refno, false, false, TextAlign.left),
          ),
          Flexible(
            flex: 4,
            child: dropDown_replacement_type(),
          ),
        ]),
        SizedBox(
          height: 4.0,
        ),
        if (replacement_type == "RETURN")
          Row(
            children: [
              Flexible(
                  flex: 4,
                  child: textField1("Product Code", store_prod_code, false,
                      true, TextAlign.left)),
              SizedBox(width: 4.0),
              if (doc_generate != true) SizedBox(width: 4.0),
              Flexible(
                  child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                store_Product()).then((value) {
                          setState(() {
                            store_prod.clear();
                            store_prod_code.clear();
                            print("prodcode");
                            store_prod.text = gs_prod_name.toString();
                            store_prod_code.text = gs_prod_code;
                            store_puom = gs_puom;
                            store_luom = gs_luom;
                            store_uppp = gs_uppp;
                            store_amt = gs_cost_rate;
                            store_signind = 1;
                            gs_rate != null
                                ? store_unitrate = gs_cost_rate
                                : store_unitrate = 0;
                          });
                        });
                      })),
            ],
          ),
        SizedBox(
          height: 4.0,
        ),
        if (replacement_type == "RETURN")
          textField1("Return Product", store_prod, false, true, TextAlign.left),
        SizedBox(
          height: 4.0,
        ),
        if (replacement_type == "ISSUE")
          Row(
            children: [
              Flexible(
                  flex: 4,
                  child: textField1("Product Code", van_prod_code, false, true,
                      TextAlign.left)),
              SizedBox(width: 4.0),
              if (doc_generate == true) SizedBox(width: 4.0),
              Flexible(
                  child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                van_Product()).then((value) {
                          setState(() {
                            van_prod.clear();
                            van_prod_code.clear();
                            print("prodcode");
                            van_prod.text = gs_prod_name.toString();
                            van_prod_code.text = gs_prod_code;
                            van_puom = gs_puom;
                            van_luom = gs_luom;

                            van_uppp = gs_uppp;
                            // van_pqty = gs_stk_puom;

                            van_amt = gs_cost_rate;
                            van_signind = -1;
                            gs_rate != null
                                ? van_unitrate = 100
                                : van_unitrate = 0;
                          });
                          // }
                          // });
                        });
                      })),
            ],
          ),
        SizedBox(height: 4.0),
        if (replacement_type == "ISSUE")
          textField1(
              "Replacement Products", van_prod, false, true, TextAlign.left),
        SizedBox(
          height: 4.0,
        ),
        textField1("Remarks", remarks, false, false, TextAlign.left),
        SizedBox(
          height: 4.0,
        ),
        Row(children: <Widget>[
          Flexible(child: textData(van_puom.toString(), Colors.purple, 13.0)),
          SizedBox(width: 10.0),
          Flexible(
              flex: 1,
              child:
                  textField1("QTY PUOM", p_qty, false, false, TextAlign.right)),
          if (van_puom.toString() != van_luom.toString()) SizedBox(width: 15.0),
          if (van_puom.toString() == van_luom.toString()) SizedBox(width: 60.0),
          if (van_puom.toString() != van_luom.toString())
            Flexible(child: textData(van_luom.toString(), Colors.purple, 13.0)),
          SizedBox(width: 10.0),
          if (van_puom.toString() != van_luom.toString())
            Flexible(
                flex: 1,
                child: textField1(
                    "QTY LUOM", l_qty, false, false, TextAlign.left)),
        ]),
      ]),
    );
  }

  save() {
    replacement_hdr_get(doc_no.text, gs_rep_ac_code).then((value) {
      setState(() {
        print("serialno");
        rep_hdr.clear();
        rep_hdr.addAll(value);
        print(rep_hdr.length);
        lst_det_sno = rep_hdr[0]['LAST_DTL_SERIAL_NO'];
        print(lst_det_sno);
        print("///////////////////////////////////////////////");
        lst_det_sno == 0 ? serialno = 1 : serialno = lst_det_sno + 1;
        print(serialno);
        print("serialno");
      });
    }).then((value) {
      if (replacement_type == 'RETURN')
        replacement_DET(
          doc_no.text,
          remarks.text,
          store_prod_code.text,
          store_prod.text,
          store_puom,
          p_qty.text,
          store_luom,
          0,
          store_uppp,
          p_qty.text,
          store_amt,
          store_amt,
          1,
          serialno,
        ).then((value) {
          if (value == 1) {
            setState(() {
              print("DET Success");
              // showToast('Saved Successfully');
              alert(context, 'Saved Successfully', Colors.green);
              clearFields();
              confirm = true;
              fetch_saleseEntry(doc_no.text);
              replacement_hdr_update(
                      doc_no.text, refno.text, remarks.text, serialno)
                  .then((value) {
                if (value == 1) {
                  print(serialno);
                  print("**************");
                }
              });
            });
          } else {
            alert(context, value, Colors.red);
          }
        });
      replacement_hdr_get(doc_no.text, gs_rep_ac_code).then((value) {
        setState(() {
          print("serialno");
          rep_hdr.clear();
          rep_hdr.addAll(value);
          print(rep_hdr.length);
          lst_det_sno = rep_hdr[0]['LAST_DTL_SERIAL_NO'];
          print(lst_det_sno);
          lst_det_sno == 0 ? serialno = 1 : serialno = lst_det_sno + 1;
          print(serialno);
          print("serialno");
        });
      }).then((value) {
        if (replacement_type == 'ISSUE')
          replacement_DET(
            doc_no.text,
            remarks.text,
            van_prod_code.text,
            van_prod.text,
            van_puom,
            p_qty.text,
            van_luom,
            0,
            van_uppp,
            p_qty.text,
            van_amt,
            van_amt,
            -1,
            serialno,
          ).then((value) {
            if (value == 1) {
              fetch_saleseEntry(doc_no.text);
              replacement_hdr_update(
                      doc_no.text, refno.text, remarks.text, serialno)
                  .then((value) {
                if (value == 1) {
                  print(serialno);
                  print("*******************");
                }
              });
              setState(() {
                print("DET Success");
                // showToast('Saved Successfully');
                alert(context, 'Saved Successfully', Colors.green);
                clearFields();
                confirm = true;
              });
            } else {
              alert(context, value, Colors.red);
            }
          });
      });
    });
    // clearFields();
    details_list = true;
  }

  store_Product() {
    return AlertDialog(
      content: Container(
        height: 400.0,
        width: 300.0,
        child: ListBuilderCommon(
            datas: storeproduct, toPage: null, head: false, popBack: true),
      ),
    );
  }

  van_Product() {
    return AlertDialog(
      content: Container(
        height: 400.0,
        width: 300.0,
        child: ListBuilderCommon(
            datas: vanproduct, toPage: null, head: false, popBack: true),
      ),
    );
  }

  generate_docno() {
    return GestureDetector(
        onTap: () {
          getReplacementMax().then((value) {
            setState(() {
              if (value == null)
                doc_no.text = newDocNo();
              else {
                var docno = value.toInt() + 1;
                doc_no.text = docno.toString();
                print(docno.toString() + " notnull");
              }

              print(doc_no.text);
            });
          }).then((value) {
            replacement_hdr_get(doc_no.text, gs_rep_ac_code).then((value) {
              setState(() {
                rep_hdr.clear();
                rep_hdr.addAll(value);
                lst_det_sno = rep_hdr[0]['LAST_DTL_SERIAL_NO'];
                lst_det_sno == 0 ? serialno = 1 : serialno = lst_det_sno + 1;
                print(serialno);
                print("serialno");
              });
            });
          }).then((value) {
            if (refno.text.isEmpty) refno.text = doc_no.text;
            print(gs_rep_ac_code);
            Replacement_HDR(
                    refno.text, doc_no.text, remarks.text, 0, gs_rep_ac_code)
                .then((value) {
              if (value == 1) {
                confirmed = 'N';
                print("HDR Success");
                doc_generate = true;
                print(doc_no.text);
              } else {
                alert(context, value, Colors.red);
              }
            });
          });
        },
        child: Icon(Icons.build));
  }

  fetch_saleseEntry(param1) {
    return replacement_det_get(param1).then((value) {
      setState(() {
        details.clear();
        details.addAll(value);
        _pqty = 0;
        _lqty = 0;
        _amt = 0;

        _tot = 0;
        if (details.isNotEmpty) {
          print("in details");
          details_list = true;
          list_length = 0;
          list_length = details.length;

          for (int i = 0; i < details.length; i++) {
            _pqty += details[i].val5;
            // signqty = int.parse(details[i].val5) * int.parse(details[i].val10);

            _lqty += details[i].val7;
            _amt += details[i].val8.toDouble();

            _tot += details[i].val10.toDouble();
          }
        }

        print(_tot.toString() + 'total');
      });
    });
  }

  list() {
    print(saleslog_col.length.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: dataTable(details.length, details, saleslog_col),
    );
  }

  dataTable(numItems, rowList, column) {
    return CustomDataTable(
        headerColor: Colors.green[200],
        rowColor1: Colors.grey.shade300,
        dataTable: DataTable(
          headingRowHeight: 35.0,
          dataRowHeight: 35,
          columnSpacing: 15,
          showCheckboxColumn: false,
          columns: [
            for (int i = 0; i <= column.length - 1; i++)
              DataColumn(
                label: text(column[i], Colors.black),
              ),
          ],
          rows: List<DataRow>.generate(
            numItems,
            (index) => DataRow(
              onSelectChanged: (va) {
                setState(() {
                  String sno = rowList[index].val1.toString();
                  selectListItem(sno);
                });
                print(index.toString() + "........");
                print((numItems).toString() + "........");
              },
              cells: <DataCell>[
                //sno
                // if (index != numItems - 1)
                DataCell(Text(rowList[index].val1.toString())),
                // if (index == numItems - 1) DataCell(textBold("TOTAL")),
                //product code
                // if (index != numItems - 1)
                DataCell(Text(rowList[index].val2.toString())),
                // if (index == numItems - 1) DataCell(Text("")),
                //qty
                // if (index != numItems - 1)
                DataCell(Text(rowList[index].val5.toString())),
                // if (index == numItems - 1) DataCell(textBold(_pqty.toString())),
                //total
                // if (index != numItems - 1)
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        getNumberFormat(rowList[index].val10).toString()))),
                // if (index == numItems - 1)
                // DataCell(textBold(getNumberFormat(_tot).toString())),
                // DataCell(textBold("")),
                //prod name
                // if (index != numItems - 1)
                DataCell(Text(rowList[index].val3.toString())),
                // if (index == numItems - 1) DataCell(Text("")),
                //qtypuom

                // if (index != numItems - 1)
                //   DataCell(Text(rowList[index].val5.toString() +
                //       " " +
                //       rowList[index].val4.toString())),
                // if (index == numItems - 1) DataCell(textBold(_pqty.toString())),
                // //qty_luom
                // if (index != numItems - 1)
                //   DataCell(Text(rowList[index].val7.toString() +
                //       " " +
                //       rowList[index].val6.toString())),
                // if (index == numItems - 1) DataCell(textBold(_lqty.toString())),
                //amt
                // if (index != numItems - 1)
                //   DataCell(Align(
                //       alignment: Alignment.centerRight,
                //       child: Text((rowList[index].val8).toString()))),
                // if (index == numItems - 1)
                //   DataCell(textBold((_amt).toString())),
              ],
            ),
          ),
        ));
  }

  selectListItem(serialno) {
    replacement_prod(doc_no.text, serialno).then((value) {
      setState(() {
        new Timer(const Duration(milliseconds: 300), () {
          // _puom = "";
          // _luom = "";
          setState(() {
            salesmiddleList.clear();
            salesmiddleList.addAll(value);
            // print(prod_update);
            clearFields();
            print(salesmiddleList.length.toString() + 'list Size');
            list_serial_no = serialno;
            van_prod_code.text = salesmiddleList[0].product_code.toString();
            store_prod_code.text = salesmiddleList[0].product_code.toString();
            store_prod.text = salesmiddleList[0].product_name.toString();
            van_prod.text = salesmiddleList[0].product_name.toString();
            p_qty.text = salesmiddleList[0].qty_puom.toString();
            // luom.text = salesmiddleList[0].qty_luom.toString();
            // rate.text = salesmiddleList[0].unit_price.toString();
            // amt.text = getNumberFormat(salesmiddleList[0].amount).toString();
            // vat.text = getNumberFormat(salesmiddleList[0].vat).toString();
            // _puom = salesmiddleList[0].puom.toString();
            // _luom = salesmiddleList[0].luom.toString();
            // uppp = salesmiddleList[0].uppp;
            // net_amt.text = getNumberFormat(
            // salesmiddleList[0].amount + salesmiddleList[0].vat)
            // .toString();
            qty.text = salesmiddleList[0].tot_qty.toString();
            // bal_stk.text = salesmiddleList[0].tot_qty.toString() +
            //     ' ' +
            //     salesmiddleList[0].puom.toString();
            print(list_serial_no.toString() + "*");
          });
        });
      });
    });
  }
}
