import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:http/http.dart' as http;

import 'Rec_inv_list.dart';
import 'os_summ.dart';
import 'sales_Middle.dart';
import 'sales_detailList.dart';
import 'salesproducts.dart';
import 'sales_customer.dart';
import 'salessum.dart';
import 'sr_entrydetails.dart';
import '../pages/wm_mb_LoginPage.dart';
import '../pages/wm_mb_sales.dart';
import 'package:intl/intl.dart';
import './User_data.dart';
import 'ST_DetailList.dart';
import 'receipt_data.dart';
import 'stock_sum_data.dart';
import 'stocktransfer.dart';

String ip_port = "http://exactusnet.dyndns.org:4005/api";
String gs_dndoc_type = 'DN90';
String gs_srdoc_type = 'SR90';
String gs_strdoc_type = 'STR';
String gs_recdoc_type = 'CR';
String gs_company_code = 'BSG';
String gs_curr = 'AED';
String gs_dept_code = 'DC';
String gs_cancelled = 'N';
String gs_confirmed = 'N';
String gs_rec_doctype = 'CR';
String gs_ind_org = 'N';
String gs_pdc_ind = 'N';
String gs_discount_prod = 'DSQ20';
String gs_zonecode;
var gl_ac_cash;
int gl_Div_code = 10;
int gl_EX_rate = 1;
int gl_disc_perct = 0;
int gl_sr_sign_ind = 1;
int gl_dn_sign_ind = -1;
int gl_tx_cat_code = 31;
int gl_tx_comcat_amt = 13100;
int gl_tx_compt_hdisc_amt = 0;
int gl_tx_compt_hdisc_lcur_amt = 0;
int gl_rec_hdr_sno = 9001;
int gl_amt_org = 0;
var gs_date = DateFormat("dd-MMM-yyyy").format(DateTime.now());
var gs_doc_date = DateFormat("dd-MMM-yyyy").add_jms().format(DateTime.now());
var gs_sys_date = DateFormat("dd-MMM-yyyy").format(DateTime.now());
var gs_date_login = DateFormat("yy.MMM.dd").format(DateTime.now());
var gs_date_to =
    DateFormat("dd-MMM-yyyy").format(DateTime.now().add(Duration(days: 1)));

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
  try {
    var response = await http.get(url);
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody.substring(0));
    return jsonData;
  } catch (e) {
    showToast(e.toString());
  }
}

