class Rec_InvList {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  // var val4 = null;

  Rec_InvList.fromJson(Map<String, dynamic> json) {
    val1 = json['AC_CODE'];
    val2 = json['INV_NO'];
    val3 = json['INV_DATE'].split('T')[0];
    val4 = json['AMT'];
    val5 = json['BALANCE_AMT'];
    val6 = json['ORGIN_AMT'];
  }
}
