class Salessum {
  var prod_code;
  var prod_name;
  var l_uom;
  var op_stk;
  var in_qty;
  var out_qty;
  var cl_stock;

  Salessum.fromJson(Map<String, dynamic> json) {
    prod_code = json['PROD_CODE'];
    prod_name = json['PROD_NAME'];
    l_uom = json['L_UOM'];
    op_stk = json['OP_STK'];
    in_qty = json['IN_QTY'];
    out_qty = json['OUT_QTY'];
    cl_stock = json['CL_STOCK'];
  }
}
