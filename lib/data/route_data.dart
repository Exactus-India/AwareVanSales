import 'package:flutter/cupertino.dart';

class RouteData {
  String route_code;
  String route_name;

  RouteData.fromJson(Map<String, dynamic> json) {
    route_code = json['ROUTE_CODE'];
    route_name = json['ROUTE_NAME'];
  }
}
