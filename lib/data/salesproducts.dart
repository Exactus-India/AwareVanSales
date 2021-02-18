class Productlist {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5 = null;
  var val6 = null;
  var val7;
  var val8;
  var val9;
  var search;

  Productlist.fromJson(Map<String, dynamic> json) {
    val1 = json['PROD_NAME'];
    val2 = json['PROD_CODE'];
    val7 = json['STK_PUOM'];
    val8 = json['P_UOM'];
    val9 = json['UNIT_PRICE'];
    val3 = val7.toString() + " " + val8.toString();
    search = val1;
  }
}
