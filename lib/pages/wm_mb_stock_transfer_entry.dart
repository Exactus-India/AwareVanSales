import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';

class StocktransferEntry extends StatefulWidget {
  final doc_no;

  const StocktransferEntry({Key key, this.doc_no}) : super(key: key);
  @override
  _StocktransferEntryState createState() => _StocktransferEntryState();
}

class _StocktransferEntryState extends State<StocktransferEntry> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController doc_no = TextEditingController();
  final TextEditingController zone_from = TextEditingController();
  final TextEditingController zone_to = TextEditingController();
  final TextEditingController remarks = TextEditingController();
  final TextEditingController prod_code = TextEditingController();
  final TextEditingController prod_name = TextEditingController();
  final TextEditingController puom = TextEditingController();
  final TextEditingController luom = TextEditingController();
  final TextEditingController qty_puom = TextEditingController();
  final TextEditingController qty_luom = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController bal_stock = TextEditingController();
  List strHDR = List();
  List st_detailList = List();
  List salesmiddle = List();
  List productList = List();
  List zone_list = List();
  List zonefrom_list = List();
  String selectedZonefrom = null;
  String selectedZoneto = null;
  bool doc_generate = false;
  bool middle_view = false;
  bool prod_update = false;
  bool editing = true;
  var uppp;
  var avl_qty;
  var cost_rate;
  var tx_id_no;
  var doc_date;
  var list_serial_no;
  var serial_no;
  var det_serial_no = 0;
  List column = [
    "SNO",
    "PROD CODE",
    "PROD NAME",
    "QTY PUOM",
    "QTY LUOM",
  ];

  @override
  void initState() {
    puom.text = "PUOM";
    luom.text = "LUOM";

    get_ST_zone().then((value) {
      setState(() {
        zone_list.addAll(value);
        if (widget.doc_no == null) {
          serial_no = 1;
        } else if (widget.doc_no != null) {
          doc_no.text = widget.doc_no;
          getHDR(widget.doc_no);
        }
      });
    });
    super.initState();
  }

  getHDR(docno) {
    return str_HDR(docno).then((value) {
      strHDR.clear();
      strHDR.addAll(value);
      setState(() {
        doc_generate = true;
        middle_view = true;
        doc_no.text = strHDR[0]['DOC_NO'].toString();
        selectedZonefrom = strHDR[0]['FROM_ZONE_CODE'].toString();
        selectedZoneto = strHDR[0]['TO_ZONE_CODE'].toString();
        if (strHDR[0]['REMARKS'] != null)
          remarks.text = strHDR[0]['REMARKS'].toString();
        var sn_no = strHDR[0]['LAST_DTL_SERIAL_NO'];
        if (sn_no == null || sn_no == 0) sn_no = 0;
        serial_no = sn_no + 1;
        var date = strHDR[0]['DOC_DATE'];
        doc_date = date.toString().split('T')[0];
        var confirm = strHDR[0]['CONFIRMED'];
        if (confirm == "Y") editing = false;
        det_serial_no = sn_no;
        fetch_EntryDetails(doc_no.text);
      });
    });
  }

  fetch_EntryDetails(docno) {
    return stocktransferDetailList(docno).then((value) {
      setState(() {
        st_detailList.clear();
        st_detailList.addAll(value);
        print(st_detailList.length);
      });
    });
  }

  dropDown_zone_to() {
    return DropdownButton(
        isExpanded: true,
        value: selectedZoneto,
        hint: Text('zone to'),
        items: zone_list.map((list) {
          return DropdownMenuItem(
              child: Text(list['ZONE_NAME']),
              value: list['ZONE_CODE'].toString());
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedZoneto = value;
          });
          print(selectedZoneto);
        });
  }

  dropDown_zone_from() {
    return DropdownButton(
        isExpanded: true,
        value: selectedZonefrom,
        hint: Text('zone from '),
        items: zone_list.map((list) {
          return DropdownMenuItem(
              child: Text(list['ZONE_NAME']),
              value: list['ZONE_CODE'].toString());
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedZonefrom = value;
          });
          print(selectedZonefrom);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Stock Transfer Entry",
              style: TextStyle(color: Colors.white)),
          elevation: .1,
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
          actions: <Widget>[
            if (editing == true)
              GestureDetector(
                  onTap: () {
                    setState(() {
                      if (doc_no.text.isNotEmpty) {
                        if (quantity.text.isEmpty) updateHdr(det_serial_no);
                        if (prod_name.text != null && quantity.text.isNotEmpty)
                          prod_update == false
                              ? productInsert()
                              : productupdation();

                        print('serial_no' + serial_no.toString());
                      }
                    });
                  },
                  child: Icon(Icons.save)),
            SizedBox(width: 20.0),
            if (editing == true)
              GestureDetector(
                  onTap: () {
                    setState(() {
                      prod_update = false;
                      clearFields();
                      middle_view = true;
                      print(serial_no.toString() + "in new");
                      gs_list_index = null;
                    });
                  },
                  child: Icon(Icons.add)),
            SizedBox(width: 20.0),
            if (editing == true)
              GestureDetector(
                  onTap: () {
                    if (prod_name.text != null)
                      st_prod_Delete(list_serial_no, doc_no.text).then((value) {
                        setState(() {
                          if (value == true) {
                            fetch_EntryDetails(doc_no.text);
                            showToast('Deleted Succesfully');
                            print(serial_no.toString() + " new after delete");
                            clearFields();
                          } else {
                            showToast('Deletion Failed');
                          }
                        });
                      });
                  },
                  child: Icon(Icons.delete)),
            SizedBox(width: 20.0),
          ]),
      body: new Padding(
        padding: new EdgeInsets.only(top: 14.0),
        child: new Form(
            key: _formkey,
            child: new SingleChildScrollView(
              child: Column(
                children: [
                  head(),
                  SizedBox(height: 5),
                  if (middle_view == true) middle(),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: listing(st_detailList.length, st_detailList, column),
                  )
                ],
              ),
            )),
      ),
    );
  }

  head() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 2,
                  child:
                      textField("Doc No", doc_no, false, true, TextAlign.left)),
              if (doc_generate != true) SizedBox(width: 4.0),
              if (doc_generate != true)
                Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: generate_ST_docno())),
              if (doc_generate == true)
                SizedBox(
                  width: 10.0,
                ),
              if (doc_generate == true)
                Flexible(
                    flex: 1,
                    child: RaisedButton(
                        onPressed: () {
                          st_pro(doc_no.text).then((value) {
                            if (value == true) {
                              editing = false;
                              showToast('Confirmed Succesfully');
                            }
                            if (value != true) showToast('Failed');
                          });
                        },
                        color: Colors.green,
                        child: Text(
                          "CONFIRM",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))),
            ],
          ),
          SizedBox(height: 4),
          dropDown_zone_from(),
          dropDown_zone_to(),
          SizedBox(height: 4),
          textField("REMARKS", remarks, false, false, TextAlign.left),
        ],
      ),
    );
  }

  middle() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          product_row("ProductCode", prod_code),
          textField("ProductName", prod_name, prod_code == null ? true : false,
              false, TextAlign.left),
          Row(children: <Widget>[
            Flexible(child: textData(puom.text, Colors.purple, 13.0)),
            SizedBox(width: 10.0),
            Flexible(
                flex: 1,
                child: textField(
                    "QTY PUOM", qty_puom, false, false, TextAlign.end)),
            if (puom.text != luom.text) SizedBox(width: 15.0),
            if (puom.text == luom.text) SizedBox(width: 60.0),
            if (puom.text != luom.text)
              Flexible(child: textData(luom.text, Colors.purple, 13.0)),
            SizedBox(width: 10.0),
            if (puom.text != luom.text)
              Flexible(
                  flex: 1,
                  child: textField(
                      "QTY LUOM", qty_luom, false, false, TextAlign.end)),
          ]),
          Row(
            children: [
              Flexible(
                  child: textField("Quantity", quantity,
                      quantity == null ? true : false, true, TextAlign.end)),
              SizedBox(width: 10),
              Flexible(child: labelWidget(Colors.red[500], bal_stock, 13.0)),
            ],
          )
        ],
      ),
    );
  }

  product_row(_text, _controller) {
    return Row(
      children: <Widget>[
        Flexible(
            flex: 3,
            child: textField(_text, _controller, false, true, TextAlign.left)),
        Flexible(
            child: SizedBox(
                height: 30,
                child: IconButton(
                  padding: EdgeInsets.only(left: 30.0),
                  iconSize: 25.0,
                  alignment: Alignment.center,
                  onPressed: () {
                    showDialog(
                            context: context,
                            builder: (BuildContext context) => prodlist())
                        .then((value) {
                      setState(() {
                        if (gs_list_index != null) {
                          prod_update = false;
                          print(serial_no.toString() + "in new");
                          print(prod_update);
                          productClick();
                        }
                      });
                    });
                  },
                  icon: Icon(Icons.search, color: Colors.green),
                )))
      ],
    );
  }

  prodlist() {
    // list_length = productList.length;
    getAllSTRProduct(selectedZonefrom).then((value) {
      setState(() {
        print("selected zone" + selectedZonefrom);
        productList.clear();
        productList.addAll(value);
      });
    });

    return AlertDialog(
        title: Text('Products'),
        content: Container(
            height: 400.0,
            width: 300.0,
            child: ListBuilderCommon(
                datas: productList, head: false, toPage: null, popBack: true)));
  }

  listing(itemCount, rowList, column) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: CustomDataTable(
          headerColor: Colors.green[200],
          rowColor1: Colors.grey.shade300,
          dataTable: DataTable(
              headingRowHeight: 35.0,
              dataRowHeight: 35,
              columnSpacing: 15.0,
              showCheckboxColumn: false,
              columns: [
                for (int i = 0; i <= column.length - 1; i++)
                  DataColumn(label: text(column[i], Colors.black))
              ],
              rows: List<DataRow>.generate(
                  itemCount,
                  (index) => DataRow(
                        onSelectChanged: (va) {
                          if (va) {
                            setState(() {
                              if (middle_view == false) middle_view = true;
                              prod_update = true;
                              print(prod_update);
                              String sno = rowList[index].val1.toString();
                              selectListItem(sno);
                            });
                            print(index.toString() + "........");
                            print((itemCount).toString() + "........");
                          }
                        },
                        cells: <DataCell>[
                          DataCell(Text(rowList[index].val1.toString(),
                              style: TextStyle(fontSize: 11))),
                          DataCell(Text(rowList[index].val2.toString(),
                              style: TextStyle(fontSize: 11))),
                          DataCell(Text(rowList[index].val3.toString(),
                              style: TextStyle(fontSize: 11))),
                          DataCell(Text(
                              rowList[index].val5.toString() +
                                  " " +
                                  rowList[index].val4.toString(),
                              style: TextStyle(fontSize: 11))),
                          DataCell(Text(
                              rowList[index].val7.toString() +
                                  " " +
                                  rowList[index].val6.toString(),
                              style: TextStyle(fontSize: 11))),
                        ],
                      )))),
    );
  }

  selectListItem(serialno) {
    st_middle_view(doc_no.text, serialno).then((value) {
      setState(() {
        new Timer(const Duration(milliseconds: 300), () {
          setState(() {
            salesmiddle.clear();
            salesmiddle.addAll(value);
            print(prod_update);
            clearFields();
            print(salesmiddle.length.toString() + 'list Size');
            list_serial_no = serialno;
            prod_code.text = salesmiddle[0].product_code.toString();
            prod_name.text = salesmiddle[0].product_name.toString();
            qty_puom.text = salesmiddle[0].qty_puom.toString();
            qty_luom.text = salesmiddle[0].qty_luom.toString();
            puom.text = salesmiddle[0].puom.toString();
            luom.text = salesmiddle[0].luom.toString();
            uppp = salesmiddle[0].uppp;
            print(list_serial_no.toString() + "*");
          });
        });
      });
    });
  }

  textField(_text, _controller, _validate, read, align) {
    return Container(
      height: 40.0,
      child: TextField(
        textAlign: align,
        readOnly: read,
        onChanged: (value) {
          setState(() {
            if (_text == 'QTY PUOM') {
              print("in....");
              if (prod_update == true) productCalculate();
              if (prod_update == false) {
                if (avl_qty.toInt() >= int.parse(qty_puom.text)) {
                  productCalculate();
                } else {
                  print("else");
                  alert(
                      this.context,
                      "Available Quantity " + avl_qty.toString(),
                      Colors.orange);
                  qty_puom.clear();
                }
              }
            }
          });
        },
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
            labelText: _text,
            border: const OutlineInputBorder(),
            contentPadding: EdgeInsets.all(10),
            errorText: _validate ? 'Value Can\'t Be Empty' : null,
            focusColor: Colors.blue,
            labelStyle: TextStyle(color: Colors.black54)),
        controller: _controller,
      ),
    );
  }

  productClick() {
    prod_code.text = productList[gs_list_index].val2;
    prod_name.text = productList[gs_list_index].val1;
    puom.text = productList[gs_list_index].puom.toString();
    luom.text = productList[gs_list_index].luom.toString();
    cost_rate = productList[gs_list_index].cost_rate.toString();
    var a = productList[gs_list_index].stk_puom;
    var b = productList[gs_list_index].stk_luom;
    uppp = productList[gs_list_index].uppp;
    avl_qty = (a + b);
    print(avl_qty);
    print(uppp);
    bal_stock.text = 'Bal: ' + avl_qty.toString() + ' ' + puom.text;
    quantity.clear();
  }

  productCalculate() {
    var puoms;
    var luoms;
    qty_puom.text.isNotEmpty ? puoms = int.parse(qty_puom.text) : puoms = 0;
    qty_luom.text.isNotEmpty ? luoms = int.parse(qty_luom.text) : luoms = 0;
    var _qty = (puoms * uppp) + luoms;
    qty_luom.text = luoms.toString();
    print("..... in calculate");
    print(_qty);
    quantity.text = _qty.toString();
  }

  clearFields() {
    puom.text = "PUOM";
    luom.text = "LUOM";
    prod_code.clear();
    prod_name.clear();
    quantity.clear();
    qty_puom.clear();
    qty_luom.clear();
    bal_stock.clear();
  }

  updateHdr(det_serialno) async {
    if (selectedZonefrom != null && selectedZoneto != null) {
      var resp = await st_HDR_update(doc_no.text, remarks.text,
          selectedZonefrom, selectedZoneto, det_serialno);
      if (resp == 1) {
        setState(() {
          showToast('updated Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.green);
      }
    }
  }

  generate_ST_docno() {
    return GestureDetector(
        onTap: () {
          if (selectedZonefrom != null && selectedZoneto != null)
            getSTDocno().then((value) {
              setState(() {
                print("innn");
                if (value == null) doc_no.text = newDocNo();
                if (value != null) {
                  var docno = value.toInt() + 1;
                  doc_no.text = docno.toString();
                }
                var hdr_serial_no = 0;

                st_docno_insert(doc_no.text, remarks.text, selectedZonefrom,
                        selectedZoneto, hdr_serial_no, det_serial_no)
                    .then((value) {
                  if (value == 1) {
                    doc_generate = true;
                    middle_view = true;
                    showToast("Inserted Succesfully");
                  } else {
                    alert(context, value.toString(), Colors.red);
                  }
                });

                print(doc_no.text);
              });
            });
          if (selectedZonefrom == null || selectedZoneto == null)
            showToast("Please Select Dropdownlist");
        },
        child: Icon(Icons.build));
  }

  productInsert() async {
    if (prod_name.text.isEmpty || quantity.text.isEmpty) {
      String _msg = "Empty";
      return alert(this.context, 'Fields are ' + _msg, Colors.red);
    } else {
      getHDR(doc_no.text);
      String serial_no_zero;
      serial_no.toString().length == 1
          ? serial_no_zero = '0000'
          : serial_no_zero = '000';
      tx_id_no = gs_dndoc_type +
          "" +
          doc_no.text +
          "" +
          serial_no_zero +
          "" +
          serial_no.toString();
      if (luom.text.isEmpty) luom.text = '0';
      var resp = await st_prod_insert(
        doc_no.text,
        doc_date,
        serial_no,
        prod_code.text,
        prod_name.text,
        puom.text,
        qty_puom.text,
        luom.text,
        qty_luom.text,
        uppp,
        quantity.text,
        cost_rate,
        selectedZonefrom,
        selectedZoneto,
        tx_id_no,
        0,
      );
      if (resp == 1) {
        setState(() {
          det_serial_no = serial_no;
          updateHdr(serial_no);
          clearFields();
          serial_no = serial_no + 1;
          fetch_EntryDetails(doc_no.text);
          showToast('Created Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.red);
      }
    }
  }

  productupdation() async {
    if (prod_name.text.isEmpty || quantity.text.isEmpty) {
      return alert(this.context, 'Fields are empty', Colors.red);
    } else {
      // ---------------------Login Success--------------------------

      if (luom.text.isEmpty) luom.text = '0';
      var resp = await st_prod_update(
        list_serial_no,
        doc_no.text,
        qty_puom.text,
        qty_luom.text,
        quantity.text,
      );
      if (resp == 1) {
        setState(() {
          clearFields();
          fetch_EntryDetails(doc_no.text);
          showToast('Updated Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.red);
      }
    }
  }
}
