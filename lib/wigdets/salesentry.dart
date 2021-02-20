import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'listing_Builder.dart';

class SalesEntry extends StatefulWidget {
  @override
  _SalesEntryState createState() => _SalesEntryState();
}

class _SalesEntryState extends State<SalesEntry> {
  String _message = '';
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
  List salestypes = ['CASH', 'CREDIT'];
  String selectedtype;
  bool middle_view = false;
  List salesHDR = List();
  var serial_no;
  List salesdetails = List();
  List productList = List();
  var _puom;
  var _luom;
  var stk_puom;
  var stk_luom;

  @override
  void initState() {
    if (gs_sales_param1 == null) customer.text = gs_sales_param2;
    if (gs_sales_param1 != null)
      getAllSalesHDR(gs_sales_param1).then((value) {
        setState(() {
          salesHDR.addAll(value);
          selectedtype = salesHDR[0]['SALE_TYPE'].toString();
          customer.text = salesHDR[0]['PARTY_NAME'].toString();
          var doc = salesHDR[0]['DOC_NO'].toString();
          if (doc != 'null') doc_no.text = doc.toString();
          var ref = salesHDR[0]['REF_NO'].toString();
          if (ref != 'null') ref_no.text = ref.toString();
          print(salesHDR[0]['PARTY_NAME'].toString());
        });
      });
    if (gs_sales_param1 != null) fetch_saleseEntry();
    getAllProduct().then((value) {
      setState(() {
        productList.addAll(value);
      });
    });
    print(doc_no.text);
    gs_sales_param1 != null
        ? getSerialno(gs_sales_param1)
            .then((value) => serial_no = value.toInt() + 1)
        : serial_no = 1;
    super.initState();
  }

