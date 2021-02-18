class Salesmiddle {
  var serial_no;
  var product_code;
  var product_name;
  var puom;
  var qty_puom;
  var luom;
  var qty_luom;
  var amount;
  var tax;
  var net_amount;

  Salesmiddle.fromJson(Map<String, dynamic> json) {
    serial_no = json['SERIAL_NO'];
    product_code = json['PROD_CODE'];
    product_name = json['PROD_NAME'];
    puom = json['P_UOM'];
    qty_puom = json['QTY_PUOM'];
    luom = json['L_UOM'];
    qty_luom = json['QTY_LUOM'];
    amount = json['AMOUNT'];
    tax = json['TX_COMPNT_AMT_1'];
    net_amount = json['NET_AMOUNT'];
  }
}
