class Sales_Customer_Data {
  var ac_code;
  var ac_name;
  var address_one;
  var contact_person;
  var phone;
  var mobile_no;
  var teritory_name;
  var route_name;
  var os_amt;
  var today_sale_ind;
  var route_code;

  var doc_type;
  var doc_no;
  var doc_date;
  var ref_no;
  var party_name;
  var sale_type;
  var ac_code_sales;
  var salesman_code;
  var confirmed;

  Sales_Customer_Data.fromJson_Customer(Map<String, dynamic> json) {
    ac_code = json['AC_CODE'];
    ac_name = json['AC_NAME'];
    address_one = json['ADDRESS_1'];
    contact_person = json['CONTACT_PERSON'];
    phone = json['PHONE'];
    mobile_no = json['MOBILE_NO'];
    teritory_name = json['TERRITORY_NAME'];
    route_name = json['ROUTE_NAME'];
    os_amt = json['OS_AMOUNT'];
    today_sale_ind = json['TODAY_SALE_IND'];
    route_code = json['ROUTE_CODE'];
  }
  Sales_Customer_Data.fromJson_Sales(Map<String, dynamic> json) {
    doc_type = json['DOC_TYPE'];
    doc_no = json['DOC_NO'];
    doc_date = json['DOC_DATE'];
    ref_no = json['REF_NO'];
    party_name = json['PARTY_NAME'];
    sale_type = json['SALE_TYPE'];
    ac_code_sales = json['AC_CODE'];
    salesman_code = json['SALESMAN_CODE'];
    confirmed = json['CONFIRMED'];
  }
}
