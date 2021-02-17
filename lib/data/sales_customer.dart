class Customer {
  var val1 = null;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;
  var val8;
  var val9;
  var val10;
  var val11;
  var val12;
  var search;
  var param1;
  var param2;

  Customer.fromJson_Customer(Map<String, dynamic> json) {
    val2 = json['AC_CODE'];
    val3 = json['OS_AMOUNT'];
    val4 = json['AC_NAME'];
    val5 = json['CONTACT_PERSON'];
    val6 = json['ADDRESS_1'];
    val7 = json['PHONE'];
    val8 = json['MOBILE_NO'];
    val9 = json['TERRITORY_NAME'];
    val10 = json['ROUTE_NAME'];
    val11 = json['TODAY_SALE_IND'];
    val12 = json['ROUTE_CODE'];
    search = json['AC_NAME'];
    param1 = json['AC_CODE'];
    param2 = json['AC_NAME'];
  }
}

class Sales {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5 = null;
  var val6 = null;
  var val7;
  var val8;
  var val9;
  var val10;
  var val11;
  var search;
  var param1;
  var param2;

  Sales.fromJson_Sales(Map<String, dynamic> json) {
    val1 = json['DOC_DATE'];
    val2 = json['DOC_NO'];
    val3 = json['SALE_TYPE'];
    val4 = json['REF_NO'];
    val7 = json['DOC_TYPE'];
    val8 = json['PARTY_NAME'];
    val9 = json['AC_CODE'];
    val10 = json['SALESMAN_CODE'];
    val11 = json['CONFIRMED'];
    search = json['DOC_NO'];
    param1 = json['DOC_NO'];
    param2 = json['PARTY_NAME'];
  }
}
