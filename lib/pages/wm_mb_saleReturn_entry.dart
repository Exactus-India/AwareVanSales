import 'dart:async';
import 'dart:io';

import 'package:aware_van_sales/components/number_to_text.dart';
import 'package:aware_van_sales/data/constants.dart';
import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_salesentry.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/listing_Builder.dart';
import 'package:aware_van_sales/wigdets/salesreturnListBuilder.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';

import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:ext_storage/ext_storage.dart';

import '../wigdets/widget_rowData.dart';
import 'wm_mb_saleReturnList.dart';

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

var gs_sr_doc_no;
var gs_sr_doc_salestype;
var gs_sr_doc_date;
var gs_sr_doc_refno;

class VatAmounts {
  String name;
  String amt;
  VatAmounts(this.name, this.amt);
}

class Amounts {
  String perc;
  String asses;
  String tax;
  // String gross;
  // String vat;
  // String net;
  Amounts(this.perc, this.asses, this.tax);
  // , this.gross, this.vat, this.net);
}

class _SalesEntryCommanState extends State<SalesEntryComman> {
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
  String _translatedValue = '';
  File _image;
  String _gscurrencycode = 'AED';
  List<File> files = [];
  List salestypes = ['CASH', 'CREDIT'];
  List _datas = List();

  List _datasForDisplay = List();
  List salesreturntypes = [
    'DAMAGE',
    'WARRANTY/REPAIR',
    'DEAD ON ARRIVAL',
    'STOCK NOT MOVING'
  ];
  String selectedtype = 'CASH';
  String selected_return_type = 'DAMAGE';
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
  var amount;
  var stk_luom;
  var stk_puom;
  var doc_date;
  var net_price;
  var disc_price;
  var unit_price_amt;
  var cost_rate;
  var lcur_amt;
  var tx_id_no;
  var lcur_amt_disc;
  var tx_cmpt_perc = 5;
  var tx_cmpt_amt;
  var tx_cmpt_lcur_amt;
  bool prod_update = false;
  bool hdr = false;
  bool details_list = false;
  int ll_pqty = 0;
  int ll_lqty = 0;
  double ll_amt = 0;
  double ll_vat = 0;
  double ll_tot = 0;

  List saleslog_col = [
    "Sno",
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
    if (widget.doc_no == null) {
      customer.text = widget.ac_name;
      selectedtype = salestypes[0];
      selected_return_type = salesreturntypes[0];
      serial_no = 1;
      reflist(widget.ac_code, selectedtype);
    }
    if (widget.doc_no != null) {
      getHDR(widget.doc_no);
    }

    print(widget.party_address + "..> ");

    super.initState();
  }

  reflist(accode, selectsale_type) {
    return srReflist(accode, selectsale_type).then((value) {
      setState(() {
        search_ref_datas.clear();
        print("saleslistref" + widget.ac_code);
        search_ref_datas.addAll(value);
        list_length = search_ref_datas.length;
        print(list_length.toString() + '....');
        print(widget.ac_code + '....' + widget.party_address);
      });
    });
  }

