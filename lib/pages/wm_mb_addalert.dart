import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/data/user_alert.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/wigdets/alert.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:custom_datatable/custom_datatable.dart';
import 'package:flutter/material.dart';

class AddAlert extends StatefulWidget {
  @override
  _AddAlertState createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  TextEditingController doc_no = new TextEditingController();
  TextEditingController alert_msg = new TextEditingController();
  TextEditingController remarks = new TextEditingController();
  var alert_docno;
  List<UserAlert> getUsersAlert = [];
  List alertColum = ["Doc_no", 'Doc_date', 'Alert Message'];

  @override
  void initState() {
    getUserAlertListing(gs_currentUser).then((value) {
      setState(() {
        getUsersAlert.addAll(value);
      });
    });
    print("dfsdfs" + getUsersAlert.length.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: text("Add Alert", Colors.white),
          elevation: .1,
          backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  max_alert().then((value) {
                    if (value == null) alert_docno = 1;
                    if (value != null) alert_docno = value.toInt() + 1;
                  }).then((_) => alert_user_insertion(
                              gs_company_code,
                              gs_alert_doc_type,
                              alert_docno.toString(),
                              alert_msg.text,
                              gs_currentUser,
                              remarks.text)
                          .then((value) {
                        if (value == 1) {
                          alert(context, "Alert send", Colors.green);
                        } else {
                          alert(context, value.toString(), Colors.red);
                        }
                        alert_msg.clear();
                        remarks.clear();
                      }));
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Icon(Icons.save),
              ),
            )
          ],
        ),
        body: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: textData(gs_currentUser, Colors.black, 20.0)),
              SizedBox(
                height: 10.0,
              ),
              Flexible(
                  flex: 2,
                  child: textArea("Message", alert_msg, false, false, 250, 5)),
              Flexible(
                  child: textArea("Remarks", remarks, false, false, 100, 1)),
              dataTable(getUsersAlert.length, getUsersAlert, alertColum),
            ],
          ),
        )

        //
        );
  }

  dataTable(numItems, rowList, column) {
    return CustomDataTable(
        headerColor: Colors.green[200],
        rowColor1: Colors.grey.shade300,
        dataTable: DataTable(
          headingRowHeight: 35.0,
          dataRowHeight: 35,
          columnSpacing: 15,
          showCheckboxColumn: false,
          columns: [
            for (int i = 0; i <= column.length - 1; i++)
              DataColumn(
                label: text(column[i], Colors.black),
              ),
          ],
          rows: List<DataRow>.generate(
            numItems,
            (index) => DataRow(
              onSelectChanged: (va) {},
              cells: <DataCell>[
                //sno

                DataCell(Text(rowList[index].val3.toString())),

                //product code

                DataCell(Text(rowList[index].val4.toString())),

                //qty

                DataCell(Text(rowList[index].val5.toString())),

                //total
              ],
            ),
          ),
        ));
  }
}
