class Mse_product {
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
  var stk_luom;
  var qty_luom;
  var qty_puom;
  var stk_puom;
  var cost_rate;
  var uppp;
  Mse_product.fromJson(Map<String, dynamic> json) {
    val1 = json['PROD_NAME'];
    val2 = json['PROD_CODE'];
    val7 = json['QTY'];
    val8 = json['P_UOM'];
    val9 = json['UNIT_PRICE'];
    val3 = val8.toString();
    uppp = json['UPPP'];
    amt = json['AMOUNT'];
    cost_rate = json['COST_RATE'];
    val4 = "Amount " + cost_rate.toString();
    search = val1;
    puom = val8;
    luom = json['L_UOM'];
    qty_puom = json['QTY_PUOM'];
    qty_luom = json['QTY_LUOM'];
    stk_luom = qty_luom;
    stk_puom = qty_puom;
  }
}
