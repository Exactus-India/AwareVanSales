class Replacement_list {
  var val1;
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

  Replacement_list.fromJson(Map<String, dynamic> json) {
    val1 = json['SERIAL_NO'];
    val2 = json['PROD_CODE'];
    val3 = json['PROD_NAME'];
    val4 = json['P_UOM'];
    val5 = json['QTY_PUOM'] * json['SIGN_IND'];
    val6 = json['L_UOM'];
    val7 = json['QTY_LUOM'];
    val8 = json['AMOUNT'];
    val9 = json['TX_COMPNT_AMT_1'];
    val10 = json['AMOUNT'] * json['SIGN_IND'];
    val11 = json['SIGN_IND'];
    // val12 = val11 * val4;
  }
}
