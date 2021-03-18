import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';

class StocktransferEntry extends StatefulWidget {
  final doc_no;
  final from_zone;
  final to_zone;

  const StocktransferEntry({Key key, this.doc_no, this.from_zone, this.to_zone})
      : super(key: key);
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
  List zone_list = List();
  List zonefrom_list = List();
  String selectedZonefrom;
  String selectedZoneto;
  bool doc_generate = false;
  var serial_no;
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
    if (widget.doc_no == null) {
      serial_no = 1;
    }
    get_ST_zone().then((value) {
      setState(() {
        zone_list.addAll(value);
      });
    });
    if (widget.doc_no != null) getHDR(widget.doc_no);
    super.initState();
  }

  getHDR(docno) {
    return str_HDR(docno).then((value) {
      setState(() {
        doc_generate = true;
        strHDR.clear();
        strHDR.addAll(value);
        doc_no.text = strHDR[0]['DOC_NO'].toString();
        zone_from.text = strHDR[0]['FROM_ZONE_CODE'].toString();
        zone_to.text = strHDR[0]['TO_ZONE_CODE'].toString();
        if (strHDR[0]['REMARKS'] != null)
          remarks.text = strHDR[0]['REMARKS'].toString();
        var sn_no = strHDR[0]['LAST_DTL_SERIAL_NO'];
        if (sn_no == null || sn_no == 0) sn_no = 0;
        serial_no = sn_no + 1;
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
        title:
            Text("Stock Transfer Entry", style: TextStyle(color: Colors.white)),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
      ),
      body: new Padding(
        padding: new EdgeInsets.only(top: 14.0),
        child: new Form(
            key: _formkey,
            child: new SingleChildScrollView(
              child: Column(
                children: [
                  head(),
                  SizedBox(height: 10),
                  middle(),
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
            children: [
              Flexible(
                  flex: 2,
                  child: textField(
                      "Doc No", doc_no, false, false, TextAlign.left)),
              if (doc_generate != true) SizedBox(width: 4.0),
              if (doc_generate != true)
                Flexible(
                    child:
                        IconButton(icon: Icon(Icons.build), onPressed: () {})),
            ],
          ),
          SizedBox(height: 4),
          // widget.doc_no == null
          //     ?
          dropDown_zone_from(),
          // : textField("Zone From", zone_from,
          //     zone_to == null ? true : false, false, TextAlign.left),
          SizedBox(height: 4),
          // widget.doc_no == null
          //     ?
          dropDown_zone_to(),
          // : textField("Zone To", zone_to, zone_to == null ? true : false,
          //     false, TextAlign.left),
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
                  onPressed: () {},
                  icon: Icon(Icons.search, color: Colors.green),
                )))
      ],
    );
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
                        // selected: middle_view == false,
                        // onSelectChanged: (va) {
                        //   if (va) {
                        //     setState(() {});
                        //   }
                        // },
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

  textField(_text, _controller, _validate, read, align) {
    bool obs = false;
    if (_text == 'Password') obs = true;
    return Container(
      height: 40.0,
      child: TextField(
        textAlign: align,
        readOnly: read,
        obscureText: obs,
        onChanged: (value) {
          setState(() {
            if (_text == 'QTY PUOM') {
              // if (prod_update == true) productCalculate();
              // if (prod_update == false) {
              // if (int.parse(avl_qty) >= int.parse(puom.text))
              //   productCalculate();
              // if (int.parse(avl_qty) < int.parse(puom.text)) {
              //   alert(
              //       context, "Available Quantity " + avl_qty, Colors.orange);
              //   puom.clear();
              // }
            }
            // }
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
    puom.text = "PUOM";
    luom.text = "LUOM";
    prod_code.clear();
    prod_name.clear();
    quantity.clear();
    qty_puom.clear();
    qty_luom.clear();
    bal_stock.clear();
  }
}
