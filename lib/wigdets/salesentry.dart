import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

import 'listing_Builder.dart';

class SalesEntry extends StatefulWidget {
  @override
  _SalesEntryState createState() => _SalesEntryState();
}

class _SalesEntryState extends State<SalesEntry> {
  TextEditingController customer = new TextEditingController();
  TextEditingController doc_no = new TextEditingController();
  TextEditingController ref_no = new TextEditingController();
  TextEditingController remarks = new TextEditingController();
  TextEditingController product = new TextEditingController();
  TextEditingController product_name = new TextEditingController();
  TextEditingController luom = new TextEditingController();
  TextEditingController puom = new TextEditingController();
  TextEditingController qty = new TextEditingController();
  TextEditingController rate = new TextEditingController();
  TextEditingController amt = new TextEditingController();
  TextEditingController vat = new TextEditingController();
  TextEditingController net_amt = new TextEditingController();
  List salestypes = ['CASH', 'CREDIT'];
  String selectedtype;
  bool middle_view = false;
  List salesHDR = List();
  String serial_no;
  List salesdetails = List();
  List productList = List();
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
    if (gs_sales_param1 != null)
      getAllSalesEntryDetails(gs_sales_param1).then((value) {
        setState(() {
          salesdetails.addAll(value);
        });
      });
    getAllProductDetails().then((value) {
      setState(() {
        productList.addAll(value);
      });
    });
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
          GestureDetector(onTap: () {}, child: Icon(Icons.save)),
          SizedBox(width: 20.0),
          GestureDetector(
              onTap: () {
                setState(() {
                  middle_view = true;
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
            child: Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: button_print(null, context)),
          ),
        ]),
        SizedBox(height: 10),
        textField(
            "Remarks", remarks, false, remarks.text != null ? true : false)
      ]),
    );
  }

  middle() {
    return Column(children: [
      widget_textFiled1("Product", product),
      SizedBox(height: 10),
      textField(
          "", product_name, false, product_name.text != null ? true : false),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(
            child: textField(
                "PUOM", puom, false, puom.text != null ? true : false)),
        SizedBox(width: 10.0),
        Flexible(
            child: textField(
                "LUOM", luom, false, luom.text != null ? true : false)),
      ]),
      SizedBox(height: 10),
      textField("Quantity", qty, false, qty.text != null ? true : false),
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

  widget_textFiled1(_text, _controller) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            decoration: InputDecoration(
                labelText: _text, border: const OutlineInputBorder()),
            controller: _controller,
          ),
        ),
        Flexible(
            child: Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: RaisedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => prodlist());
                    },
                    child: Text('Search'))))
      ],
    );
  }

  List _datasForDisplay = List();
  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search...'),
        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        onChanged: (text) {
          text = text.toUpperCase();
          setState(() {
            _datasForDisplay = productList.where((data) {
              var search = data['PROD_NAME'].toString().toUpperCase();
              return search.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  prodlist() {
    return AlertDialog(
      title: Text('Products'),
      content: Container(
        height: 400.0,
        width: 300.0,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _searchBar(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: [
                      DataColumn(
                          label: text("SERIAL NO", Colors.black),
                          numeric: false),
                      DataColumn(
                          label: text("PROD CODE", Colors.black),
                          numeric: false),
                      DataColumn(
                          label: text("PROD NAME", Colors.black),
                          numeric: false),
                      DataColumn(
                          label: text("PUOM", Colors.black), numeric: false),
                    ],
                    rows: productList
                        .map(
                          (product) => DataRow(cells: <DataCell>[
                            DataCell(Text(product['PROD_NAME'].toString()),
                                onTap: () {
                              setState(() {
                                product_name.text =
                                    product['PROD_NAME'].toString();
                              });
                            }),
                            DataCell(Text(product['PROD_CODE'].toString())),
                            DataCell(Text(product['STK_PUOM'].toString())),
                            DataCell(Text(product['P_UOM'].toString())),
                          ]),
                        )
                        .toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
