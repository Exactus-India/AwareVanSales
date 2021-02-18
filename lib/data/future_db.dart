import 'dart:async';
import 'dart:io';
import 'package:aware_van_sales/data/sales_details.dart';
import 'package:aware_van_sales/data/salesproducts.dart';
import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import './User_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

Future<List> getAllSalesEntryDetails(doc_no) async {
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
