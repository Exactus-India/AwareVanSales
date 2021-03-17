class ST_detail_list {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;

  ST_detail_list.fromJson(Map<String, dynamic> json) {
    val1 = json['SERIAL_NO'];
    val2 = json['PROD_CODE'];
    val3 = json['PROD_NAME'];
    val4 = json['P_UOM'];
    val5 = json['QTY_PUOM'];
    val6 = json['L_UOM'];
    val7 = json['QTY_LUOM'];
  }
}
