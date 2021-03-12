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
}

class SR_Productlist {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5 = null;
  var val6 = null;
  var val7;
  var val8;
  var val9;
  var amt;
  var search;
  var luom;
  var puom;
  var qty_luom;
  var qty_puom;
  var uppp;
  SR_Productlist.fromJsonSR(Map<String, dynamic> json) {
    val1 = json['PROD_NAME'];
    val2 = json['PROD_CODE'];
    val7 = json['QTY'];
    val8 = json['P_UOM'];
    val9 = json['UNIT_PRICE'];
    val3 = val7.toString() + " " + val8.toString();
    uppp = json['UPPP'];
    amt = json['AMOUNT'];
    val4 = "Amount " + amt.toString();
    search = val1;
    puom = val8;
    luom = json['L_UOM'];
    qty_puom = json['QTY_PUOM'];
    qty_luom = json['QTY_LUOM'];
  }
}