  dropDown_salestype() {
    return Padding(
      padding: new EdgeInsets.all(10.0),
      child: new DropdownButton(
        isExpanded: true,
        hint: Text("Select Sales Type"),
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
          GestureDetector(
              onTap: () {
                setState(() {
                  productInsert();
                });
              },
              child: Icon(Icons.save)),
          SizedBox(width: 20.0),
          GestureDetector(
              onTap: () {
                setState(() {
                  middle_view = true;
                  print(serial_no.toString());
                  gs_list_index = null;
                });
              },
              child: Icon(Icons.add)),
          SizedBox(width: 20.0),
          GestureDetector(onTap: () {}, child: Icon(Icons.delete)),
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
                  saleslist(),
                ],
              ),
            )),
      ),
    );
  }

  head() {
    return Container(
      child: Column(children: [
        textField("Customer", customer, false, true),
        SizedBox(height: 12),
        Row(children: <Widget>[
          Flexible(child: textField("Doc_no", doc_no, false, true)),
          if (doc_no.text.isEmpty)
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: button_generate(null, context)),
            ),
        ]),
        SizedBox(height: 10),
        textField("Ref_no", ref_no, false, ref_no.text != null ? true : false),
        SizedBox(height: 10),
        Row(children: <Widget>[
          Flexible(child: dropDown_salestype()),
          Flexible(
              child: IconButton(
            icon: Icon(Icons.print),
            onPressed: () {},
          )),
        ]),
        SizedBox(height: 10),
        textField(
            "Remarks", remarks, false, remarks.text != null ? true : false)
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
        Flexible(child: textField("PUOM", puom, false, false)),
        SizedBox(width: 10.0),
        Flexible(child: textField("LUOM", luom, false, false)),
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

  saleslist() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: [
            DataColumn(label: text("SERIAL NO", Colors.black), numeric: false),
            DataColumn(label: text("PROD CODE", Colors.black), numeric: false),
            DataColumn(label: text("PROD NAME", Colors.black), numeric: false),
            DataColumn(label: text("PUOM", Colors.black), numeric: false),
            DataColumn(label: text("QTY PUOM", Colors.black)),
            DataColumn(label: text("LUOM", Colors.black), numeric: false),
            DataColumn(label: text("QTY LUOM", Colors.black)),
            DataColumn(label: text("AMOUNT", Colors.black)),
            DataColumn(label: text("VAT", Colors.black)),
            DataColumn(label: text("NET AMOUNT", Colors.black)),
          ],
          rows: salesdetails
              .map(
                (saleslog) => DataRow(cells: <DataCell>[
                  DataCell(Text(saleslog['SERIAL_NO'].toString())),
                  DataCell(Text(saleslog['PROD_CODE'].toString())),
                  DataCell(Text(saleslog['PROD_NAME'].toString())),
                  DataCell(Text(saleslog['P_UOM'].toString())),
                  DataCell(Text(saleslog['QTY_PUOM'].toString())),
                  DataCell(Text(saleslog['L_UOM'].toString())),
                  DataCell(Text(saleslog['QTY_LUOM'].toString())),
                  DataCell(Text(saleslog['AMOUNT'].toString())),
                  DataCell(
                      Text(saleslog['TX_COMPNT_AMT_1'].toStringAsFixed(3))),
                  DataCell(Text(saleslog['NET_AMOUNT'].toStringAsFixed(3))),
                ]),
              )
              .toList()),
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
                            productClick();
                          }
                        });
                      });
                    },
                    child: Text('Search'))))
      ],
    );
  }

  prodlist() {
    return AlertDialog(
        title: Text('Products'),
        content: Container(
            height: 400.0,
            width: 300.0,
            child: ListBuilderCommon(
                datas: productList, head: false, toPage: null, popBack: true)));
  }

  button_generate(page, context) {
    return RaisedButton(
      color: Colors.green[400],
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => page),
        // );
        page;
      },
      child: Text('Generate'),
    );
  }

  textField(_text, _controller, _validate, read) {
    bool obs = false;
    if (_text == 'Password') obs = true;
    return TextField(
      readOnly: read,
      obscureText: obs,
      onTap: () {
        setState(() {
          if (_text == 'Quantity') {
            productCalculate();
          }
        });
      },
      decoration: InputDecoration(
          labelText: _text,
          border: const OutlineInputBorder(),
          contentPadding: EdgeInsets.all(10),
          errorText: _validate ? 'Value Can\'t Be Empty' : null,
          focusColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.black54)),
      controller: _controller,
    );
  }

  fetch_saleseEntry() {
    return getAllSalesEntryDetails(gs_sales_param1).then((value) {
      setState(() {
        salesdetails.clear();
        salesdetails.addAll(value);
      });
    });
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

  productCalculate() {
    var puoms;
    var luoms;
    puom.text.isNotEmpty ? puoms = int.parse(puom.text) : puoms = 0;
    luom.text.isNotEmpty ? luoms = int.parse(luom.text) : luoms = 0;
    var _qty = puoms + luoms;
    qty.text = _qty.toString();
    var _rate = double.parse(rate.text);
    var _amt = _qty * _rate;
    amt.text = (_qty * _rate).toString();
    var _vat = (_rate * (5 / 100)) * _qty;
    vat.text = _vat.toStringAsFixed(3);
    net_amt.text = (_amt + _vat).toString();
  }

  productInsert() async {
    if (!_formkey.currentState.validate()) {
      String _msg = "required";
      if (qty.text.isEmpty) {
        return alert(this.context, 'puom or luom is ' + _msg, Colors.red);
      }
    } else {
      // ---------------------Login Success--------------------------
      setState(() {
        _message = 'Loading....';
      });
      var resp = await product_insertion(
          doc_no.text,
          product.text,
          product_name.text,
          _puom,
          puom.text,
          _luom,
          luom.text,
          amt.text,
          vat.text,
          net_amt.text);
      if (resp == 1) {
        setState(() {
          clearFields();
          fetch_saleseEntry();
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
  }
}
