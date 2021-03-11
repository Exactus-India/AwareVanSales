import 'dart:async';
import 'dart:io';
import 'package:aware_van_sales/data/os_summ.dart';
import 'package:aware_van_sales/data/sales_Middle.dart';
import 'package:aware_van_sales/data/sales_detailList.dart';
import 'package:aware_van_sales/data/salesproducts.dart';
import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/data/salessum.dart';
import 'package:aware_van_sales/data/sr_entrydetails.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_sales.dart';
import 'package:intl/intl.dart';
import './User_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'receipt_data.dart';
import 'stock_sum_data.dart';
import 'stocktransfer.dart';

String gs_dndoc_type = 'DN90';
String gs_srdoc_type = 'SR90';
String gs_company_code = 'BSG';
var gs_date = DateFormat("dd-MMM-yyyy").format(DateTime.now());

responseerror(response) {
  String str = response.body;
  String start = '<pre>';
  String end = '</pre>';
  final startIndex = str.indexOf(start);
  final endIndex = str.indexOf(end, startIndex + start.length);
  return str.substring(startIndex + start.length, endIndex);
}

Future<List> getAllUserName() async {
  var url = 'http://exactusnet.dyndns.org:4005/api/user';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> getAllRouteName() async {
  var url = 'http://exactusnet.dyndns.org:4005/api/routes';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<int> getSerialno(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/serialno/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['SERIAL_NO'].toString() + "last serial");

  return jsonData[0]['SERIAL_NO'];
}

Future<int> getDNDocno() async {
  var url = 'http://exactusnet.dyndns.org:4005/api/sales/customerList/DN/docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['DOC_NO'].toString() + "last dnno");

  return jsonData[0]['DOC_NO'];
}

Future<List> stock_summary() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/stocksummary/$gs_company_code';
  var response = await http.get(url);
  var datas = List<StockSum>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(StockSum.fromJson(dataJson));
    }
  }
  return datas;
}

Future stock_summary_pro(datefrom, dateto) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/stksum/$gs_company_code/$datefrom/$dateto/Z01';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future sales_sum_pro() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/prosalessummary/$gs_company_code/$gs_date/$gs_currentUser_empid';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List<Salessum1>> sales_sum1() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salestype/summary01';
  var response = await http.get(url);
  var datas = List<Salessum1>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Salessum1.fromJson(dataJson));
    }
  }
  return datas;
}

Future<List<Salessum2>> sales_sum2() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salestype/summary02';
  var response = await http.get(url);
  var datas = List<Salessum2>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Salessum2.fromJson(dataJson));
    }
  }
  return datas;
}

// ldt_date_to
Future os_summary_pro() async {
  print(gs_date.toString());
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/proOS/Summary/$gs_company_code/25-JAN-2021';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List<Ossumm>> os_summary() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/OS/Summary/01';
  var response = await http.get(url);
  var datas = List<Ossumm>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Ossumm.fromJson(dataJson));
    }
  }
  return datas;
}

Future product_insertion(
    serial_no,
    prod_code,
    prod_name,
    p_uom,
    qty_puom,
    l_uom,
    qty_luom,
    amt,
    vat,
    net_amt,
    doc_no,
    dept_code,
    qty,
    unit_rate,
    curr_code) async {
  Map data = {
    "SERIAL_NO": serial_no,
    "PROD_CODE": prod_code,
    "PROD_NAME": prod_name,
    "P_UOM": p_uom,
    "QTY_PUOM": qty_puom,
    "L_UOM": l_uom,
    "QTY_LUOM": qty_luom,
    "AMOUNT": amt,
    "TX_COMPNT_AMT_1": vat,
    "NET_PRICE": net_amt,
    "DOC_NO": doc_no,
    "DOC_TYPE": gs_dndoc_type,
    "SALESMAN_CODE": gs_currentUser_empid,
    "DEPT_CODE": dept_code,
    "USER_ID": gs_currentUser,
    "QUANTITY": qty,
    "UNIT_PRICE": unit_rate,
    "CURR_CODE": curr_code,
    "COMPANY_CODE": gs_company_code
  };
  var value = json.encode(data);
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/insert';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return responseerror(response);
  }
}

