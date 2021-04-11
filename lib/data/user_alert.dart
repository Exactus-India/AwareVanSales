class UserAlert {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;

  UserAlert.fromJson(Map<String, dynamic> json) {
    val1 = json['COMPANY_CODE'];
    val2 = json['DOC_TYPE'];
    val3 = json['DOC_NO'];
    val4 = json['DOC_DATE'].toString().split('T')[0];
    val5 = json['ALERT_MSG'];
    val6 = json['USER_DT'];
    val7 = json['USER_ID'];
  }
}
