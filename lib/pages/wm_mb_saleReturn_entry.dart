import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_saleReturnList.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesEntryComman extends StatefulWidget {
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
  List detailslist = List();
  List salesmiddleList = List();
  List search_ref_datas = List();
  List salesproduct = List();
  List salesdetails = List();
  List srHDR = List();

  var serial_no;
  var uppp;
  var _puom;
  var _luom;
  var stk_puom;
  var stk_luom;
  double sales = 0;
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
    if (gs_sales_param1 == null) {
      customer.text = gs_sales_param2;
      selectedtype = salestypes[0];
      saleslist(gs_ac_code).then((value) {
        setState(() {
          print("saleslistref" + gs_ac_code);
          search_ref_datas.addAll(value);
          gs_ac_code = gs_sales_param4;
          gs_party_address = gs_sales_param3;
          if (search_ref_datas.isNotEmpty) {
            gs_ac_code = search_ref_datas[0].val9.toString();
          }
          list_length = search_ref_datas.length;
          print(list_length.toString() + '....');
          print(gs_ac_code + '....' + gs_party_address);
        });
      });
    }
    if (gs_sales_param1 != null) {
      sr_HDR(gs_sales_param1).then((value) {
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

          ref != null ? ref_no.text = ref.toString() : ref_no.text = '';
          print(srHDR[0]['REF_NO'].toString() + ' 666');
          print(srHDR[0]['PARTY_NAME'].toString());
          fetch_products();
          fetch_EntryDetails(doc_no.text);
        });
      });
    }
    gs_sales_param1 != null ? getSerialno_fun() : serial_no = 1;

    print(gs_party_address + "..> ");

    super.initState();
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
                  if (product_name.text.isNotEmpty && qty.text.isNotEmpty)
                    productInsert();
                  details_list = true;

                  print('serial_no' + serial_no.toString());
                });
              },
              child: Icon(Icons.save)),
          SizedBox(width: 20.0),
          GestureDetector(
              onTap: () {
                setState(() {
                  if (middle_view == false) middle_view = true;
                });
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
          GestureDetector(
              onTap: () {
                if (product_name.text != null && details_list == true)
                  sr_salesDelete(serial_no, doc_no.text).then((value) {
                    setState(() {
                      sales_delete = value;
                      if (sales_delete == true) {
                        fetch_EntryDetails(doc_no.text);
                        getSerialno_fun();
                        showToast('Deleted Succesfully');
                        print(serial_no + " new after delete");
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
                  SizedBox(height: 10),
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
      padding: new EdgeInsets.all(10.0),
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
        textField("Customer", customer, false, true),
        SizedBox(height: 12),
        Row(children: <Widget>[
          Flexible(flex: 3, child: textField("Doc_no", doc_no, false, true)),
          SizedBox(width: 10.0),
          Flexible(
              flex: 1, child: textField("Doc type", doc_type, false, true)),
          SizedBox(width: 5.0),
          Flexible(
              flex: 2, child: textField("Doc_no", ref_doc_no, false, true)),
        ]),
        SizedBox(height: 10),
        Row(children: <Widget>[
          Flexible(
              flex: 2,
              child: textField(
                  "Ref_no", ref_no, false, ref_no.text == null ? true : false)),
          SizedBox(width: 20.0),
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
          SizedBox(width: 20.0),
          if (doc_no.text.isEmpty && ref_doc_no.text.isNotEmpty)
            Flexible(
                child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: generate_docno())),
        ]),
        SizedBox(height: 10),
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
        SizedBox(height: 10),
        textField(
            "Remarks", remarks, false, remarks.text == null ? true : false),
      ]),
    );
  }

  middle() {
    return Column(children: [
      product_row("Product", product),
      SizedBox(height: 10),
      textField(
          "", product_name, false, product_name.text != null ? true : false),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(child: textData(_puom.toString(), Colors.purple, 16.0)),
        SizedBox(width: 18.0),
        Flexible(child: textField("QTY PUOM", puom, false, false)),
        SizedBox(width: 10.0),
        Flexible(child: textData(_luom.toString(), Colors.purple, 16.0)),
        SizedBox(width: 18.0),
        Flexible(child: textField("QTY LUOM", luom, false, false)),
      ]),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(
          child: textField("Quantity", qty, false, true),
        ),
        SizedBox(width: 10.0),
        Flexible(child: labelWidget(Colors.red[500], bal_stk)),
      ]),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(
            child: textField(
                "Unit rate ", rate, false, rate.text != null ? true : false)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField(
                'Amount', amt, false, amt.text != null ? true : false)),
      ]),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(
            child:
                textField("VAT", vat, false, vat.text != null ? true : false)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField("Net Amount", net_amt, false,
                net_amt.text != null ? true : false)),
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
                datas: search_ref_datas,
                toPage: null,
                head: false,
                popBack: true)));
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
      child: DataTable(
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
          )),
    );
  }

  product_row(_text, _controller) {
    return Row(
      children: <Widget>[
        Flexible(child: textField(_text, _controller, false, false)),
        Flexible(
            child: Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: RaisedButton(
                    onPressed: () {
                      showDialog(
                              context: context,
                              builder: (BuildContext context) => prodlist())
                          .then((value) {
                        setState(() {
                          if (gs_list_index != null) {
                            prod_update = false;
                            gs_sales_param1 != null
                                ? getSerialno_fun()
                                : serial_no = 1;
                            print(serial_no.toString() + "in new");
                            print(prod_update);
                            productClick();
                          }
                        });
                      });
                      ;
                    },
                    child: Text('Search'))))
      ],
    );
  }

  productClick() {
    _puom = salesproduct[gs_list_index].puom.toString();
    _luom = salesproduct[gs_list_index].luom.toString();
    // stk_puom = salesproduct[gs_list_index].stk_puom.toString();
    // stk_luom = salesproduct[gs_list_index].stk_luom.toString();
    product.text = salesproduct[gs_list_index].val2.toString();
    product_name.text = salesproduct[gs_list_index].val1.toString();
    rate.text = salesproduct[gs_list_index].val7.toString();
    qty.text = salesproduct[gs_list_index].val3.toString();
    // bal_stk.text = 'Bal: ' + stk_puom + ' ' + _puom;
    amt.clear();
    vat.clear();
    net_amt.clear();
    // qty.clear();
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
      double _rate = double.parse(rate.text);
      var _amt = _qty * _rate;
      amt.text = getNumberFormat(_qty * _rate).toString();
      var _vat = (_rate * 0.05) * _qty;
      if (amt.text.isNotEmpty) vat.text = getNumberFormat(_vat).toString();
      net_amt.text = getNumberFormat(_amt + _vat).toString();
    }
  }

  getSerialno_fun() {
    return getSRSerialno(gs_sales_param1).then((value) {
      print(value);
      if (value == null) serial_no = 1;
      if (value != null) serial_no = value.toInt() + 1;
      print(serial_no.toString() + '.....sno');
    });
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
                      gs_party_address,
                      gs_ac_code)
                  .then((value) {
                middle_view = true;
                gs_sales_param1 != null ? getSerialno_fun() : serial_no = 1;
              });
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
          serial_no = serialno;
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
          "AED",
          doc_type.text,
          ref_doc_no.text);
      if (resp == 1) {
        setState(() {
          clearFields();
          fetch_EntryDetails(doc_no.text);
          // Navigator.of(context).pop(true);
          showToast('Created Succesfully');
        });
      } else {
        showToast('error');
      }
    }
  }

  clearFields() {
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
