class Salesman_track {
  var val1 = '';
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;
  var val8;
  var val9;
  var val10;
  var val11;
  var val12;
  var search;
  var param1;
  var param2;
  var param3;
  var param4;
  var time;

  Salesman_track.fromJson(Map<String, dynamic> json) {
    val2 = json['LOGIN_DATE'].toString().split(" ")[1];
    // time = DateTime.parse(val2);
    // val1 = json['LOGIN_DATE'].toString().split(' ')[0];
    val3 = json['LOCATION_ADDR'];
    val4 = json['DOC_TYPE'];
    val5 = json['GEO_LOC'].toString().split(',').first;
    val6 = json['GEO_LOC'].toString().split(',').last;
    val7 = json['IP_ADDRESS'];
    val8 = json['LOGIN_USER'];
    val9 = json['DEVICE'];
    val10 = json['MODEL_NO'];
    val11 = json['IP_ADDRESS'];
    val12 = json['USERID'];
    search = json['USERDT'];
    // param1 = json['AC_CODE'];
    // param2 = json['AC_NAME'];
    // param3 = json['ADDRESS_1'];
    // param4 = val2;
  }
}
