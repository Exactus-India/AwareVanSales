import 'dart:async';

import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_saleReturnList.dart';
import 'package:aware_van_sales/wigdets/dataTable_widget.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesEntryComman extends StatefulWidget {
  final List sdn_hdr;
  final List sdn_det;
  final List det_list_col;

  const SalesEntryComman(
      {Key key, this.sdn_hdr, this.sdn_det, this.det_list_col})
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
  List details_list = List();
  List salesmiddleList = List();
  List productList = List();
  List search_ref_datas = List();
  List salesdetails = List();

  var serial_no;
  var _puom;
  var _luom;
  var stk_puom;
  var stk_luom;
  double sales = 0;
  bool prod_update = false;
  bool hdr = false;

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
    getAllProduct().then((value) {
      setState(() {
        productList.clear();
        productList.addAll(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Return"),
        actions: <Widget>[
          GestureDetector(onTap: () {}, child: Icon(Icons.save)),
          SizedBox(width: 20.0),
          GestureDetector(
              onTap: () {
                setState(() {
                  if (middle_view == false) middle_view = true;
                });
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
          GestureDetector(onTap: () {}, child: Icon(Icons.delete_forever)),
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
                  if (middle_view == true)
                    middle(),
                  // salesReturnlist(),
                  // if (details_list != false)
                  // saleslist(),
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
                          fetch_saleseEntry(ref_doc_no.text);
                        }
                      });
                    });
                  })),
          SizedBox(width: 20.0),
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

  salesReturnlist() {
    return SingleChildScrollView(
        child: WidgetdataTable(column: widget.det_list_col, row: details_list));
  }

  fetch_saleseEntry(param1) {
    return getAllSalesEntryDetails(param1).then((value) {
      setState(() {
        salesdetails.clear();
        salesdetails.addAll(value);
        print("salesdetails");
        print(salesdetails.length);
        if (salesdetails.isNotEmpty) {
          print("in details");
          // details_list = true;
          list_length = 0;
          list_length = salesdetails.length;
        }
        // for (int i = 0; i < salesdetails.length; i++)
        //   sales += salesdetails[i].val10.toDouble();

        // print(sales.toString()+'total');
      });
    });
  }

  prodlist() {
    return AlertDialog(
        title: Text('Products'),
        content: Container(
          height: 400.0,
          width: 300.0,
          child: dataTable(salesdetails.length, salesdetails, saleslog_col),
        ));
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
                // selected: middle_view == false,
                onSelectChanged: (va) {
                  if (va) {
                    setState(() {
                      if (middle_view == false) middle_view = true;
                      prod_update = true;
                      print(prod_update);
                      String sno = rowList[index].val1.toString();
                      selectListItem(sno);
                      Navigator.of(context).pop(true);
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
                  DataCell(
                      Text(getNumberFormat(rowList[index].val8).toString())),
                  DataCell(
                      Text(getNumberFormat(rowList[index].val9).toString())),
                  DataCell(
                      Text(getNumberFormat(rowList[index].val10).toString())),
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
                          if (gs_list_index != null) {}
                        });
                      });
                    },
                    child: Text('Search'))))
      ],
    );
  }

  productClick() {
    _puom = productList[gs_list_index].puom.toString();
    _luom = productList[gs_list_index].luom.toString();
    stk_puom = productList[gs_list_index].stk_puom.toString();
    stk_luom = productList[gs_list_index].stk_luom.toString();
    product.text = productList[gs_list_index].val2.toString();
    product_name.text = productList[gs_list_index].val1.toString();
    rate.text = productList[gs_list_index].val9.toString();
    bal_stk.text = 'Bal: ' + stk_puom + ' ' + _puom;
    amt.clear();
    vat.clear();
    net_amt.clear();
    qty.clear();
    puom.clear();
    luom.clear();
  }

  getSerialno_fun() {
    return getSerialno(gs_sales_param1).then((value) {
      print(value);
      if (value == null) serial_no = 1;
      if (value != null) serial_no = value.toInt() + 1;
      print(serial_no.toString() + '.....');
    });
  }

  generate_docno() {
    var ls_date = DateFormat("dd/MM/yyyy").format(DateTime.now()).toString();
    var ls_mth_code = ls_date[6] + ls_date[8] + ls_date[9];
    ls_mth_code = ls_mth_code + ls_date[3] + ls_date[4];
    if (doc_type.text.isNotEmpty)
      return GestureDetector(
          onTap: () {
            getSRDocno().then((value) {
              setState(() {
                print(value.toString() + '.....');
                if (value == null)
                  doc_no.text = ls_mth_code.toString() + "00001";
                if (value != null) {
                  var docno = value.toInt() + 1;
                  doc_no.text = docno.toString();
                  print(docno.toString() + " notnull");
                }
                srno_insert(
                        customer.text, doc_no.text, selectedtype, ref_no.text)
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

  selectListItem(serialno) {
    return salesmiddile(ref_doc_no.text, serialno).then((value) {
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
          amt.text = salesmiddleList[0].amount.toString();
          vat.text = salesmiddleList[0].vat.toString();
          net_amt.text =
              (double.parse(amt.text) + double.parse(vat.text)).toString();
          qty.text = salesmiddleList[0].tot_qty.toString();

          print(serial_no.toString() + "*");
        });
      });
    });
  }
}
