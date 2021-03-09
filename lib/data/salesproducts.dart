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
  var val10;
  var search;
  var luom;
  var puom;
  var stk_luom;
  var stk_puom;
  var uppp;

  Productlist.fromJson(Map<String, dynamic> json) {
    val1 = json['PROD_NAME'];
    val2 = json['PROD_CODE'];
    val7 = json['STK_PUOM'];
    val8 = json['P_UOM'];
    val9 = json['UNIT_PRICE'];
    uppp = json['UPPP'];
    val3 = val7.toString() + " " + val8.toString();
    search = val1;
    puom = val8;
    stk_puom = val7;
    luom = json['L_UOM'];
    stk_luom = json['STK_LUOM'];
  }
  Productlist.fromJsonSR(Map<String, dynamic> json) {
    val1 = json['PROD_NAME'];
    val2 = json['PROD_CODE'];
    val3 = json['QTY'];
    val10 = json['P_UOM'];
    val7 = json['AMOUNT'];
    uppp = json['UPPP'];
    val3 = val3.toString() + " " + val10.toString();
    val5 = "Price " + val7.toString();
    search = val1;
    puom = val10;
    // stk_puom = val7;
    luom = json['L_UOM'];
    stk_luom = json['STK_LUOM'];
  }
}
