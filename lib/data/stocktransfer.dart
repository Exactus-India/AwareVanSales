class StockTransfer {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var param1;
  var param2;
  var param3;
  var param4;
  var search;

  StockTransfer.fromJson(Map<String, dynamic> json) {
    val1 = json['DOC_DATE'].toString().split('T')[0];
    val4 = json['DOC_NO'];
    val5 = json['FROM_ZONE_NAME'];
    val6 = json['TO_ZONE_NAME'];
    param1 = json['DOC_NO'];
    param2 = json['FROM_ZONE_NAME'];
    param3 = json['TO_ZONE_NAME'];
    search = val4;
  }
}
