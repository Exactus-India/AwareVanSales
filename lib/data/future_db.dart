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

String ip_port = "http://exactusnet.dyndns.org:4005/api";
String gs_dndoc_type = 'DN90';
String gs_srdoc_type = 'SR90';
String gs_company_code = 'BSG';
String gs_curr = 'AED';
String gs_dept_code = 'DC';
String gs_cancelled = 'N';
String gs_zonecode;
int gl_Div_code = 10;
int gl_EX_rate = 1;
int gl_disc_perct = 0;
int gl_tx_cat_code = 31;
int gl_tx_comcat_amt = 13100;
int gl_tx_compt_hdisc_amt = 0;
int gl_tx_compt_hdisc_lcur_amt = 0;
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
  var url = '${ip_port}/user';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> get_user_zonecode() async {
  var url = '${ip_port}/user/zone_code/$gs_company_code/$gs_currentUser_empid';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> getAllRouteName() async {
  var url = '${ip_port}/routes';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<int> getSerialno(doc_no) async {
  var url = '${ip_port}/sales/customerList/salesDN/serialno/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['SERIAL_NO'].toString() + "last serial");

  return jsonData[0]['SERIAL_NO'];
}

Future<int> getDNDocno() async {
  var url = '${ip_port}/sales/customerList/DN/docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['DOC_NO'].toString() + "last dnno");

  return jsonData[0]['DOC_NO'];
}

Future<List> stock_summary() async {
  var url = '${ip_port}/sales/customerList/stocksummary/$gs_company_code';
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
      '${ip_port}/sales/customerList/stksum/$gs_company_code/$datefrom/$dateto/Z01';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future sales_sum_pro(date, empid) async {
  var url =
      '${ip_port}/sales/customerList/prosalessummary/$gs_company_code/$date/$empid';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List<Salessum1>> sales_sum1() async {
  var url = '${ip_port}/sales/customerList/salestype/summary01';
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
  var url = '${ip_port}/sales/customerList/salestype/summary02';
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
      '${ip_port}/sales/customerList/proOS/Summary/$gs_company_code/25-JAN-2021';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List<Ossumm>> os_summary() async {
  var url = '${ip_port}/sales/customerList/OS/Summary/01';
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
    doc_no,
    serial_no,
    prod_code,
    prod_name,
    p_uom,
    qty_puom,
    l_uom,
    qty_luom,
    uppp,
    qty,
    net_price,
    disc_price,
    unitprice_amt,
    amt,
    cost_rate,
    lcur_amt,
    sign_ind,
    tx_id_no,
    lcur_amt_disc,
    tx_cmpt_perc,
    tx_cmpnt_amt,
    tx_cmpnt_lcur_amt,
    unit_price) async {
  print(unit_price);
  Map data = {
    "DOC_NO": doc_no,
    "DOC_TYPE": gs_dndoc_type,
    "COMPANY_CODE": gs_company_code,
    "DIV_CODE": gl_Div_code,
    "DEPT_CODE": gs_dept_code,
    "SERIAL_NO": serial_no,
    "PROD_CODE": prod_code,
    "PROD_NAME": prod_name,
    "P_UOM": p_uom,
    "QTY_PUOM": qty_puom,
    "L_UOM": l_uom,
    "QTY_LUOM": qty_luom,
    "UPPP": uppp,
    "QUANTITY": qty,
    "NET_PRICE": net_price,
    "DISC_PERC": gl_disc_perct,
    "DISC_PRICE": disc_price,
    "UNIT_PRICE_NET": unitprice_amt,
    "AMOUNT": amt,
    "COST_RATE": cost_rate,
    "CURR_CODE": gs_curr,
    "EX_RATE": gl_EX_rate,
    "LCUR_AMT": lcur_amt,
    "SIGN_IND": sign_ind,
    "SALESMAN_CODE": gs_currentUser_empid,
    "CANCELLED": gs_cancelled,
    "USER_ID": gs_currentUser,
    "TX_IDENTITY_NO": tx_id_no,
    "ZONE_CODE": gs_zonecode,
    "LCUR_AMT_DISC": lcur_amt_disc,
    "TAX_CAT_CODE": gl_tx_cat_code,
    "TAX_CMPCAT_CODE": gl_tx_comcat_amt,
    "TAX_CMPNT_PERC_1": tx_cmpt_perc,
    "TX_COMPNT_AMT_1": tx_cmpnt_amt,
    "TX_COMPNT_LCUR_AMT_1": tx_cmpnt_lcur_amt,
    "TX_COMPNT_HDISC_AMT_1": gl_tx_compt_hdisc_amt,
    "TX_COMPNT_HDISC_LCUR_AMT_1": gl_tx_compt_hdisc_lcur_amt,
    "UNIT_PRICE": unit_price
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/customerList/salesDN/insert';
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
    list_serial_no,
    doc_no,
    qty_puom,
    qty_luom,
    qty,
    net_price,
    disc_price,
    unit_price_amt,
    amount,
    lcur_amt,
    lcur_amt_disc,
    tx_cmpt_perc,
    tx_cmpt_amt,
    tx_cmpt_lcur_amt) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_dndoc_type,
    "LST_SERIAL_NO": list_serial_no,
    "DOC_NO": doc_no,
    "QTY_PUOM": qty_puom,
    "QTY_LUOM": qty_luom,
    "QUANTITY": qty,
    "NET_PRICE": net_price,
    "DISC_PRICE": disc_price,
    "UNIT_PRICE_AMT": unit_price_amt,
    "AMOUNT": amount,
    "LCUR_AMT": lcur_amt,
    "LCUR_AMT_DISC": lcur_amt_disc,
    "TAX_CMPNT_PERC_1": tx_cmpt_perc,
    "TX_COMPNT_AMT_1": tx_cmpt_amt,
    "TX_COMPNT_LCUR_AMT_1": tx_cmpt_lcur_amt
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/customerList/salesDN/update';
  var response = await http.put(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: value);

  if (response.statusCode == 200) {
    return 1;
  } else {
    return "Error";
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
    "CURR_CODE": gs_curr,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/customerList/salesDN/doc_no_insert';
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
  var url = '${ip_port}/sales/customerList/salesDN/hdr_update';
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

Future<bool> salesDelete(serial_no, doc_no) async {
  var url =
      '${ip_port}/sales/customerList/salesDN/delete/$serial_no/$doc_no/$gs_company_code/$gs_dndoc_type';
  var response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List> getAllSalesEntryDetails(doc_no) async {
  var url =
      '${ip_port}/sales/customerList/salesDN/DetailList/$gs_dndoc_type/$gs_company_code/$doc_no';
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
      '${ip_port}/sales/customerList/salesDN/DetailList/$gs_dndoc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> getAllSalesHDR(doc_no) async {
  var url =
      '${ip_port}/sales/customerList/salesDN/HDR/$gs_dndoc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> salesmiddile(docno, serialno) async {
  var url =
      '${ip_port}/sales/customerList/salesDN/Detail/$gs_dndoc_type/$gs_company_code/$docno/$serialno';
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
  var url = '${ip_port}/sales/customerList/salesDN/search_prod/$gs_zonecode';
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
  var url = '${ip_port}/sales/customerList/$gs_Route';
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
      '${ip_port}/sales/customerList/salesList/$gs_dndoc_type/$ac_code/$gs_currentUser_empid';
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
    return ba.compareTo(ab);
  });
  return datas;
}

Future loginCheck(String uname, String pass) async {
  var url = '${ip_port}/user/$uname/$pass';
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
  var url = '${ip_port}/sales_return/customerList/$gs_Route';
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
      '${ip_port}/sales/customerList/salesListReturn/$gs_srdoc_type/$ac_code/$gs_currentUser_empid';
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
    return ba.compareTo(ab);
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
    "CURR_CODE": gs_curr,
    "ref_doc_no": ref_docno,
    "ref_doc_type": ref_doctype,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/customerList/salesSR/doc_no_insert';
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
  var url = '${ip_port}/sales/customerList/SR/docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['DOC_NO'].toString() + "last dnno");

  return jsonData[0]['DOC_NO'];
}

Future<List> sr_HDR(docno) async {
  var url =
      '${ip_port}/sales/customerList/salesSR_return/HDR/$gs_srdoc_type/$gs_company_code/$docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<int> getSRSerialno(doc_no) async {
  var url = '${ip_port}/sales/customerList/salesSR/serialno/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['SERIAL_NO'].toString() + "last serial");

  return jsonData[0]['SERIAL_NO'];
}

Future sr_product_insertion(
  doc_no,
  serial_no,
  prod_code,
  prod_name,
  p_uom,
  qty_puom,
  l_uom,
  qty_luom,
  uppp,
  qty,
  unit_rate,
  disc_price,
  unit_rate_net,
  net_amt,
  amt,
  cost_rate,
  lcur_amt,
  tx_id_no,
  lcur_amt_disc,
  tx_cmpnt_perc,
  tx_cmpnt_amt_1,
  tx_cmpnt_lcur_amt,
  ref_doctype,
  ref_docno,
) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_srdoc_type,
    "DOC_NO": doc_no,
    "DIV_CODE": gl_Div_code,
    "DEPT_CODE": gs_dept_code,
    "SERIAL_NO": serial_no,
    "PROD_CODE": prod_code,
    "PROD_NAME": prod_name,
    "P_UOM": p_uom,
    "QTY_PUOM": qty_puom,
    "L_UOM": l_uom,
    "QTY_LUOM": qty_luom,
    "UPPP": uppp,
    "QUANTITY": qty,
    "UNIT_PRICE": unit_rate,
    "DISC_PERC": gl_disc_perct,
    "DISC_PRICE": disc_price,
    "UNIT_PRICE_NET": unit_rate_net,
    "NET_PRICE": net_amt,
    "AMOUNT": amt,
    "COST_RATE": cost_rate,
    "CURR_CODE": gs_curr,
    "EX_RATE": gl_EX_rate,
    "LCUR_AMOUNT": lcur_amt,
    "SIGN_IND": 1,
    "SALESMAN_CODE": gs_currentUser_empid,
    "USER_ID": gs_currentUser,
    "TX_IDENTITY_NUMBER": tx_id_no,
    "ZONE_CODE": gs_zonecode,
    "LCUR_AMOUNT_DISCOUNTED": lcur_amt_disc,
    "TX_CAT_CODE": gl_tx_cat_code,
    "TX_COMPNTCAT_CODE_1": gl_tx_comcat_amt,
    "TX_COMPNT_PERC_1": tx_cmpnt_perc,
    "TX_COMPNT_AMT_1": tx_cmpnt_amt_1,
    "CANCELLED": gs_cancelled,
    "TX_COMPNT_LCUR_AMT_1": tx_cmpnt_lcur_amt,
    "ref_doc_type": ref_doctype,
    "ref_doc_no": ref_docno,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/customerList/salesSR/insert';
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

Future sr_product_updation(
    list_serial_no,
    doc_no,
    qty_puom,
    qty_luom,
    qty,
    net_price,
    disc_price,
    unit_price_amt,
    amount,
    lcur_amt,
    lcur_amt_disc,
    tx_cmpt_perc,
    tx_cmpt_amt,
    tx_cmpt_lcur_amt) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_srdoc_type,
    "LST_SERIAL_NO": list_serial_no,
    "DOC_NO": doc_no,
    "QTY_PUOM": qty_puom,
    "QTY_LUOM": qty_luom,
    "QUANTITY": qty,
    "NET_PRICE": net_price,
    "DISC_PRICE": disc_price,
    "UNIT_PRICE_AMT": unit_price_amt,
    "AMOUNT": amount,
    "LCUR_AMT": lcur_amt,
    "LCUR_AMT_DISC": lcur_amt_disc,
    "TAX_CMPNT_PERC_1": tx_cmpt_perc,
    "TX_COMPNT_AMT_1": tx_cmpt_amt,
    "TX_COMPNT_LCUR_AMT_1": tx_cmpt_lcur_amt
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/customerList/salesSR/prod_update';
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

Future sr_hdr_update(doc_no, ref_no, salestype, ref_doctype, ref_docno,
    lst_dtl_serial_no, remarks) async {
  Map data = {
    "DOC_NO": doc_no,
    "DOC_TYPE": gs_srdoc_type,
    "COMPANY_CODE": gs_company_code,
    "REF_DOC_TYPE": ref_doctype,
    "REF_DOC_NO": ref_docno,
    "LAST_DTL_SERIAL_NO": lst_dtl_serial_no,
    "REMARKS": remarks,
    "SALE_TYPE": salestype,
    "REF_NO": ref_no
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales_return/customerList/salesSR/sr_hdr/update';
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

Future<bool> sr_salesDelete(serial_no, doc_no) async {
  var url =
      '${ip_port}/sales/customerList/salesSR/delete/$serial_no/$doc_no/$gs_company_code/$gs_srdoc_type';
  var response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List> getAllSalesSR_EntryDetails(doc_no) async {
  var url =
      '${ip_port}/sales/customerList/salesSR_returnDetailList/$gs_srdoc_type/$gs_company_code/$doc_no';
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
      '${ip_port}/sales/customerList/salesSR_return/middle/$gs_srdoc_type/$gs_company_code/$docno/$serialno';
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
      '${ip_port}/sales/customerList/salesSR/product_search/$ref_doc_type/$gs_company_code/$ref_doc_no';
  var response = await http.get(url);
  var datas = List<SR_Productlist>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(SR_Productlist.fromJsonSR(dataJson));
    }
  }
  return datas;
}

Future<List<Receipt>> receipt() async {
  var url = '${ip_port}/sales/receipt/$gs_currentUser_empid';
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
  var url = '${ip_port}/sales/stock_transfer/STR';
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
