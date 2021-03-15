import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesEntryComman extends StatefulWidget {
  final doc_no;
  final ac_code;
  final ac_name;
  final party_address;

  const SalesEntryComman(
      {Key key, this.doc_no, this.ac_code, this.ac_name, this.party_address})
      : super(key: key);
  @override
  _SalesEntryCommanState createState() => _SalesEntryCommanState();
}

class _SalesEntryCommanState extends State<SalesEntryComman> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController customer = new TextEditingController();
  TextEditingController doc_no = new TextEditingController();
  TextEditingController ref_doc_no = new TextEditingController();
  TextEditingController doc_type = new TextEditingController();

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
  List hDR = List();
  List salesmiddleList = List();
  List search_ref_datas = List();
  List salesproduct = List();
  List salesdetails = List();
  List srHDR = List();
  var list_serial_no;
  var serial_no;
  var uppp;
  var avl_qty;
  var _puom;
  var _luom;
  bool prod_update = false;
  bool hdr = false;
  bool details_list = false;

  List saleslog_col = [
    "SERIAL NO",
    "PRODUCT CODE",
    "PRODUCT NAME",
    "PUOM",
    "QTY PUOM",
    "LUOM",
    "QTY LUOM",
    "AMOUNT",
    "VAT",
    "NET AMOUNT"
  ];

  @override
  void initState() {
    _puom = "PUOM";
    _luom = "LUOM";
    if (widget.doc_no == null) {
      customer.text = widget.ac_name;
      selectedtype = salestypes[0];
      serial_no = 1;
      saleslist(widget.ac_code).then((value) {
        setState(() {
          print("saleslistref" + widget.ac_code);
          search_ref_datas.addAll(value);
          list_length = search_ref_datas.length;
          print(list_length.toString() + '....');
          print(widget.ac_code + '....' + widget.party_address);
        });
      });
    }
    if (widget.doc_no != null) {
      getHDR();
    }

    print(widget.party_address + "..> ");

    super.initState();
  }

  getHDR() {
    return sr_HDR(widget.doc_no).then((value) {
      setState(() {
        srHDR.clear();
        srHDR.addAll(value);
        if (srHDR[0]['SALE_TYPE'] != null)
          selectedtype = srHDR[0]['SALE_TYPE'].toString();
        customer.text = srHDR[0]['PARTY_NAME'].toString();
        ref_doc_no.text = srHDR[0]['REF_DOC_NO'].toString();
        doc_type.text = srHDR[0]['REF_DOC_TYPE'].toString();
        var doc = srHDR[0]['DOC_NO'].toString();
        if (doc != 'null') doc_no.text = doc.toString();
        var ref = srHDR[0]['REF_NO'];
        var sn_no = srHDR[0]['LAST_DTL_SERIAL_NO'];
        if (sn_no == null || sn_no == 0) sn_no = 0;
        serial_no = sn_no + 1;

        ref != null ? ref_no.text = ref.toString() : ref_no.text = '';
        print(srHDR[0]['REF_NO'].toString() + ' 666');
        print(srHDR[0]['PARTY_NAME'].toString());
        fetch_products();
        fetch_EntryDetails(doc_no.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Return"),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  if (doc_no.text.isNotEmpty) {
                    if (net_amt.text.isEmpty || qty.text.isEmpty) updateHdr();
                    if (net_amt.text.isNotEmpty && qty.text.isNotEmpty)
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
          GestureDetector(
              onTap: () {
                setState(() {
                  if (middle_view == false) middle_view = true;
                  clearFields();
                });
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
          GestureDetector(
              onTap: () {
                if (product_name.text != null && details_list == true)
                  sr_salesDelete(list_serial_no, doc_no.text).then((value) {
                    setState(() {
                      sales_delete = value;
                      if (sales_delete == true) {
                        fetch_EntryDetails(doc_no.text);
                        showToast('Deleted Succesfully');
                        print(serial_no.toString() + " new after delete");
                        clearFields();
                      }
                    });
                  });
              },
              child: Icon(Icons.delete_forever)),
          SizedBox(width: 20.0),
        ],
      ),
      body: new Padding(
        padding: new EdgeInsets.all(18.0),
        child: new Form(
            key: _formkey,
            child: new SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  head(),
                  SizedBox(height: 4),
                  if (middle_view == true) middle(),
                  if (details_list != false) salesReturnDetailedlist(),
                ],
              ),
            )),
      ),
    );
  }

  dropDown_salestype() {
    return Padding(
      padding: new EdgeInsets.only(left: 10.0),
      child: new DropdownButton(
        isExpanded: true,
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

  head() {
    return Container(
      child: Column(children: [
        textField("Customer", customer, false, true, TextAlign.left),
        SizedBox(height: 4),
        Row(children: <Widget>[
          Flexible(
              flex: 3,
              child: textField("Doc_no", doc_no, false, true, TextAlign.left)),
          SizedBox(width: 10.0),
          Flexible(
              flex: 1,
              child:
                  textField("Doc type", doc_type, false, true, TextAlign.left)),
          SizedBox(width: 5.0),
          Flexible(
              flex: 2,
              child:
                  textField("Doc_no", ref_doc_no, false, true, TextAlign.left)),
        ]),
        SizedBox(height: 4),
        Row(children: <Widget>[
          Flexible(
              fit: FlexFit.tight,
              child: textField("Ref_no", ref_no, false, true, TextAlign.left)),
          if (ref_doc_no.text.isEmpty) SizedBox(width: 4.0),
          if (ref_doc_no.text.isEmpty)
            Flexible(
                child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showDialog(
                              context: context,
                              builder: (BuildContext context) => refNolist())
                          .then((value) {
                        setState(() {
                          if (gs_list_index != null) {
                            doc_type.text =
                                search_ref_datas[gs_list_index].val7.toString();
                            ref_doc_no.text =
                                search_ref_datas[gs_list_index].val2.toString();
                            ref_no.text =
                                search_ref_datas[gs_list_index].val4.toString();
                            print("Accordingly");
                            fetch_products();
                          }
                        });
                      });
                    })),
          if (doc_no.text.isEmpty && ref_doc_no.text.isNotEmpty)
            SizedBox(width: 4.0),
          if (doc_no.text.isEmpty && ref_doc_no.text.isNotEmpty)
            Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: generate_docno())),
        ]),
        Row(children: <Widget>[
          Flexible(flex: 1, child: dropDown_salestype()),
          SizedBox(width: 20.0),
          Flexible(
            child: IconButton(
                icon: Icon(
                  Icons.print,
                  size: 30.0,
                ),
                onPressed: () {}),
          )
        ]),
        textField("Remarks", remarks, false,
            remarks.text == null ? true : false, TextAlign.left),
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
          child: textField("Quantity", qty, false, true, TextAlign.right),
        ),
        SizedBox(width: 10.0),
        Flexible(child: labelWidget(Colors.red[500], bal_stk, 13.0)),
      ]),
      Row(children: <Widget>[
        Flexible(
            child: textField("Unit rate ", rate, false,
                rate.text != null ? true : false, TextAlign.right)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField('Amount', amt, false,
                amt.text != null ? true : false, TextAlign.right)),
      ]),
      Row(children: <Widget>[
        Flexible(
            child: textField("VAT", vat, false, vat.text != null ? true : false,
                TextAlign.right)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField("Net Amount", net_amt, false,
                net_amt.text != null ? true : false, TextAlign.right)),
      ]),
    ]);
  }

  refNolist() {
    list_length = search_ref_datas.length;
    return AlertDialog(
      content: Container(
        height: 400.0,
        width: 300.0,
        child: ListBuilderCommon(
            datas: search_ref_datas, toPage: null, head: false, popBack: true),
      ),
    );
  }

  salesReturnDetailedlist() {
    return SingleChildScrollView(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: dataTable(salesdetails.length, salesdetails, saleslog_col)));
  }

  fetch_products() {
    return getAllSRProduct(doc_type.text, ref_doc_no.text).then((value) {
      setState(() {
        salesproduct.clear();
        salesproduct.addAll(value);
        print("Product length " + salesproduct.length.toString());
      });
    });
  }

  fetch_EntryDetails(param1) {
    return getAllSalesSR_EntryDetails(param1).then((value) {
      setState(() {
        salesdetails.clear();
        salesdetails.addAll(value);
        print("salesdetails");
        print(salesdetails.length);
        if (salesdetails.isNotEmpty) {
          details_list = true;
          print("in details");
          list_length = 0;
          list_length = salesdetails.length;
        }
      });
    });
  }

  prodlist() {
    list_length = salesproduct.length;
    return AlertDialog(
        title: Text('Products'),
        content: Container(
            height: 400.0,
            width: 300.0,
            child: ListBuilderCommon(
                datas: salesproduct,
                head: false,
                toPage: null,
                popBack: true)));
  }

  dataTable(numItems, rowList, column) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CustomDataTable(
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
                      if (va) {
                        setState(() {
                          if (middle_view == false) middle_view = true;
                          String sno = rowList[index].val1.toString();
                          prod_update = true;
                          print("update");
                          print(prod_update);
                          selectDetailListItem(sno);
                        });
                      }
                    },
                    cells: <DataCell>[
                      DataCell(Text(rowList[index].val1.toString())),
                      DataCell(Text(rowList[index].val2.toString())),
                      DataCell(Text(rowList[index].val3.toString())),
                      DataCell(Text(rowList[index].val4.toString())),
                      DataCell(Text(rowList[index].val5.toString())),
                      DataCell(Text(rowList[index].val6.toString())),
                      DataCell(Text(rowList[index].val7.toString())),
                      DataCell(Text(rowList[index].val8.toString())),
                      DataCell(Text(rowList[index].val9.toString())),
                      DataCell(Text(rowList[index].val10.toString())),
                    ]),
              ))),
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
                      print("update");
                      print(prod_update);
                      productClick();
                    }
                  });
                });
              },
              icon: Icon(Icons.search, color: Colors.green)),
        ))
      ],
    );
  }

  productClick() {
    amt.clear();
    vat.clear();
    net_amt.clear();
    _puom = salesproduct[gs_list_index].puom.toString();
    _luom = salesproduct[gs_list_index].luom.toString();
    // stk_puom = salesproduct[gs_list_index].stk_puom.toString();
    // stk_luom = salesproduct[gs_list_index].stk_luom.toString();
    product.text = salesproduct[gs_list_index].val2.toString();
    product_name.text = salesproduct[gs_list_index].val1.toString();
    uppp = salesproduct[gs_list_index].uppp;
    rate.text = "455";

    avl_qty = salesproduct[gs_list_index].val7.toString();
    bal_stk.text = "Available Qty " + avl_qty;
    // puom.text = salesproduct[gs_list_index].qty_puom.toString();
    luom.text = salesproduct[gs_list_index].qty_luom.toString();
  }

  productCalculate() {
    var puoms;
    var luoms;
    puom.text.isNotEmpty ? puoms = int.parse(puom.text) : puoms = 0;
    luom.text.isNotEmpty ? luoms = int.parse(luom.text) : luoms = 0;
    var _qty = (puoms * uppp) + luoms;
    qty.text = _qty.toString();
    if (qty.text.isNotEmpty) {
      double _rate = double.parse(rate.text);
      var _amt = _qty * _rate;
      amt.text = getNumberFormat(_qty * _rate).toString();
      var _vat = (_rate * 0.05) * _qty;
      if (amt.text.isNotEmpty) vat.text = getNumberFormat(_vat).toString();
      net_amt.text = getNumberFormat(_amt + _vat).toString();
    }
  }

  updateHdr() async {
    if (remarks.text.isNotEmpty || selectedtype != null) {
      var resp = await sr_hdr_update(doc_no.text, ref_no.text, selectedtype,
          doc_type.text, ref_doc_no.text, serial_no, remarks.text);
      if (resp == 1) {
        setState(() {
          showToast('updated Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.green);
      }
    }
  }

  generate_docno() {
    var ls_date = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
    var ls_mth_code = ls_date[6] + ls_date[8] + ls_date[9];
    ls_mth_code = ls_mth_code + "10";
    return GestureDetector(
        onTap: () {
          getSRDocno().then((value) {
            setState(() {
              print(value.toString() + '.....');
              if (value == null)
                doc_no.text = ls_mth_code.toString() + "00001";
              else {
                var docno = value.toInt() + 1;
                doc_no.text = docno.toString();
                print(docno.toString() + " notnull");
              }
              srno_insert(
                      customer.text,
                      doc_no.text,
                      selectedtype,
                      ref_no.text,
                      ref_doc_no.text,
                      doc_type.text,
                      widget.party_address,
                      widget.ac_code)
                  .then((value) {
                middle_view = true;
              });
              fetch_products();

              print(doc_no.text);
            });
          });
        },
        child: Icon(Icons.build));
  }

  selectDetailListItem(serialno) {
    return sr_salesmiddile(doc_no.text, serialno).then((value) {
      new Timer(const Duration(milliseconds: 300), () {
        setState(() {
          salesmiddleList.clear();
          salesmiddleList.addAll(value);
          print("object");
          middle_view = true;
          prod_update = true;
          print(prod_update);
          // clearFields();
          print(salesmiddleList.length.toString() + 'list Size');
          list_serial_no = serialno;
          product.text = salesmiddleList[0].product_code.toString();
          product_name.text = salesmiddleList[0].product_name.toString();
          puom.text = salesmiddleList[0].qty_puom.toString();
          luom.text = salesmiddleList[0].qty_luom.toString();
          rate.text = salesmiddleList[0].unit_price.toString();
          amt.text = getNumberFormat(salesmiddleList[0].amount).toString();
          vat.text = getNumberFormat(salesmiddleList[0].vat).toString();
          var n_amt = getNumberFormat(salesmiddleList[0].net_amount);
          net_amt.text = n_amt.toString();

          // net_amt.text =
          //     (double.parse(amt.text) + double.parse(vat.text)).toString();
          qty.text = salesmiddleList[0].tot_qty.toString();

          print(serial_no.toString() + "*");
        });
      });
    });
  }

  productInsert() async {
    if (product.text.isEmpty || qty.text.isEmpty || net_amt.text.isEmpty) {
      String _msg = "Empty";
      return alert(this.context, 'Fields are ' + _msg, Colors.red);
    } else {
      // ---------------------Login Success--------------------------
      amt.text = numberWithCommas(amt.text);
      vat.text = numberWithCommas(vat.text);
      net_amt.text = numberWithCommas(net_amt.text);
      if (luom.text.isEmpty) luom.text = '0';
      getHDR();
      updateHdr();
      var resp = await sr_product_insertion(
          serial_no,
          product.text,
          product_name.text,
          _puom,
          puom.text,
          _luom,
          luom.text,
          amt.text,
          vat.text,
          net_amt.text,
          doc_no.text,
          "DC",
          qty.text,
          rate.text,
          doc_type.text,
          ref_doc_no.text);
      if (resp == 1) {
        setState(() {
          clearFields();
          fetch_EntryDetails(doc_no.text);
          showToast('Created Succesfully');
        });
      } else {
        showToast('error');
      }
    }
  }

  productupdation() async {
    if (product.text.isEmpty || qty.text.isEmpty) {
      return alert(this.context, 'Fields are empty', Colors.red);
    } else {
      // ---------------------Login Success--------------------------
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
          "net_price",
          "disc_price",
          "unit_price_amt",
          "amount",
          "lcur_amt",
          "lcur_amt_disc",
          "tx_cmpt_perc",
          "tx_cmpt_amt",
          "tx_cmpt_lcur_amt");
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

  textField(_text, _controller, _validate, read, align) {
    return Container(
      height: 40.0,
      child: TextField(
        textAlign: align,
        readOnly: read,
        onChanged: (value) {
          setState(() {
            if (_text == 'QTY PUOM') {
              if (int.parse(avl_qty) >= int.parse(puom.text))
                productCalculate();
              if (int.parse(avl_qty) < int.parse(puom.text)) {
                alert(context, "Available Quantity " + avl_qty, Colors.orange);
                amt.clear();
                puom.clear();
                vat.clear();
                net_amt.clear();
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
}

// selectListItem(serialno) {
//   return salesmiddile(ref_doc_no.text, serialno).then((value) {
//     new Timer(const Duration(milliseconds: 300), () {
//       setState(() {
//         salesproduct.clear();
//         salesproduct.addAll(value);
//         print("object");
//         if (gs_list_index != null) {
//           prod_update = false;
//           gs_sales_param1 != null ? getSerialno_fun() : serial_no = 1;
//           print(serial_no.toString() + "in new");
//           print(prod_update);
//         }
//         middle_view = true;
//         print(salesproduct.length.toString() + 'list Size');
//         serial_no = serialno;
//         product.text = salesproduct[0].product_code.toString();
//         product_name.text = salesproduct[0].product_name.toString();
//         puom.text = salesproduct[0].qty_puom.toString();
//         luom.text = salesproduct[0].qty_luom.toString();
//         rate.text = salesproduct[0].unit_price.toString();
//         amt.text = salesproduct[0].amount.toString();
//         vat.text = salesproduct[0].vat.toString();
//         var n_amt = double.parse(amt.text) + double.parse(vat.text);
//         net_amt.text = n_amt.toString();
//         // net_amt.text =
//         //     (double.parse(amt.text) + double.parse(vat.text)).toString();
//         qty.text = salesproduct[0].tot_qty.toString();

//         print(serial_no.toString() + "*");
//       });
//     });
//   });
// }
