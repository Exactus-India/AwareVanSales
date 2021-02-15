import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_sales.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesEntry extends StatefulWidget {
  final String doc_no;
  final int index;

  const SalesEntry({Key key, this.doc_no, this.index}) : super(key: key);
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

  @override
  void initState() {
    if (widget.doc_no == null && sales_customer_name != null)
      customer.text = sales_customer_name;
    if (widget.doc_no != null)
      getAllSalesHDR(widget.doc_no).then((value) {
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
            // key: formKey,
            child: new SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              head(),
              SizedBox(height: 10),
              if (middle_view == true)
                middle(),
              // bottomList(),
              // bottom_list_head(),
              Table(
                children: [],
              )
            ],
          ),
        )),
      ),
    );
  }

  head() {
    return Container(
      child: Column(children: [
        textField("Customer", customer, false),
        SizedBox(height: 12),
        Row(children: <Widget>[
          Flexible(child: textField("Doc_no", doc_no, false)),
          if (doc_no.text.isEmpty)
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: button_generate(null, context)),
            ),
        ]),
        SizedBox(height: 10),
        textField("Ref_no", ref_no, false),
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
        textField("Remarks", remarks, false)
      ]),
    );
  }

  middle() {
    return Column(children: [
      widget_textFiled1("Product", product, Icons.search, null),
      SizedBox(height: 10),
      textField("", product_name, false),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(child: textField("PUOM", puom, false)),
        SizedBox(width: 10.0),
        Flexible(child: textField("LUOM", luom, false)),
      ]),
      SizedBox(height: 10),
      textField("Quantity", qty, false),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(child: textField("Unit rate ", rate, false)),
        SizedBox(width: 10.0),
        Flexible(child: textField('Amount', rate, false)),
      ]),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Flexible(child: textField("VAT", vat, false)),
        SizedBox(width: 10.0),
        Flexible(child: textField("Net Amount", net_amt, false)),
      ]),
    ]);
  }

  // bottomList() {
  //   return FutureBuilder(
  //     future: getAllSalesEntryDetails(widget.doc_no),
  //     builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //       return ListView(
  //         children: snapshot.data
  //             .map((u) => ListTile(
  //                   title: Column(
  //                       children: <Widget>[Text(u['SERIAL_NO'].toString())]),
  //                   onTap: () {},
  //                 ))
  //             .toList(),
  //       );
  //     },
  //   );
  // }

}
