import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:flutter/material.dart';

class StocktransferEntry extends StatefulWidget {
  @override
  _StocktransferEntryState createState() => _StocktransferEntryState();
}

class _StocktransferEntryState extends State<StocktransferEntry> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController doc_no = TextEditingController();
  final TextEditingController zone_from = TextEditingController();
  final TextEditingController zone_to = TextEditingController();
  final TextEditingController prod_code = TextEditingController();
  final TextEditingController prod_name = TextEditingController();
  final TextEditingController puom = TextEditingController();
  final TextEditingController luom = TextEditingController();
  final TextEditingController qty_puom = TextEditingController();
  final TextEditingController qty_luom = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController bal_stock = TextEditingController();
  List _datas = List();
  List column = [
    "Prod\nCode",
    "Prod\nName",
    "PUOM",
    "Qty\nPUOM",
    "LUOM",
    "Qty\nLUOM",
  ];

  @override
  void initState() {
    setState(() {
      // bal_stock.text = "345";
      doc_no.text = gs_sales_param1;
      zone_from.text = gs_sales_param3;
      zone_to.text = gs_sales_param4;
      // print(doc_no.text + 'docno');
    });

    super.initState();
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
      // body: ListBuilderCommon(datas: _datas, toPage: null, head: true),
      body: new Padding(
        padding: new EdgeInsets.all(14.0),
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
                    child: listing(column.length, column, column),
                  )
                ],
              ),
            )),
      ),
    );
  }

  head() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
                flex: 2,
                child: textField(
                    "Doc No", doc_no, doc_no == null ? true : false, false)),
            SizedBox(
              width: 15.0,
            ),
            Flexible(
                child: IconButton(icon: Icon(Icons.build), onPressed: () {})),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        textField(
            "Zone From", zone_from, zone_to == null ? true : false, false),
        SizedBox(
          height: 15.0,
        ),
        textField("Zone To", zone_to, zone_to == null ? true : false, false),
      ],
    );
  }

  middle() {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: textField("ProductCode", prod_code,
                  prod_code == null ? true : false, false),
            ),
            SizedBox(width: 10),
            Flexible(
                child: IconButton(icon: Icon(Icons.search), onPressed: () {})),
          ],
        ),
        SizedBox(height: 10.0),
        textField(
            "ProductName", prod_name, prod_code == null ? true : false, false),
        SizedBox(height: 10.0),
        Row(
          children: [
            Flexible(child: labelWidget(Colors.black, puom, 13.0)),
            Flexible(
                child: textField("Qty Puom", qty_puom,
                    qty_puom == null ? true : false, false)),
            Flexible(child: labelWidget(Colors.black, luom, 13.0)),
            Flexible(
                child: textField("Qty Puom", qty_luom,
                    qty_luom == null ? true : false, false)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Flexible(
                child: textField("Quantity", quantity,
                    quantity == null ? true : false, false)),
            SizedBox(width: 10),
            Flexible(child: labelWidget(Colors.red[500], bal_stock, 13.0)),
          ],
        )
      ],
    );
  }

  listing(itemCount, rowlist, column) {
    return DataTable(
        columnSpacing: 25.0,
        showCheckboxColumn: false,
        columns: [
          for (int i = 0; i <= column.length - 1; i++)
            DataColumn(label: text(column[i], Colors.black))
        ],
        rows: List<DataRow>.generate(
            itemCount,
            (index) => DataRow(
                  // selected: middle_view == false,
                  onSelectChanged: (va) {
                    if (va) {
                      setState(() {});
                    }
                  },
                  cells: <DataCell>[
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                    DataCell(Text('')),
                  ],
                )));
  }
}
