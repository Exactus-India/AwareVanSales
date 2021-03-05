class Salesmiddle {
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

  Salesmiddle.fromJson(Map<String, dynamic> json) {
    serial_no = json['SERIAL_NO'];
    product_code = json['PROD_CODE'];
    product_name = json['PROD_NAME'];
    puom = json['P_UOM'];
    qty_puom = json['QTY_PUOM'];
    luom = json['L_UOM'];
    qty_luom = json['QTY_LUOM'];
    unit_price = json['UNIT_PRICE'];
    amount = json['AMOUNT'];
    vat = json['TX_COMPNT_AMT_1'];
    net_amount = json['NET_PRICE'];
    tot_qty = json['QUANTITY'];
    uppp = json['UPPP'];
  }
}
