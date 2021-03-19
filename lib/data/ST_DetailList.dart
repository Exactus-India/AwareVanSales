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

class ST_middle {
  var serial_no;
  var product_code;
  var product_name;
  var puom;
  var qty_puom;
  var luom;
  var qty_luom;
  var amount;
  var unit_price;
  var vat;
  var net_amount;
  var tot_qty;
  var uppp;

  ST_middle.fromJson(Map<String, dynamic> json) {
    serial_no = json['SERIAL_NO'];
    product_code = json['PROD_CODE'];
    product_name = json['PROD_NAME'];
    puom = json['P_UOM'];
    qty_puom = json['QTY_PUOM'];
    luom = json['L_UOM'];
    qty_luom = json['QTY_LUOM'];
    tot_qty = json['QUANTITY'];
    uppp = json['UPPP'];
  }
}
