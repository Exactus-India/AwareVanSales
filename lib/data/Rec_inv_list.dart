class Rec_InvList {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;
  // var val4 = null;

  Rec_InvList.fromJson(Map<String, dynamic> json) {
    val1 = json['AC_CODE'];
    val2 = json['INV_NO'];
    val3 = json['INV_DATE'].split('T')[0];
    val4 = json['AMT'];
    val5 = json['BALANCE_AMT'];
    val6 = json['ORGIN_AMT'];
    val7 = json['DOC_DATE'];
  }
}

class Doc_Rec_InvList {
  var val1;
  var val2;
  var val3;
  var val4;
  var val5;
  var val6;
  var val7;
  // var val4 = null;

  Doc_Rec_InvList.fromJson(Map<String, dynamic> json) {
    val1 = json['DOC_NO'];
    val2 = json['REF_NO'];
    if (json['DOC_DATE'] != null)
      val3 = json['DOC_DATE'].split('T')[0].toString();
    val4 = json['PARTY_NAME'];
    val5 = json['BALANCE_AMT'];
    val6 = json['ORGIN_AMT'];
    val7 = json['DOC_DATE'];
  }
}

class Doc_Rec_InvList_detail {
  var val1;
  var val2 = "";
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
  // var val4 = null;

  Doc_Rec_InvList_detail.fromJson(Map<String, dynamic> json) {
    val1 = json['INV_NO'];
    if (json['INV_DATE'] != null)
      val2 = json['INV_DATE'].split('T')[0].toString();
    val3 = json['AMOUNT'];
    val7 = json['DOC_DATE'].split('T')[0].toString();

    // val4 = json['AMOUNT_ORIGIN'];

    // val12 = json['REF_NO'];
  }
}