Future product_updation(
  serial_no,
  qty_puom,
  qty_luom,
  amt,
  vat,
  net_amt,
  doc_no,
  qty,
  unit_rate,
) async {
  Map data = {
    "SERIAL_NO": serial_no,
    "QTY_PUOM": qty_puom,
    "QTY_LUOM": qty_luom,
    "AMOUNT": amt,
    "TX_COMPNT_AMT_1": vat,
    "NET_PRICE": net_amt,
    "DOC_NO": doc_no,
    "DOC_TYPE": gs_dndoc_type,
    "QUANTITY": qty,
    "UNIT_PRICE": unit_rate,
    "COMPANY_CODE": gs_company_code
  };
  var value = json.encode(data);
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/update';
  var response = await http.put(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return responseerror(response);
  }
}

Future docno_insert(
  party_name,
  doc_no,
  sales_type,
  ref_no,
) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_dndoc_type,
    "DOC_NO": doc_no,
    "AC_CODE": gs_ac_code,
    "PARTY_NAME": party_name,
    "PARTY_ADDRESS": gs_party_address,
    "SALESMAN_CODE": gs_currentUser_empid,
    "SALE_TYPE": sales_type,
    "USER_ID": gs_currentUser,
    "REF_NO": ref_no,
    "CURR_CODE": "AED",
  };
  var value = json.encode(data);
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/doc_no_insert';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return responseerror(response);
  }
}

Future dn_hdrUpdate(doc_no, sales_type, ref_no, remarks, serial_no) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_dndoc_type,
    "DOC_NO": doc_no,
    "SALE_TYPE": sales_type,
    "REF_NO": ref_no,
    "REMARKS": remarks,
    "LAST_DTL_SERIAL_NO": serial_no
  };
  var value = json.encode(data);
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/hdr_update';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return responseerror(response);
  }
}

Future<bool> salesDelete(serial_no, doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/delete/$serial_no/$doc_no/$gs_company_code/$gs_dndoc_type';
  var response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List> getAllSalesEntryDetails(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/DetailList/$gs_dndoc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var datas = List<SalesDetail>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(SalesDetail.fromJson(dataJson));
    }
  }
  return datas;
}

Future<List> getAllSalesEntryDetails_1(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/DetailList/$gs_dndoc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> getAllSalesHDR(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/HDR/$gs_dndoc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> salesmiddile(docno, serialno) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/Detail/$gs_dndoc_type/$gs_company_code/$docno/$serialno';
  var response = await http.get(url);
  var datas = List<Salesmiddle>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Salesmiddle.fromJson(dataJson));
    }
  }
  return datas;
}

Future<List> getAllProduct() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/search';
  var response = await http.get(url);
  var datas = List<Productlist>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Productlist.fromJson(dataJson));
    }
  }
  return datas;
}

Future<List<Customer>> customersaleslist() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/$gs_Route';
  var response = await http.get(url);
  var datas = List<Customer>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Customer.fromJson_Customer(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val2;
    var ba = b.val2;
    return ab.compareTo(ba);
  });
  return datas;
}

Future<List<Sales>> saleslist(ac_code) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesList/$gs_dndoc_type/$ac_code/$gs_currentUser_empid';
  var response = await http.get(url);
  var datas = List<Sales>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Sales.fromJson_Sales(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val2;
    var ba = b.val2;
    return ab.compareTo(ba);
  });
  return datas;
}

Future loginCheck(String uname, String pass) async {
  var url = 'http://exactusnet.dyndns.org:4005/api/user/$uname/$pass';
  try {
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    ).timeout(const Duration(milliseconds: 4500));
    var datas = List<UserData>();
    if (response.statusCode == 200) {
      Object datasJson = json.decode(response.body.substring(0));
      for (var dataJson in datasJson) {
        datas.add(UserData.fromJson(dataJson));
      }
      return 1;
    } else {
      return 2;
    }
  }
  // -----------------Server Not Responding | Server Timeout------------------
  on TimeoutException catch (e) {
    message = "Server Not Responding ";
    return null;
  }
  // -----------------Socket exception | No Internet------------------
  on SocketException catch (e) {
    return 0;
  }
}

Future<List<Customer>> customersalesReturnlist() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales_return/customerList/$gs_Route';
  var response = await http.get(url);
  var datas = List<Customer>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Customer.fromJson_CustomerReturns(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val2;
    var ba = b.val2;
    return ab.compareTo(ba);
  });
  return datas;
}

