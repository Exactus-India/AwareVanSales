import 'dart:async';
import 'dart:io';
import 'package:aware_van_sales/data/os_summ.dart';
import 'package:aware_van_sales/data/sales_Middle.dart';
import 'package:aware_van_sales/data/sales_detailList.dart';
import 'package:aware_van_sales/data/salesproducts.dart';
import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/data/salessum.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:intl/intl.dart';
import './User_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'stock_sum_data.dart';

String gs_doc_type = 'DN90';
String gs_company_code = 'BSG';

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
  var date = DateFormat("dd-MMM-yyyy").format(DateTime.now());
  print(date.toString());
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/prosalessummary/$gs_company_code/12-FEB-2021/$gs_currentUser_empid';
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
  var date = DateFormat("dd-MMM-yyyy").format(DateTime.now());
  print(date.toString());
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
    // cancelled,
    // inv_ref_type,
    // tx_id_no,
    // tx_cat_code,
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
    "DOC_TYPE": gs_doc_type,
    "SALESMAN_CODE": gs_currentUser_empid,
    "DEPT_CODE": dept_code,
    // "CANCELLED": cancelled,
    "USER_ID": gs_currentUser,
    // "INV_REF_TYPE": inv_ref_type,
    // "TX_IDENTITY_NUMBER": gs_doc_type + '' + tx_id_no,
    // "TX_CAT_CODE": tx_cat_code,
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
    return null;
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
    "DOC_TYPE": gs_doc_type,
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
    return null;
  }
}

Future<bool> salesDelete(serial_no, doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/delete/$serial_no/$doc_no/$gs_company_code/$gs_doc_type';
  var response = await http.delete(url);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List> getAllSalesEntryDetails(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/DetailList/$gs_doc_type/$gs_company_code/$doc_no';
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
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/DetailList/$gs_doc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> getAllSalesHDR(doc_no) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/HDR/$gs_doc_type/$gs_company_code/$doc_no';
  var response = await http.get(url);
  var jsonBody = response.body;
  var jsonData = json.decode(jsonBody.substring(0));
  return jsonData;
}

Future<List> salesmiddile(docno, serialno) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesDN/Detail/$gs_doc_type/$gs_company_code/$docno/$serialno';
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
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesList/$gs_doc_type/$ac_code/$gs_currentUser_empid';
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
