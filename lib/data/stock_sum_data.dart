class StockSum {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;

  StockSum.fromJson(Map<String, dynamic> json) {
    val1 = json['PROD_NAME'];
    val2 = json['PROD_CODE'];
    val3 = json['L_UOM'];
    val4 = json['OP_STK'];
    val5 = json['IN_QTY'];
    val6 = json['OUT_QTY'];
    val7 = json['CL_STOCK'];
  }
}