Future<List<Sales>> salesReturnlist(ac_code) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesListReturn/$gs_srdoc_type/$ac_code/$gs_currentUser_empid';
  var response = await http.get(url);
  var datas = List<Sales>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Sales.fromJson_Sales(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val2;
    var ba = b.val2;
    return ab.compareTo(ba);
  });
  return datas;
}

Future srno_insert(party_name, doc_no, sales_type, ref_no, ref_docno,
    ref_doctype, party_address, ac_code) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_srdoc_type,
    "DOC_NO": doc_no,
    "AC_CODE": ac_code,
    "PARTY_NAME": party_name,
    "PARTY_ADDRESS": party_address,
    "SALESMAN_CODE": gs_currentUser_empid,
    "SALE_TYPE": sales_type,
    "USER_ID": gs_currentUser,
    "REF_NO": ref_no,
    "CURR_CODE": "AED",
    "ref_doc_no": ref_docno,
    "ref_doc_type": ref_doctype,
  };
  var value = json.encode(data);
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR/doc_no_insert';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return null;
  }
}

Future<int> getSRDocno() async {
  var url = 'http://exactusnet.dyndns.org:4005/api/sales/customerList/SR/docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['DOC_NO'].toString() + "last dnno");

  return jsonData[0]['DOC_NO'];
}

Future<List> sr_HDR(docno) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR_return/HDR/$gs_srdoc_type/$gs_company_code/$docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<int> getSRSerialno(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR/serialno/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['SERIAL_NO'].toString() + "last serial");

  return jsonData[0]['SERIAL_NO'];
}

Future sr_product_insertion(
    serial_no,
    prod_code,
    prod_name,
    p_uom,
    qty_puom,
    l_uom,
    qty_luom,
    amt,
    vat,
    net_amt,
    doc_no,
    dept_code,
    qty,
    unit_rate,
    curr_code,
    ref_doctype,
    ref_docno) async {
  Map data = {
    "SERIAL_NO": serial_no,
    "PROD_CODE": prod_code,
    "PROD_NAME": prod_name,
    "P_UOM": "PCS",
    "QTY_PUOM": qty_puom,
    "L_UOM": "PCS",
    "QTY_LUOM": qty_luom,
    "AMOUNT": amt,
    "TX_COMPNT_AMT_1": vat,
    "NET_PRICE": net_amt,
    "DOC_NO": doc_no,
    "DOC_TYPE": gs_srdoc_type,
    "SALESMAN_CODE": gs_currentUser_empid,
    "DEPT_CODE": dept_code,
    "USER_ID": gs_currentUser,
    "QUANTITY": qty,
    "UNIT_PRICE": unit_rate,
    "CURR_CODE": curr_code,
    "COMPANY_CODE": gs_company_code,
    "REF_DOC_TYPE": ref_doctype,
    "REF_DOC_NO": ref_docno
  };
  var value = json.encode(data);
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR/insert';
  var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return null;
  }
}

Future<bool> sr_salesDelete(serial_no, doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR/delete/$serial_no/$doc_no/$gs_company_code/$gs_srdoc_type';
  var response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List> getAllSalesSR_EntryDetails(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR_returnDetailList/$gs_srdoc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var datas = List<SRSalesDetail>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(SRSalesDetail.fromJson(dataJson));
    }
  }
  return datas;
}

Future<List> sr_salesmiddile(docno, serialno) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR_return/middle/$gs_srdoc_type/$gs_company_code/$docno/$serialno';
  var response = await http.get(url);
  var datas = List<SRSalesmiddle>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(SRSalesmiddle.fromJson(dataJson));
    }
  }
  return datas;
}

Future<List> getAllSRProduct(ref_doc_type, ref_doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesSR/product_search/$ref_doc_type/$gs_company_code/$ref_doc_no';
  var response = await http.get(url);
  var datas = List<Productlist>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Productlist.fromJsonSR(dataJson));
    }
  }
  return datas;
}

Future<List<Receipt>> receipt() async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/receipt/$gs_currentUser_empid';
  var response = await http.get(url);
  var datas = List<Receipt>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Receipt.fromJson(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val2;
    var ba = b.val2;
    return ab.compareTo(ba);
  });
  return datas;
}

Future<List<StockTransfer>> stocktransfer() async {
  var url = 'http://exactusnet.dyndns.org:4005/api/sales/stock_transfer/STR';
  var response = await http.get(url);
  var datas = List<StockTransfer>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(StockTransfer.fromJson(dataJson));
    }
  }

  return datas;
}