Future<List> get_user_zonecode() async {
  var url = '${ip_port}/user/zone_code/$gs_company_code/$gs_currentUser_empid';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> get_ST_zone() async {
  var url = '${ip_port}/zoneto';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> getAllRouteName() async {
  var url = '${ip_port}/routes';
  try {
    var response = await http.get(url);
    var jsonBody = response.body;
    var jsonData = json.decode(jsonBody.substring(0));
    return jsonData;
  } catch (e) {
    showToast(e.toString());
  }
}

// Future<int> getSerialno(doc_no) async {
//   var url = '${ip_port}/sales/customerList/salesDN/serialno/$doc_no';
//   var response = await http.get(url);
//   var jsonBody = response.body;
//   var jsonData = json.decode(jsonBody.substring(0));
//   print(jsonData[0]['SERIAL_NO'].toString() + "last serial");

//   return jsonData[0]['SERIAL_NO'];
// }

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
      '${ip_port}/sales/customerList/stksum/$gs_company_code/$datefrom/$dateto/$gs_zonecode';
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
      '${ip_port}/sales/customerList/proOS/Summary/$gs_company_code/$gs_date';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List<Ossumm>> os_summary() async {
  var url = '${ip_port}/sales/customerList/OS/Summary/01/$gs_currentUser';
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

Future dn_hdrUpdate(
    doc_no, sales_type, ref_no, remarks, serial_no, printed_y) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_dndoc_type,
    "DOC_NO": doc_no,
    "SALE_TYPE": sales_type,
    "REF_NO": ref_no,
    "REMARKS": remarks,
    "LAST_DTL_SERIAL_NO": serial_no,
    "PRINTED_Y": printed_y
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

// Future<List> getAllSalesEntryDetails_1(doc_no) async {
//   var url =
//       '${ip_port}/sales/customerList/salesDN/DetailList/$gs_dndoc_type/$gs_company_code/$doc_no';
//   var response = await http.get(url);
//   var jsonBody = response.body;
//   var jsonData = json.decode(jsonBody.substring(0));
//   return jsonData;
// }

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

Future<List> getAllSTRProduct(from_zonecode) async {
  var url = '${ip_port}/sales/customerList/salesDN/search_prod/$from_zonecode';
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

Future<int> discount_product(prod_code, qty) async {
  var url =
      '${ip_port}/sales/customerList/salesDN/product/discount/$gs_discount_prod/$prod_code/$qty';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['unit_price'].toString() + "dicount prod");

  return jsonData[0]['unit_price'];
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

Future<List<Sales>> srReflist(ac_code, salestype) async {
  var url =
      '${ip_port}/sales/customerList/salesReturnRef/$gs_dndoc_type/$ac_code/$gs_currentUser_empid/$salestype';
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

Future<int> getRecDocno() async {
  var url = '${ip_port}/sales/REC/max_docno';
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

Future<List> rec_inv_Table(accode) async {
  var url = '${ip_port}/sales/receipt/middle/$accode';
  var response = await http.get(url);
  var datas = List<Rec_InvList>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Rec_InvList.fromJson(dataJson));
    }
  }
  return datas;
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

Future<List> receipt_HDR(doc_type, doc_no) async {
  var url =
      '${ip_port}/sales/receipt/header/$gs_rec_doctype/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List<StockTransfer>> stocktransfer() async {
  var url = '${ip_port}/sales/stock_transfer/$gs_strdoc_type/$gs_currentUser';
  var response = await http.get(url);
  var datas = List<StockTransfer>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(StockTransfer.fromJson(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val4;
    var ba = b.val4;
    return ba.compareTo(ab);
  });

  return datas;
}

Future<List> str_HDR(docno) async {
  var url =
      '${ip_port}/sales/stock_transfer/header/$gs_company_code/$gs_strdoc_type/$docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> stocktransferDetailList(doc_no) async {
  print(doc_no + "future");
  var url = '${ip_port}/sales/stock_transfer/last/$gs_company_code/STR/$doc_no';
  var response = await http.get(url);
  var datas = List<ST_detail_list>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(ST_detail_list.fromJson(dataJson));
    }
  }
  datas.sort((a, b) {
    var ab = a.val1;
    var ba = b.val1;
    return ab.compareTo(ba);
  });
  return datas;
}

Future<bool> dnConfirmDirect(docno) async {
  var url =
      '${ip_port}/sales/customerList/salesDN/pro_insert/$gs_company_code/$gs_dndoc_type/$docno/$gl_Div_code';
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<int> getSTDocno() async {
  var url = '${ip_port}/sales/ST/max_docno';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  print(jsonData[0]['DOC_NO'].toString() + "last dnno");

  return jsonData[0]['DOC_NO'];
}

Future st_docno_insert(docno, remarks, from_zone, to_zone, hdr_lst_serialno,
    det_lst_serialno) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_strdoc_type,
    "DOC_NO": docno,
    // "DOC_DATE": doc_date,
    "DIV_CODE": gl_Div_code,
    "REMARKS": remarks,
    "CANCELLED": gs_cancelled,
    // "CANCELLED_DT": DateTime.now(),
    "CONFIRMED": gs_confirmed,
    // "CONFIRMED_BY": "",
    // "CONFIRMED_DT": "",
    "FROM_ZONE_CODE": from_zone,
    "TO_ZONE_CODE": to_zone,
    "ISSUED_BY": gs_currentUser_empid,
    // "RECEIVED_BY": "",
    "USER_ID": gs_currentUser,
    // "USER_DT": "",
    // "JOB_NO": "",
    "DEPT_CODE": gs_dept_code,
    // "REF_DOC_NO": "",
    // "AC_CODE": "",
    // "REF_DATE": "",
    "CURR_CODE": gs_curr,
    // "REF_DOC_TYPE": "",
    "EX_RATE": gl_EX_rate,
    // "REF_NO": "",
    "LAST_SERIAL_NO": hdr_lst_serialno,
    "LAST_DTL_SERIAL_NO": det_lst_serialno
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/ST/doc_insertion';
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

Future st_HDR_update(
    docno, remarks, from_zone, to_zone, det_lst_serialno) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_strdoc_type,
    "DOC_NO": docno,
    "REMARKS": remarks,
    "FROM_ZONE_CODE": from_zone,
    "TO_ZONE_CODE": to_zone,
    "LAST_DTL_SERIAL_NO": det_lst_serialno
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/ST/HDR/update';
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

Future st_prod_insert(
  docno,
  doc_date,
  sno,
  prod_code,
  prod_name,
  p_uom,
  qty_puom,
  l_uom,
  qty_luom,
  uppp,
  qty,
  cost_rate,
  fromzone,
  tozone,
  tx_id_no,
  unit_price,
) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_strdoc_type,
    "DOC_NO": docno,
    "DIV_CODE": gl_Div_code,
    "DEPT_CODE": gs_dept_code,
    "SERIAL_NO": sno,
    "PROD_CODE": prod_code,
    "PROD_NAME": prod_name,
    "P_UOM": p_uom,
    "QTY_PUOM": qty_puom,
    "L_UOM": l_uom,
    "QTY_LUOM": qty_luom,
    "UPPP": uppp,
    "QUANTITY": qty,
    "COST_RATE": cost_rate,
    "SIGN_IND": "",
    "USER_ID": gs_currentUser_empid,
    "TX_IDENTITY_NUMBER": tx_id_no,
    "FROM_ZONE_CODE": fromzone,
    "TO_ZONE_CODE": tozone,
    "UNIT_PRICE": unit_price,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/ST/prod_insert';
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

Future<List> st_middle_view(docno, serialno) async {
  var url =
      '${ip_port}/sales/stock_transfer/middle/$gs_company_code/$gs_strdoc_type/$docno/$serialno';
  var response = await http.get(url);
  var datas = List<ST_middle>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(ST_middle.fromJson(dataJson));
    }
  }
  return datas;
}

Future st_prod_update(serial_no, doc_no, qty_puom, qty_luom, qty) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_NO": doc_no,
    "DOC_TYPE": gs_strdoc_type,
    "SERIAL_NO": serial_no,
    "QTY_PUOM": qty_puom,
    "QTY_LUOM": qty_luom,
    "QTY": qty,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/ST/ProdUpt';
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

Future<bool> st_prod_Delete(serial_no, doc_no) async {
  var url =
      '${ip_port}/sales/ST/Prod/Delete/$gs_company_code/$gs_strdoc_type/$doc_no/$serial_no';
  var response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return responseerror(response.toString());
  }
}

