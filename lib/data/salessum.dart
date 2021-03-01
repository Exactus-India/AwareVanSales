class Salessum1 {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;

  Salessum1.fromJson(Map<String, dynamic> json) {
    val1 = json['DESCRIPTION'];
    val2 = json['COUNT_NO'];
    val3 = json['AMOUNT'];
  }
}

class Salessum2 {
  var val1;
  var val2;
  var val3;
  var val4;

  Salessum2.fromJson(Map<String, dynamic> json) {
    val1 = json['SR_NO'];

    val2 = json['DESCRIPTION'];
    val3 = json['COUNT_NO'];
    val4 = json['AMOUNT'];
  }
}
