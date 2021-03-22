class UserData {
  String employee_id;
  String employee_code;
  String alternate_id;
  String rpt_name;
  String outsourced_erp;
  String default_zone_code;
  String cash_ac;

  UserData(this.rpt_name);

  UserData.fromJson(Map<String, dynamic> json) {
    employee_id = json['EMPLOYEE_ID'];
    employee_code = json['EMPLOYEE_CODE'];
    alternate_id = json['ALTERNATE_ID'];
    rpt_name = json['RPT_NAME'];
    outsourced_erp = json['OUTSOURCED_ERP'];
    default_zone_code = json['DEFAULT_ZONE_CODE'];
    cash_ac = json['CASH_AC'];
  }
}