Future<bool> st_pro(doc_no) async {
  var url =
      '${ip_port}/sales/stock_transfer/pro/$gs_company_code/$gs_strdoc_type/$doc_no';
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future rec_docno_insert(
    doc_no, remarks, amt, lcur_amt, snno, ac_code, sign_ind) async {
  print(gl_ac_cash);
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_rec_doctype,
    "DOC_NO": doc_no,

    "SERIAL_NO": snno,
    "AC_CODE": ac_code,
    "DIV_CODE": gl_Div_code,
    "HEADER_AC_CODE": gl_ac_cash,
    "BANK_AC_CODE": ' ',
    // "CHEQUE_NO": ' ',
    // "CHEQUE_DATE": ' ',
    "CURR_CODE": gs_curr,
    "EX_RATE": gl_EX_rate,
    "REMARKS": remarks,
    "AMOUNT": amt,
    "LCUR_AMT": lcur_amt,
    "SIGN_IND": sign_ind,
    "PDC_IND": 'N',
    "CREATE_USER": gs_currentUser,
    "CANCELLED": gs_cancelled,
    "RECON_IND": "N"
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/REC/ac_detail/insert';
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

Future rec_inv_det_insert(docno, sno, dtl_sr_no, ac_code, inv_no, amount,
    lcur_amount, sign_ind) async {
  print(dtl_sr_no);
  print(gs_date);
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_recdoc_type,
    "DOC_NO": docno,
    "SERIAL_NO": sno,
    "DTL_SR_NO": dtl_sr_no,
    "AC_CODE": ac_code,
    "DIV_CODE": gl_Div_code,
    "INV_NO": inv_no,
    "CURR_CODE": gs_curr,
    "EX_RATE": gl_EX_rate,
    "AMOUNT": amount,
    "LCUR_AMOUNT": lcur_amount,
    "SIGN_IND": sign_ind,
    "IND_ORG": gs_ind_org,
    "EX_RATE_ORG": gl_EX_rate,
    "CURR_CODE_ORG": gs_curr,
    "AMOUNT_ORG": gl_amt_org,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/Rec/ac_inv_det/insert';
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

Future rec_ac_hdr_insert(
    docno, remarks, ref_no, ac_payee, ac_code, lst_dtl_sr_no) async {
  Map data = {
    "COMPANY_CODE": gs_company_code,
    "DOC_TYPE": gs_recdoc_type,
    "DOC_NO": docno,
    "DIV_CODE": gl_Div_code,
    "DEPT_CODE": gs_dept_code,
    "REMARKS": remarks,
    "REF_NO": ref_no,
    "AC_PAYEE": ac_payee,
    "AC_CODE": ac_code,
    "CURR_CODE": gs_curr,
    "EX_RATE": gl_EX_rate,
    "SALESMAN_CODE": gs_currentUser_empid,
    "LAST_DTL_SERIAL_NO": lst_dtl_sr_no,
    "CREATE_USER": gs_currentUser,
  };
  var value = json.encode(data);
  var url = '${ip_port}/sales/Rec/ac_Header/insert';
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
