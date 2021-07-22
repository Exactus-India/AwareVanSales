class Ossumm {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;

  Ossumm.fromJson(Map<String, dynamic> json) {
    val1 = json['SALESMAN_NAME'];
    val2 = json['AC_NAME'];
    val3 = json['OS_AMT'];
    val4 = json['AGE_1'];
    val5 = json['AGE_2'];
    val6 = json['AGE_3'];
    val7 = json['AGE_4'];
  }
}

class CashSummary {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;
  var val8;

  CashSummary.fromJson(Map<String, dynamic> json) {
    val1 = json['SALESMAN_CODE'];
    val2 = json['CREDIT_AMT'];
    val3 = json['CRDT_RTN_AMT'];
    val4 = json['CASH_AMT'];
    val5 = json['CASH_RTN_AMT'];
    val6 = json['CHECK_AMT'];
    val7 = json['CASH_COLLECTED_AMT'];
    val8 = json['CASH_ON_HAND'];
  }
}
