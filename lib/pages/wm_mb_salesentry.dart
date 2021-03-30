import 'dart:async';
import 'dart:io';

import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:ext_storage/ext_storage.dart';

import '../wigdets/listing_Builder.dart';
import '../wigdets/widgets.dart';
import 'wm_mb_LoginPage.dart';

class SalesEntry extends StatefulWidget {
  final doc_no;
  final ac_code;
  final ac_name;
  final party_address;

  const SalesEntry(
      {Key key, this.doc_no, this.ac_code, this.ac_name, this.party_address})
      : super(key: key);
  @override
  _SalesEntryState createState() => _SalesEntryState();
}

class _SalesEntryState extends State<SalesEntry> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController customer = new TextEditingController();
  TextEditingController doc_no = new TextEditingController();
  TextEditingController ref_no = new TextEditingController();
  TextEditingController remarks = new TextEditingController();
  TextEditingController product = new TextEditingController();
  TextEditingController product_name = new TextEditingController();
  TextEditingController luom = new TextEditingController();
  TextEditingController puom = new TextEditingController();
  TextEditingController bal_stk = new TextEditingController();
  TextEditingController qty = new TextEditingController();
  TextEditingController rate = new TextEditingController();
  TextEditingController amt = new TextEditingController();
  TextEditingController vat = new TextEditingController();
  TextEditingController net_amt = new TextEditingController();
  TextEditingController sal_ty = new TextEditingController();
  List salestypes = ['CASH', 'CREDIT'];
  String selectedtype;
  bool middle_view = false;
  bool sales_delete = false;
  List salesHDR = List();
  List salesdetails = List();
  List salesmiddleList = List();
  List productList = List();
  var serial_no;
  var list_serial_no;
  var uppp;
  var _puom;
  var _luom;
  var avl_qty;
  var stk_puom;
  var stk_luom;
  var amount;
  var net_price;
  var disc_price;
  var unit_price_amt;
  var cost_rate;
  var lcur_amt;
  var sign_ind = -1;
  var tx_id_no;
  var lcur_amt_disc;
  var tx_cmpt_perc = 5;
  var tx_cmpt_amt;
  var tx_cmpt_lcur_amt;
  var doc_date;
  int _pqty = 0;
  int _lqty = 0;
  double _amt = 0;
  double _vat = 0;
  double _tot = 0;
  double _netvatamt = 0;
  bool prod_update = false;
  bool details_list = false;
  var printed_y;
  var confirmed;
  bool editing = true;
  bool newEntry = true;

  List saleslog_col = [
    "SNO",
    "PRODUCT",
    "QTY",
    "TOTAL",
    "PROD NAME",
    "QTY PUOM",
    "QTY LUOM",
    "AMOUNT ",
    "VAT"
  ];

  @override
  void initState() {
    _puom = "PUOM";
    _luom = "LUOM";
    print(widget.ac_code + '' + widget.party_address);
    if (widget.doc_no == null) {
      editing = true;
      newEntry = true;
      serial_no = 1;
      customer.text = widget.ac_name;
      selectedtype = salestypes[0];
    }
    if (widget.doc_no != null) {
      getHDR(widget.doc_no);
      fetch_saleseEntry(widget.doc_no);
    }
    getAllProduct().then((value) {
      setState(() {
        productList.clear();
        productList.addAll(value);
      });
    });
    print(doc_no.text + ' doc no');
    super.initState();
  }

  getHDR(docno) {
    return getAllSalesHDR(docno).then((value) {
      setState(() {
        salesHDR.clear();
        salesHDR.addAll(value);
        if (salesHDR[0]['SALE_TYPE'] != null)
          selectedtype = salesHDR[0]['SALE_TYPE'].toString();
        customer.text = salesHDR[0]['PARTY_NAME'].toString();
        if (salesHDR[0]['REMARKS'] != null)
          remarks.text = salesHDR[0]['REMARKS'].toString();
        var doc = salesHDR[0]['DOC_NO'].toString();
        if (doc != 'null') doc_no.text = doc.toString();
        var date = salesHDR[0]['DOC_DATE'];
        doc_date = date.toString().split('T')[0];
        print(doc_date + " doc_date");
        var ref = salesHDR[0]['REF_NO'];
        doc_date = salesHDR[0]['REF_NO'];
        var sn_no = salesHDR[0]['LAST_DTL_SERIAL_NO'];
        if (sn_no == null || sn_no == 0) sn_no = 0;
        serial_no = sn_no + 1;

        ref != null ? ref_no.text = ref.toString() : ref_no.text = '';
        printed_y = salesHDR[0]['PRINTED_Y'];
        confirmed = salesHDR[0]['CONFIRMED'];
        if (confirmed == "Y") editing = false;
        print(confirmed);
        print(salesHDR[0]['REF_NO'].toString() + ' 666');

        print(salesHDR[0]['PARTY_NAME'].toString());
        newEntry = false;
      });
    });
  }

  dropDown_salestype() {
    return Padding(
      padding: new EdgeInsets.only(left: 10.0),
      child: new DropdownButton(
        isExpanded: true,
        hint: Text("Sales Type"),
        value: selectedtype,
        onChanged: (newValue) {
          setState(() {
            selectedtype = newValue;
          });
          print(selectedtype);
        },
        items: salestypes.map((valueItem) {
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
        title: text("Sales Entry", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          if (editing == true)
            GestureDetector(
                onTap: () {
                  setState(() {
                    if (doc_no.text.isNotEmpty) {
                      if (net_amt.text.isEmpty || qty.text.isEmpty) updateHdr();
                      if (net_amt.text != null && qty.text.isNotEmpty)
                        prod_update == false
                            ? productInsert()
                            : productupdation();

                      details_list = true;

                      print('serial_no' + serial_no.toString());
                    }
                  });
                },
                child: Icon(Icons.save)),
          SizedBox(width: 20.0),
          if (editing == true && newEntry == false)
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
          if (editing == true && newEntry == false)
            GestureDetector(
                onTap: () {
                  if (product_name.text != null && details_list == true)
                    salesDelete(list_serial_no, doc_no.text).then((value) {
                      setState(() {
                        sales_delete = value;
                        if (sales_delete == true) {
                          fetch_saleseEntry(doc_no.text);
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
      body: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Form(
            key: _formkey,
            child: new SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  head(),
                  if (middle_view == true) middle(),
                  SizedBox(height: 5),
                  if (details_list != false) saleslist(),
                ],
              ),
            )),
      ),
    );
  }

  head() {
    return Container(
      child: Column(children: [
        Row(children: <Widget>[
          Flexible(
            flex: 2,
            child: textField("Customer", customer, false, true, TextAlign.left),
          ),
          if (editing == true && newEntry == false && salesdetails.length > 0)
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: RaisedButton(
                    onPressed: () {
                      dnConfirmDirect(doc_no.text).then((value) {
                        if (value == true) {
                          getHDR(doc_no.text);
                          showToast('Confirmed Succesfully');
                        }
                        if (value != true) showToast('Failed');
                      });
                    },
                    color: Colors.green,
                    child: Text(
                      "CONFIRM",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ),
        ]),
        SizedBox(height: 4),
        Row(children: <Widget>[
          Flexible(
              child: textField("Doc_no", doc_no, false, true, TextAlign.left)),
          if (doc_no.text.isEmpty)
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: generate_docno()),
            ),
        ]),
        SizedBox(height: 4),
        textField("Ref_no", ref_no, false, editing == false ? true : false,
            TextAlign.left),
        dropDown_salestype(),
        textField("Remarks", remarks, false, editing == false ? true : false,
            TextAlign.left)
      ]),
    );
  }

  middle() {
    return Column(children: [
      product_row("Product", product),
      textField("", product_name, false, true, TextAlign.left),
      Row(children: <Widget>[
        Flexible(child: textData(_puom.toString(), Colors.purple, 13.0)),
        SizedBox(width: 10.0),
        Flexible(
            flex: 1,
            child: textField("QTY PUOM", puom, false, false, TextAlign.end)),
        if (_puom.toString() != _luom.toString()) SizedBox(width: 15.0),
        if (_puom.toString() == _luom.toString()) SizedBox(width: 60.0),
        if (_puom.toString() != _luom.toString())
          Flexible(child: textData(_luom.toString(), Colors.purple, 13.0)),
        SizedBox(width: 10.0),
        if (_puom.toString() != _luom.toString())
          Flexible(
              flex: 1,
              child: textField("QTY LUOM", luom, false, false, TextAlign.end)),
      ]),
      Row(children: <Widget>[
        Flexible(
          child: textField("Quantity", qty, false, true, TextAlign.end),
        ),
        SizedBox(width: 10.0),
        Flexible(child: labelWidget(Colors.red[500], bal_stk, 13.0)),
      ]),
      Row(children: <Widget>[
        Flexible(
            child: textField("Unit rate", rate, false, false, TextAlign.end)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField('Amount', amt, false,
                amt.text != null ? true : false, TextAlign.end)),
      ]),
      Row(children: <Widget>[
        Flexible(
            child: textField("VAT", vat, false, vat.text != null ? true : false,
                TextAlign.end)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField("Net Amount", net_amt, false,
                net_amt.text != null ? true : false, TextAlign.end)),
      ]),
    ]);
  }

  saleslist() {
    print(saleslog_col.length.toString());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: dataTable(salesdetails.length + 1, salesdetails, saleslog_col),
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
                if (editing == true) {
                  setState(() {
                    if (middle_view == false) middle_view = true;
                    prod_update = true;
                    print(prod_update);
                    String sno = rowList[index].val1.toString();
                    selectListItem(sno);
                  });
                  print(index.toString() + "........");
                  print((numItems).toString() + "........");
                }
              },
              cells: <DataCell>[
                //sno
                if (index != numItems - 1)
                  DataCell(Text(rowList[index].val1.toString())),
                if (index == numItems - 1)
                  DataCell(textBold("TOTAL")),
                //product code
                if (index != numItems - 1)
                  DataCell(Text(rowList[index].val2.toString())),
                if (index == numItems - 1)
                  DataCell(Text("")),
                //qty
                if (index != numItems - 1)
                  DataCell(Text(rowList[index].val5.toString())),
                if (index == numItems - 1)
                  DataCell(textBold(_pqty.toString())),
                //total
                if (index != numItems - 1)
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          getNumberFormat(rowList[index].val10).toString()))),
                if (index == numItems - 1)
                  DataCell(textBold(getNumberFormat(_tot).toString())),
                //prod name
                if (index != numItems - 1)
                  DataCell(Text(rowList[index].val3.toString())),
                if (index == numItems - 1)
                  DataCell(Text("")),
                //qtypuom

                if (index != numItems - 1)
                  DataCell(Text(rowList[index].val5.toString() +
                      " " +
                      rowList[index].val4.toString())),
                if (index == numItems - 1)
                  DataCell(textBold(_pqty.toString())),
                //qty_luom
                if (index != numItems - 1)
                  DataCell(Text(rowList[index].val7.toString() +
                      " " +
                      rowList[index].val6.toString())),
                if (index == numItems - 1)
                  DataCell(textBold(_lqty.toString())),
                //amt
                if (index != numItems - 1)
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          getNumberFormat(rowList[index].val8).toString()))),
                if (index == numItems - 1)
                  DataCell(textBold(getNumberFormat(_amt).toString())),
                //vat
                if (index != numItems - 1)
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          getNumberFormat(rowList[index].val9).toString()))),
                if (index == numItems - 1)
                  DataCell(textBold(getNumberFormat(_vat).toString())),
              ],
            ),
          ),
        ));
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
    list_length = productList.length;
    return AlertDialog(
        title: Text('Products'),
        content: Container(
            height: 400.0,
            width: 300.0,
            child: ListBuilderCommon(
                datas: productList, head: false, toPage: null, popBack: true)));
  }

  textField(_text, _controller, _validate, read, align) {
    return Container(
      height: 40.0,
      child: TextField(
        textAlign: align,
        readOnly: read,
        onChanged: (value) {
          setState(() {
            if (_text == 'Unit rate') {
              rate.text = value;
              if (qty.text.isNotEmpty) productCalculate();
            }
            if (_text == 'QTY PUOM') {
              if (luom.text.isEmpty) luom.text = '0';
              if (puom.text.isEmpty) puom.text = '0';
              var _qty_ = int.parse(puom.text) + int.parse(luom.text);
              if (prod_update == true) productCalculate();
              if (prod_update == false) {
                if (int.parse(avl_qty) >= _qty_) productCalculate();
                if (int.parse(avl_qty) < _qty_) {
                  alert(
                      context, "Available Quantity " + avl_qty, Colors.orange);
                  amt.clear();
                  puom.clear();
                  vat.clear();
                  net_amt.clear();
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

  updateHdr() async {
    print(printed_y);
    if (ref_no.text.isNotEmpty) {
      var resp = await dn_hdrUpdate(doc_no.text, selectedtype, ref_no.text,
          remarks.text, serial_no, printed_y);
      if (resp == 1) {
        setState(() {
          showToast('updated Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.green);
      }
    }
  }

  fetch_saleseEntry(param1) {
    return getAllSalesEntryDetails(param1).then((value) {
      setState(() {
        salesdetails.clear();
        salesdetails.addAll(value);
        _pqty = 0;
        _lqty = 0;
        _amt = 0;
        _vat = 0;
        _tot = 0;
        if (salesdetails.isNotEmpty) {
          print("in details");
          details_list = true;
          list_length = 0;
          list_length = salesdetails.length;

          for (int i = 0; i < salesdetails.length; i++) {
            _pqty += salesdetails[i].val5.toInt();
            _lqty += salesdetails[i].val7.toInt();
            _amt += salesdetails[i].val8.toDouble();
            _vat += salesdetails[i].val9.toDouble();
            _tot += salesdetails[i].val10.toDouble();
          }
        }

        print(_tot.toString() + 'total');
      });
    });
  }

  selectListItem(serialno) {
    salesmiddile(doc_no.text, serialno).then((value) {
      setState(() {
        new Timer(const Duration(milliseconds: 300), () {
          _puom = "";
          _luom = "";
          setState(() {
            salesmiddleList.clear();
            salesmiddleList.addAll(value);
            print(prod_update);
            clearFields();
            print(salesmiddleList.length.toString() + 'list Size');
            list_serial_no = serialno;
            product.text = salesmiddleList[0].product_code.toString();
            product_name.text = salesmiddleList[0].product_name.toString();
            puom.text = salesmiddleList[0].qty_puom.toString();
            luom.text = salesmiddleList[0].qty_luom.toString();
            rate.text = salesmiddleList[0].unit_price.toString();
            amt.text = getNumberFormat(salesmiddleList[0].amount).toString();
            vat.text = getNumberFormat(salesmiddleList[0].vat).toString();
            _puom = salesmiddleList[0].puom.toString();
            _luom = salesmiddleList[0].luom.toString();
            uppp = salesmiddleList[0].uppp;
            net_amt.text = getNumberFormat(
                    salesmiddleList[0].amount + salesmiddleList[0].vat)
                .toString();
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

  productClick() {
    _puom = productList[gs_list_index].puom.toString();
    _luom = productList[gs_list_index].luom.toString();
    stk_puom = productList[gs_list_index].stk_puom;
    stk_luom = productList[gs_list_index].stk_luom;
    product.text = productList[gs_list_index].val2.toString();
    product_name.text = productList[gs_list_index].val1.toString();
    uppp = productList[gs_list_index].uppp;
    cost_rate = productList[gs_list_index].cost_rate.toString();
    if (stk_luom == null) stk_luom = 0;
    avl_qty = (stk_puom + stk_luom).toString();
    bal_stk.text = 'Bal: ' + stk_puom.toString() + ' ' + _puom;
    discount_product(product.text, avl_qty).then((value) {
      if (value.toInt() != 0)
        rate.text = value.toString();
      else
        rate.text = productList[gs_list_index].val9.toString();
    });
    amt.clear();
    vat.clear();
    net_amt.clear();
    qty.clear();
    puom.clear();
    luom.clear();
  }

  productCalculate() {
    var puoms;
    var luoms;
    puom.text.isNotEmpty ? puoms = int.parse(puom.text) : puoms = 0;
    luom.text.isNotEmpty ? luoms = int.parse(luom.text) : luoms = 0;
    var _qty = (puoms * uppp) + luoms;
    qty.text = _qty.toString();
    if (qty.text.isNotEmpty) {
      setState(() {
        double _rate = double.parse(rate.text);
        var _amt = _qty * _rate;
        amount = _qty * _rate;
        amt.text = getNumberFormat(_qty * _rate).toString();
        var _vat = (_rate * 0.05) * _qty;
        if (amt.text.isNotEmpty) vat.text = getNumberFormat(_vat).toString();
        net_amt.text = getNumberFormat(_amt + _vat).toString();
      });
    }
  }

  fields_calculate() {
    String serial_no_zero;
    serial_no.toString().length == 1
        ? serial_no_zero = '0000'
        : serial_no_zero = '000';
    unit_price_amt = int.parse(rate.text);
    net_price = unit_price_amt - 0; // disc_hdr_price=0
    disc_price = ((unit_price_amt * gl_disc_perct) / 100);
    lcur_amt = amount.toDouble() * gl_EX_rate;
    lcur_amt_disc = lcur_amt;
    tx_id_no = gs_dndoc_type +
        "" +
        doc_no.text +
        "" +
        serial_no_zero +
        "" +
        serial_no.toString();
    tx_cmpt_amt = ((amount.toDouble() * tx_cmpt_perc) / 100);
    tx_cmpt_lcur_amt = tx_cmpt_amt;
    print("tx_id_no " + tx_id_no.toString());
  }

  productInsert() async {
    if (product.text.isEmpty || qty.text.isEmpty || net_amt.text.isEmpty) {
      String _msg = "Empty";
      return alert(this.context, 'Fields are ' + _msg, Colors.red);
    } else {
      // ---------------------Login Success--------------------------
      getHDR(doc_no.text);
      updateHdr();
      fields_calculate();
      amt.text = numberWithCommas(amt.text);
      net_amt.text = numberWithCommas(net_amt.text);
      if (luom.text.isEmpty) luom.text = '0';

      var resp = await product_insertion(
          doc_no.text,
          serial_no.toString(),
          product.text,
          product_name.text,
          _puom,
          puom.text,
          _luom,
          luom.text,
          uppp,
          qty.text,
          net_price,
          disc_price,
          unit_price_amt,
          amount,
          cost_rate,
          lcur_amt,
          sign_ind,
          tx_id_no,
          lcur_amt_disc,
          tx_cmpt_perc,
          tx_cmpt_amt,
          tx_cmpt_lcur_amt,
          rate.text);
      if (resp == 1) {
        setState(() {
          clearFields();
          serial_no = serial_no + 1;
          fetch_saleseEntry(doc_no.text);
          showToast('Created Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.red);
      }
    }
  }

  productupdation() async {
    if (product.text.isEmpty || qty.text.isEmpty) {
      return alert(this.context, 'Fields are empty', Colors.red);
    } else {
      print("amount " + amount.toString());
      // --------- "amount " + amount.toString()------------Login Success--------------------------
      unit_price_amt = int.parse(rate.text);
      net_price = unit_price_amt - 0;
      disc_price = ((unit_price_amt * gl_disc_perct) / 100);
      lcur_amt = amount * gl_EX_rate;
      lcur_amt_disc = lcur_amt;
      tx_cmpt_amt = ((amount * tx_cmpt_perc) / 100);
      tx_cmpt_lcur_amt = tx_cmpt_amt;

      amt.text = numberWithCommas(amt.text);
      vat.text = numberWithCommas(vat.text);
      net_amt.text = numberWithCommas(net_amt.text);
      if (luom.text.isEmpty) luom.text = '0';
      updateHdr();
      var resp = await product_updation(
        list_serial_no,
        doc_no.text,
        puom.text,
        luom.text,
        qty.text,
        net_price,
        disc_price,
        unit_price_amt,
        amount,
        lcur_amt,
        lcur_amt_disc,
        tx_cmpt_perc,
        tx_cmpt_amt,
        tx_cmpt_lcur_amt,
      );
      if (resp == 1) {
        setState(() {
          clearFields();
          fetch_saleseEntry(doc_no.text);
          showToast('Updated Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.red);
      }
    }
  }

  generate_docno() {
    return GestureDetector(
        onTap: () {
          getDNDocno().then((value) {
            setState(() {
              if (value == null) doc_no.text = newDocNo();
              if (value != null) {
                var docno = value.toInt() + 1;
                doc_no.text = docno.toString();
              }
              if (ref_no.text.isEmpty) {
                ref_no.text = doc_no.text;
              }
              docno_insert(
                      customer.text, doc_no.text, selectedtype, ref_no.text)
                  .then((value) {
                if (value == 1) {
                  getHDR(doc_no.text);
                  middle_view = true;
                  newEntry = false;
                  showToast("Inserted Succesfully");
                } else {
                  showToast(value.toString());
                }
              });

              print(doc_no.text);
            });
          });
        },
        child: Icon(Icons.build));
  }

  clearFields() {
    _puom = "PUOM";
    _luom = "LUOM";
    product.clear();
    product_name.clear();
    rate.clear();
    amt.clear();
    vat.clear();
    net_amt.clear();
    qty.clear();
    puom.clear();
    luom.clear();
    bal_stk.clear();
  }

  _generatePdfAndView(String choice) async {
    final pdf = pdfLib.Document();
    String now = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    // ignore: deprecated_member_use
    final PdfImage assetImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: const AssetImage('assets/exactus_logo.png'),
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
                    "BMK",
                    style: pdfLib.TextStyle(
                        fontSize: 18.0, fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text("Address :" + widget.party_address),
                  pdfLib.Text("Phn"),
                  pdfLib.Text("tr_no"),
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
                  pdfLib.Text("TAX INVOICE "),
                  if (printed_y.toString() == "Y")
                    pdfLib.Center(
                        child: pdfLib.Text("Duplicate copy",
                            style: pdfLib.TextStyle(fontSize: 10.0))),
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
                      pdfLib.Text("Doc Date: " + doc_date),
                      pdfLib.Text("Ref No " + ref_no.text),
                    ]),
                pdfLib.Row(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                    children: [
                      pdfLib.Text("Customer: " + customer.text),
                      pdfLib.Text("Sale Type: " + selectedtype),
                    ]),
                pdfLib.Text("Salesman Name: " + gs_currentUser),
              ]),
          pdfLib.SizedBox(height: 20.0),
          pdfLib.Table.fromTextArray(context: context, data: <List<dynamic>>[
            <String>['SNo', 'Product', 'Quantity', 'Rate', 'Amount'],
            ...salesdetails.map((item) => [
                  item.val1.toString(),
                  item.val2.toString() + "\n" + item.val3.toString(),
                  item.val5.toString() +
                      " " +
                      item.val4.toString() +
                      " " +
                      item.val7.toString() +
                      " " +
                      item.val6.toString(),
                  getNumberFormat(item.val11).toString(),
                  getNumberFormat(item.val10).toString(),
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
                    "Amount(VAT Exclusive) :" +
                        getNumberFormat(_amt).toString(),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text(
                    "VAT:   " + getNumberFormat(_vat).toString(),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text(
                    "Amount(VAT Inclusive) :" +
                        getNumberFormat(_tot).toString(),
                    style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  ),
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
                      pdfLib.Text("Issued by: " + "BMK"),
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
    if (printed_y.toString() == "Y")
      fileName = "/SALES-" + doc_no.text + "-copy.pdf";
    final File file = File(path + fileName);
    // if (choice == Constants.DownloadPdf) await file.writeAsBytes(pdf.save());
    // if (choice == Constants.DownloadPdf) showToast("Downloaded to $path");
    if (choice == Constants.ViewPdf)
      Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    if (choice == Constants.SharePdf) {
      await Printing.sharePdf(bytes: pdf.save(), filename: fileName);
      if (printed_y == "N")
        setState(() {
          printed_y = "Y";
          updateHdr();
        });
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
