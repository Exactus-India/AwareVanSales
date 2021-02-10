import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class SalesEntry extends StatefulWidget {
  @override
  _SalesEntryState createState() => _SalesEntryState();
}

TextEditingController customer = new TextEditingController();
TextEditingController doc_no = new TextEditingController();
TextEditingController ref_no = new TextEditingController();
TextEditingController sales_type = new TextEditingController();
TextEditingController remarks = new TextEditingController();

class _SalesEntryState extends State<SalesEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Entry"),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Form(
          // key: formKey,
          autovalidate: false,
          child: new ListView(
            children: [
              widget_textFiled("Customer", customer),
              widget_textFiled("Doc_no", doc_no),
              widget_textFiled("Ref_no", ref_no),
              widget_textFiled("Sales_type", sales_type),
              widget_textFiled("Remarks", remarks),
              button_print('print', null, context),
              button_delete('delete', null, context),
              button_save('save', null, context),
              button_add('add', null, context),
            ],
          ),
        ),
      ),
    );
  }
}