  getHDR(docno) {
    return sr_HDR(docno).then((value) {
      setState(() {
        srHDR.clear();
        srHDR.addAll(value);
        if (srHDR[0]['SALE_TYPE'] != null)
          selectedtype = srHDR[0]['SALE_TYPE'].toString();
        selected_return_type = srHDR[0]['RETURN_TYPE'].toString();
        customer.text = srHDR[0]['PARTY_NAME'].toString();
        ref_doc_no.text = srHDR[0]['REF_DOC_NO'].toString();
        doc_type.text = srHDR[0]['REF_DOC_TYPE'].toString();
        if (srHDR[0]['REMARKS'] != null)
          remarks.text = srHDR[0]['REMARKS'].toString();
        var doc = srHDR[0]['DOC_NO'].toString();
        doc_date = srHDR[0]['DOC_DATE'].toString().split('T')[0];
        if (doc != null) doc_no.text = doc.toString();
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
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  if (doc_no.text.isNotEmpty) {
                    if (net_amt.text.isEmpty || qty.text.isEmpty)
                      updateHdr(true);
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
          SizedBox(width: 15.0),
          GestureDetector(
              onTap: () {
                setState(() {
                  if (middle_view == false) middle_view = true;
                  clearFields();
                });
              },
              child: Icon(Icons.add)),
          SizedBox(width: 15.0),
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
        padding: new EdgeInsets.all(18.0),
        child: new Form(
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
      // floatingActionButton: _getOptionInFloatingButton(),
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

  dropDown_returntype() {
    return Padding(
      padding: new EdgeInsets.only(left: 10.0),
      child: new DropdownButton(
        isExpanded: true,
        value: selected_return_type,
        onChanged: (newValue) {
          setState(() {
            selected_return_type = newValue;
          });
          print(selected_return_type);
        },
        items: salesreturntypes.map((valueItem) {
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
                        // setState(() {
                        // if (gs_list_index != null) {
                        doc_type.text = 'DN90';
                        ref_doc_no.text = gs_sr_doc_no.toString();
                        ref_no.text = gs_sr_doc_refno.toString();
                        selectedtype = gs_sr_doc_salestype;

                        // selected_return_type =
                        //     search_ref_datas[gs_list_index].val3.toString();
                        print("Accordingly");
                        fetch_products();
                        // }
                        // });
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
          Flexible(flex: 1, child: dropDown_returntype()),
          SizedBox(width: 20.0),
        ]),
        textField("Remarks", remarks, false,
            remarks.text == null ? true : false, TextAlign.left),
      ]),
    );
  }

  middle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      product_row("Product", product),
      textField("", product_name, false, true, TextAlign.left),
      SizedBox(
        height: 4,
      ),
      // _image == null
      //     ? Container(
      //         padding: EdgeInsets.all(8.0),
      //         color: Colors.red,
      //         child: text(
      //           'Image not selected',
      //           Colors.white,
      //         ),
      //       )
      //     : Row(
      //         children: [
      //           Container(
      //             child: Image.file(_image),
      //           ),
      // ElevatedButton(
      //   onPressed: () {},
      //   child: Container(
      //     padding: EdgeInsets.all(8.0),
      //     child: Icon(
      //       Icons.upload_file,
      //       color: Colors.white,
      //       size: 30.0,
      //     ),
      //   ),
      //   style: ElevatedButton.styleFrom(
      //       shape: CircleBorder(), primary: Colors.green),
      // ),
      //   ],
      // ),
      SizedBox(
        height: 4,
      ),
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

  ///=============================================================================
// dialogbox(){
//    return Column(
//       children: <Widget>[
//         Container(
//             margin: EdgeInsets.only(top: 10.0, left: 10.0),
//             child: align(Alignment.centerLeft, gs_currentUser, 20.0)),
//         _searchBar(),
//         sales_head(),

//           if (list_length == 0) noValue(),

//           Expanded(
//             child: listView(_datasForDisplay),
//           ),
//       ],
//     );
// }

// _searchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         decoration: InputDecoration(hintText: 'Search...'),
//         style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
//         onChanged: (text) {
//           text = text.toUpperCase();
//           setState(() {
//             // _datasForDisplay.clear();
//             _datasForDisplay = _datas.where((data) {
//               var search = data.search.toString().toUpperCase();
//               return search.contains(text);
//             }).toList();
//           });
//         },
//       ),
//     );
//   }

//   sales_head() {
//     return Container(
//         margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
//         child: align(Alignment.centerLeft, gs_sales_param2, 18.0));
//   }

//   listView(List datasForDisplay) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         var val3;
//         datasForDisplay[index].val3 is num
//             ? val3 = getNumberFormat(datasForDisplay[index].val3)
//             : val3 = datasForDisplay[index].val3;
//         return Card(
//           color: Colors.green[200],
//           child: ListTile(
//             subtitle: Column(
//               children: <Widget>[
//                 if (datasForDisplay[index].val1 != null)
//                   align(Alignment.centerLeft,
//                       datasForDisplay[index].val1.toString(), 14.0),
//                 if (datasForDisplay[index].val2 != null &&
//                     datasForDisplay[index].val3 != null)
//                   rowData_2(datasForDisplay[index].val2.toString(),
//                       val3.toString(), 14.0),
//                 if (datasForDisplay[index].val4 != null)
//                   align(Alignment.centerLeft,
//                       datasForDisplay[index].val4.toString(), 14.0),
//                 if (datasForDisplay[index].val5 != null)
//                   align(Alignment.centerLeft,
//                       datasForDisplay[index].val5.toString(), 14.0),
//                 if (datasForDisplay[index].val6 != null)
//                   align(Alignment.centerLeft,
//                       datasForDisplay[index].val6.toString(), 14.0),
//               ],
//             ),
//             onTap: () {
//                  gs_list_index = index;
//                 print(index.toString());
//                 print(gs_list_index.toString());
//                 doc_no = _datasForDisplay[index].val2;
//                 gs_prod_name = _datasForDisplay[index].val1;
//                 gs_puom = _datasForDisplay[index].val8;
//                 gs_stk_puom = _datasForDisplay[index].val7;
//                 gs_luom = _datasForDisplay[index].luom;
//                 gs_stk_luom = _datasForDisplay[index].stk_luom;
//                 gs_uppp = _datasForDisplay[index].uppp;
//                 gs_rate = _datasForDisplay[index].val9.toString();
//                 gs_cost_rate = _datasForDisplay[index].cost_rate;
//                 print(gs_prod_code);
//                 print(gs_rate);
//                 Navigator.of(context).pop(true);
//                 // alert(context, gs_list_index.toString(), Colors.red);

//             },
//           ),
//         );
//       },
//       itemCount: datasForDisplay.length,
//     );
//   }
// }

///////=============================================================
  refNolist() {
    reflist(widget.ac_code, selectedtype);
    list_length = search_ref_datas.length;
    return AlertDialog(
      content: Container(
        height: 400.0,
        width: 300.0,
        child: SalesReturnListingBuilder(
            datas: search_ref_datas, toPage: null, head: false, popBack: true),
      ),
    );
  }

  salesReturnDetailedlist() {
    return SingleChildScrollView(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: dataTable(
                salesdetails.length + 1, salesdetails, saleslog_col)));
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
          print("length....." + list_length.toString());

          ll_pqty = 0;
          ll_lqty = 0;
          ll_amt = 0;
          ll_vat = 0;
          ll_tot = 0;

          for (int i = 0; i < salesdetails.length; i++) {
            ll_pqty += salesdetails[i].val5.toInt();
            ll_lqty += salesdetails[i].val7.toInt();
            ll_amt += salesdetails[i].val8.toDouble();
            ll_vat += salesdetails[i].val9.toDouble();
            ll_tot += salesdetails[i].val10.toDouble();
          }
          String _translated =
              NumberToText().convert(value: double.parse(ll_tot.toString()));
          setState(() {
            _translatedValue = _translated;
          });
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
                      if (va && index != numItems) {
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
                      //sno
                      if (index != numItems - 1)
                        DataCell(Text(rowList[index].val1.toString())),
                      if (index == numItems - 1) DataCell(textBold("TOTAL")),
                      //product code
                      if (index != numItems - 1)
                        DataCell(Text(rowList[index].val2.toString())),
                      if (index == numItems - 1) DataCell(Text("")),
                      //qty
                      if (index != numItems - 1)
                        DataCell(Text(rowList[index].val5.toString())),
                      if (index == numItems - 1)
                        DataCell(textBold(ll_pqty.toString())),
                      //total
                      if (index != numItems - 1)
                        DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Text(getNumberFormat(rowList[index].val10)
                                .toString()))),
                      if (index == numItems - 1)
                        DataCell(textBold(getNumberFormat(ll_tot).toString())),
                      //prod name
                      if (index != numItems - 1)
                        DataCell(Text(rowList[index].val3.toString())),
                      if (index == numItems - 1) DataCell(Text("")),
                      //qtypuom

                      if (index != numItems - 1)
                        DataCell(Text(rowList[index].val5.toString() +
                            " " +
                            rowList[index].val4.toString())),
                      if (index == numItems - 1)
                        DataCell(textBold(ll_pqty.toString())),
                      //qty_luom
                      if (index != numItems - 1)
                        DataCell(Text(rowList[index].val7.toString() +
                            " " +
                            rowList[index].val6.toString())),
                      if (index == numItems - 1)
                        DataCell(textBold(ll_lqty.toString())),
                      //amt
                      if (index != numItems - 1)
                        DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Text(getNumberFormat(rowList[index].val8)
                                .toString()))),
                      if (index == numItems - 1)
                        DataCell(textBold(getNumberFormat(ll_amt).toString())),
                      //vat
                      if (index != numItems - 1)
                        DataCell(Align(
                            alignment: Alignment.centerRight,
                            child: Text(getNumberFormat(rowList[index].val9)
                                .toString()))),
                      if (index == numItems - 1)
                        DataCell(textBold(getNumberFormat(ll_vat).toString())),
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
                  // setState(() {
                  //   if (gs_list_index != null) {
                  prod_update = false;
                  productClick();
                  print(serial_no.toString() + "in new");
                  print(prod_update);
                  //   }
                  // });
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
    qty.clear();
    puom.clear();
    luom.clear();
    rate.clear();

    // _puom = salesproduct[gs_list_index].puom.toString();
    // _luom = salesproduct[gs_list_index].luom.toString();
    // stk_puom = salesproduct[gs_list_index].stk_puom.toString();
    // stk_luom = salesproduct[gs_list_index].stk_luom.toString();
    _puom = gs_puom;
    _luom = gs_luom;
    stk_puom = gs_stk_puom;
    stk_luom = gs_stk_luom;
    product.text = gs_prod_code;
    product_name.text = gs_prod_name;
    uppp = gs_uppp;
    cost_rate = gs_cost_rate;
    avl_qty = (stk_puom + stk_luom).toString();
    bal_stk.text = "Available Qty " + avl_qty;
    // puom.text = salesproduct[gs_list_index].qty_puom.toString();
    luom.text = gs_luom;
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
      amount = _qty * _rate;
      amt.text = getNumberFormat(_qty * _rate).toString();
      var _vat = (_rate * 0.05) * _qty;
      if (amt.text.isNotEmpty) vat.text = getNumberFormat(_vat).toString();
      net_amt.text = getNumberFormat(_amt + _vat).toString();
    }
  }

  updateHdr(_res) async {
    if (remarks.text.isNotEmpty || selectedtype != null) {
      var resp = await sr_hdr_update(
          doc_no.text,
          ref_no.text,
          selectedtype,
          doc_type.text,
          ref_doc_no.text,
          serial_no,
          remarks.text,
          selected_return_type);
      if (resp == 1) {
        setState(() {
          if (_res == true) showToast('updated Succesfully');
        });
      } else {
        alert(this.context, resp.toString(), Colors.green);
      }
    }
  }

  generate_docno() {
    return GestureDetector(
        onTap: () {
          getSRDocno().then((value) {
            setState(() {
              if (value == null)
                doc_no.text = newDocNo();
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
                      widget.ac_code,
                      selected_return_type)
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

          _puom = salesmiddleList[0].puom.toString();
          _luom = salesmiddleList[0].luom.toString();
          print(salesmiddleList.length.toString() + 'list Size');
          list_serial_no = serialno;
          uppp = salesmiddleList[0].uppp;
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

  fields_calculate() {
    String serial_no_zero;
    serial_no.toString().length == 1
        ? serial_no_zero = '0000'
        : serial_no_zero = '000';
    unit_price_amt = double.parse(rate.text);
    net_price = unit_price_amt - 0; // disc_hdr_price=0
    disc_price = ((unit_price_amt * gl_disc_perct) / 100);
    lcur_amt = amount.toDouble() * gl_EX_rate;
    lcur_amt_disc = lcur_amt;
    tx_id_no = gs_srdoc_type +
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
      updateHdr(false);
      getHDR(doc_no.text);
      updateHdr(false);
      amt.text = numberWithCommas(amt.text);
      vat.text = numberWithCommas(vat.text);
      net_amt.text = numberWithCommas(net_amt.text);
      if (luom.text.isEmpty) luom.text = '0';
      fields_calculate();
      var resp = await sr_product_insertion(
          doc_no.text,
          serial_no,
          product.text,
          product_name.text,
          _puom,
          puom.text,
          _luom,
          luom.text,
          uppp,
          qty.text,
          unit_price_amt,
          disc_price,
          net_price,
          net_amt.text,
          amt.text,
          cost_rate,
          lcur_amt,
          tx_id_no,
          lcur_amt_disc,
          tx_cmpt_perc,
          tx_cmpt_amt,
          tx_cmpt_lcur_amt,
          doc_type.text,
          ref_doc_no.text,
          selected_return_type);

      if (resp == 1) {
        // image_sequence().then((value) {
        //   nextvalue = value;
        //   imageUpload(context, _image, doc_no.text).then((value) {
        //     setState(() {
        //       clearFields();
        //       fetch_EntryDetails(doc_no.text);
        showToast('Inserted Succesfully');
        //     });
        //   });
        // });
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
      fields_calculate();
      var resp = await sr_product_updation(
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
          selected_return_type);
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
              if (prod_update == true) productCalculate();
              if (prod_update == false) {
                if (int.parse(avl_qty) >= int.parse(puom.text))
                  productCalculate();
                if (int.parse(avl_qty) < int.parse(puom.text)) {
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
    final head = ['VAT %', "Assesable Amt", "Tax Amt"];
    final headvat = ['Gross Total', getNumberFormat(ll_amt).toString()];
    final amounts = [
      Amounts("5.00", getNumberFormat(ll_amt).toString(),
          getNumberFormat(ll_vat).toString()),
      // getNumberFormat(_amt).toString(),
      // getNumberFormat(_vat).toString(),
      // getNumberFormat(_tot).toString(),
      Amounts("Total", getNumberFormat(ll_amt).toString(),
          getNumberFormat(ll_vat).toString())
    ];
    final dat =
        amounts.map((amnt) => [amnt.perc, amnt.asses, amnt.tax]).toList();
    final valamounts = [
      // VatAmounts(" ", " "),
      VatAmounts("VAT ", getNumberFormat(ll_vat).toString()),
      // VatAmounts(" ", " "),
      VatAmounts("Net Amount", getNumberFormat(ll_tot).toString())
    ];
    final vatdat =
        valamounts.map((vatamnt) => [vatamnt.name, vatamnt.amt]).toList();

    String now = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
    // ignore: deprecated_member_use
    final PdfImage assetImage = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: const AssetImage('assets/BMK.png'),
    );

    // final image = pdfLib.MemoryImage(
    //   File('assets/exactus_logo.png').readAsBytesSync(),
    // );

    // PdfImage logoImage = await pdfImageFromImageProvider(
    //     pdf: pdf.document, image: AssetImage('assets/exactus_logo.png'));
    // pdfLib.Image.provider(image)
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
                    "Island Valley Electronics L.L.C",
                    style: pdfLib.TextStyle(
                        fontSize: 18.0, fontWeight: pdfLib.FontWeight.bold),
                  ),
                  pdfLib.Text("Address :" +
                      "Office No.306,\nAl Habtoor Naif Building\nBaniyas Square\nDubai U.A.E"),
                  pdfLib.Text("Tel : " + " 04-2324747"),
                  pdfLib.Text("TRN_NO : " + "100299579100003"),
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
                  // if (printed_y.toString() == "Y")
                  // pdfLib.Center(
                  //     child: pdfLib.Text("Duplicate copy",
                  //         style: pdfLib.TextStyle(fontSize: 10.0))),
                ]),
          ),
          pdfLib.SizedBox(height: 10.0),
          pdfLib.Container(
            margin: pdfLib.EdgeInsets.all(5.0),
            padding: pdfLib.EdgeInsets.all(55.0),
            decoration: pdfLib.BoxDecoration(
                border: pdfLib.Border.all(color: PdfColors.black)),
            child: pdfLib.Column(
                crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                children: [
                  pdfLib.Text("Invoice No: " + doc_no.text),
                  pdfLib.Row(
                      mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfLib.Text("Invoice Date: " + doc_date),
                        pdfLib.Text("Ref No " + ref_no.text),
                      ]),
                  pdfLib.Row(
                      mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfLib.Text("Customer: " + customer.text),
                        pdfLib.Text("Sale Type: " + selectedtype),
                      ]),

                  pdfLib.Row(
                      mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfLib.Text("Salesman Name: " + gs_currentUser),
                        pdfLib.Text("Return Type: " + selected_return_type),
                      ]),

                  pdfLib.SizedBox(height: 20.0),
                  pdfLib.Table.fromTextArray(
                      context: context,
                      border: null,
                      // border: pdfLib.TableBorder.symmetric(
                      //     outside: pdfLib.BorderSide(
                      //         width: 1, style: pdfLib.BorderStyle.solid)),
                      headerStyle:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                      headerDecoration:
                          pdfLib.BoxDecoration(color: PdfColors.grey300),
                      data: <List<dynamic>>[
                        <String>[
                          'SNo',
                          'Product',
                          'Quantity',
                          'Rate',
                          'Amount'
                        ],
                        ...salesdetails.map((item) => [
                              item.val1.toString(),
                              item.val2.toString() +
                                  "\n" +
                                  item.val3.toString(),
                              item.val5.toString() + " " + item.val4.toString(),
                              // +
                              // " " +
                              // item.val7.toString() +
                              // " " +
                              // item.val6.toString(),
                              getNumberFormat(item.val11).toString(),
                              getNumberFormat(item.val10).toString(),
                            ])
                      ]),
                  // pdfLib.SizedBox(height: 10.0),
                  // pdfLib.Container(
                  //   width: double.infinity,
                  //   child:
                  //       pdfLib.Column(crossAxisAlignment: pdfLib.CrossAxisAlignment.end,
                  //           // mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                  //           children: [
                  //         pdfLib.Text(
                  //           "Amount(VAT Exclusive) :" +
                  //               "AED " +
                  //               getNumberFormat(ll_amt).toString(),
                  //           style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  //         ),
                  //         pdfLib.Text(
                  //           "VAT:   " + "AED " + getNumberFormat(ll_vat).toString(),
                  //           style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  //         ),
                  //         pdfLib.Text(
                  //           "Amount(VAT Inclusive) :" +
                  //               "AED " +
                  //               getNumberFormat(ll_tot).toString(),
                  //           style: pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                  //         ),
                  //         pdfLib.FittedBox(
                  //             child: pdfLib.Row(
                  //                 mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                  //                 children: [
                  //               pdfLib.Text(
                  //                 "Amount(VAT Inclusive) In words : ",
                  //                 style: pdfLib.TextStyle(
                  //                   fontWeight: pdfLib.FontWeight.bold,
                  //                 ),
                  //               ),
                  //               pdfLib.Text(
                  //                 _translatedValue,
                  //                 style: pdfLib.TextStyle(
                  //                     fontWeight: pdfLib.FontWeight.bold,
                  //                     fontSize: 9.0),
                  //               ),
                  //             ])),

                  pdfLib.Row(children: [
                    pdfLib.SizedBox(height: 180.0),
                    pdfLib.Table.fromTextArray(
                      headerStyle:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                      oddCellStyle:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                      // defaultColumnWidth: 30,
                      cellAlignment: pdfLib.Alignment.centerRight,
                      headers: head,
                      data: dat,
                    ),
                    // pdfLib.SizedBox(width: 50.0),
                    pdfLib.Table.fromTextArray(
                      headerStyle:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                      // defaultColumnWidth: 30,
                      cellAlignment: pdfLib.Alignment.centerRight,
                      cellStyle:
                          pdfLib.TextStyle(fontWeight: pdfLib.FontWeight.bold),
                      headers: headvat,
                      data: vatdat,
                    ),
                  ]),
                  pdfLib.SizedBox(height: 10.0),
                  pdfLib.Container(
                      width: double.infinity,
                      child: pdfLib.Column(
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          children: [
                            pdfLib.Text(
                              _gscurrencycode +
                                  " " +
                                  _translatedValue +
                                  " ONLY",
                              style: pdfLib.TextStyle(
                                  fontWeight: pdfLib.FontWeight.bold,
                                  fontSize: 9.0),
                            ),
                          ])),
                ]),
          ),
          // ]),
          // ),

          // ]),
          // ),

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
                      pdfLib.Text(
                          "Issued by: " + "Island Valley Electronics L.L.C"),
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
    // if (printed_y.toString() == "Y")
    fileName = "/SALES-" + doc_no.text + "-copy.pdf";
    final File file = File(path + fileName);
    // if (choice == Constants.DownloadPdf) await file.writeAsBytes(pdf.save());
    // if (choice == Constants.DownloadPdf) showToast("Downloaded to $path");
    if (choice == Constants.ViewPdf)
      Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
    if (choice == Constants.SharePdf) {
      await Printing.sharePdf(bytes: pdf.save(), filename: fileName);
      // if (printed_y == "N")
      //   setState(() {
      //     printed_y = "Y";
      //     updateHdr();
      //   });
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.ViewPdf) {
      _generatePdfAndView(choice);
    } else {
      _generatePdfAndView(choice);
    }
  }

  // Widget _getOptionInFloatingButton() {
  //   return SpeedDial(
  //     icon: Icons.camera_alt,
  //     // animatedIcon: AnimatedIcons.add_event,
  //     animatedIconTheme: IconThemeData(size: 30),
  //     backgroundColor: Color(0xFF801E48),
  //     visible: true,
  //     curve: Curves.bounceIn,
  //     children: [
  //       // FAB 1
  //       SpeedDialChild(
  //           child: Icon(Icons.camera),
  //           backgroundColor: Color(0xFF801E48),
  //           onTap: () {
  //             getimage();
  //           },
  //           label: 'Camera',
  //           labelStyle: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //               fontSize: 16.0),
  //           labelBackgroundColor: Color(0xFF801E48)),
  //       // FAB 2
  //       SpeedDialChild(
  //           child: Icon(Icons.photo_album),
  //           backgroundColor: Color(0xFF801E48),
  //           onTap: () {
  //             getimage();
  //           },
  //           label: 'Gallery',
  //           labelStyle: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //               fontSize: 16.0),
  //           labelBackgroundColor: Color(0xFF801E48))
  //     ],
  //   );
  // }

  // Future getimage() async {
  //   FilePickerResult result =
  //       await FilePicker.platform.pickFiles(allowMultiple: true);

  //   if (result != null) {
  //     setState(() {
  //       files += result.paths.map((path) => File(path)).toList();
  //     });
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // Future getimage(option) async {
  //   if (option == 'Gallery') {
  //     final image = await ImagePicker.pickImage(
  //       source: ImageSource.gallery,
  //       maxHeight: 100.0,
  //     );
  //     setState(() {
  //       _image = image as File;
  //     });
  //   } else {
  //     final image = await ImagePicker.pickImage(
  //       source: ImageSource.camera,
  //       maxHeight: 100.0,
  //     );
  //     setState(() {
  //       _image = image;
  //     });
  //   }
  // }
}
