import 'dart:async';
import 'dart:io';
import 'package:aware_van_sales/data/sales_customer.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/wigdets/userListBuilder.dart';
import './User_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

// Future<List> customerlist() async {
//   var url = 'http://exactusnet.dyndns.org:4005/api/sales/customerList';
//   var response = await http.get(url);
//   var jsonBody = response.body;
//   var jsonData = json.decode(jsonBody.substring(0));
//   return jsonData;
// }

Future<List<Sales_Customer_Data>> customerlist() async {
  var url = 'http://exactusnet.dyndns.org:4005/api/sales/customerList';
  var response = await http.get(url);
  var datas = List<Sales_Customer_Data>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Sales_Customer_Data.fromJson_Customer(dataJson));
    }
  }
  return datas;
}

Future<List<Sales_Customer_Data>> sales_list(
    doc_type, ac_code, salesman_code) async {
  var url =
      'http://exactusnet.dyndns.org:4005/api/sales/customerList/salesList/$doc_type/$ac_code/$salesman_code';
  var response = await http.get(url);
  var datas = List<Sales_Customer_Data>();
  if (response.statusCode == 200) {
    Object datasJson = json.decode(response.body.substring(0));
    for (var dataJson in datasJson) {
      datas.add(Sales_Customer_Data.fromJson_Sales(dataJson));
    }
    gs_sales_customer_name = datas[0].party_name.toString();
    gs_sales_doc_date = datas[0].doc_date.toString();
  }
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
