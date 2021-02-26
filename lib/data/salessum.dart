class Salessum {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;

  Salessum.fromJson(Map<String, dynamic> json) {
    val1 = json['SR_NO'];
    val2 = null;
    val3 = null;
    val4 = json['DESCRIPTION'];
    val5 = json['COUNT_NO'];
    val6 = json['AMOUNT'];
    // val7 = json['sale_type'];
    val7 = null;
  }
}
