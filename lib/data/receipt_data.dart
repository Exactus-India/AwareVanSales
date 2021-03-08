class Receipt {
  var val1;
  var val2;
  var val3;
  var val4 = null;
  var val5 = null;
  var val6 = null;
  // var val4 = null;

  Receipt.fromJson(Map<String, dynamic> json) {
    val1 = json['AC_CODE'];
    val2 = json['AC_NAME'];
    val3 = json['BALANCE_AMT'];
  }
}
