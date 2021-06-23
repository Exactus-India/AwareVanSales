import 'package:aware_van_sales/data/future_db.dart';
import 'package:aware_van_sales/data/user_alert.dart';
import 'package:aware_van_sales/pages/wm_mb_LoginPage.dart';
import 'package:aware_van_sales/pages/wm_mb_addalert.dart';
import 'package:aware_van_sales/pages/wm_mb_customer.dart';
import 'package:aware_van_sales/pages/wm_mb_os_summary.dart';
import 'package:aware_van_sales/wigdets/card.dart';
import 'package:aware_van_sales/wigdets/widget_rowData.dart';
import 'package:aware_van_sales/wigdets/widgets.dart';
import 'package:aware_van_sales/wigdets/willpopup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'wm_mb_receipt.dart';
import 'wm_mb_sales_summary.dart';
import 'wm_mb_stock_summary.dart';
import 'wm_mb_stock_transfer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<UserAlert> userAlert = [];
  @override
  void initState() {
    get_user_zonecode().then((value) {
      gs_zonecode = value[0]['DEFAULT_ZONE_CODE'];
      print("Zonecode " + gs_zonecode);
      gl_ac_cash = value[0]['CASH_AC'];
      print("CASH_AC " + gl_ac_cash);
    });
    alert_list_();
    getContext(this.context);
    super.initState();
  }

  alert_list_() {
    return getUserAlert(gs_currentUser).then((value) {
      setState(() {
        userAlert.clear();
        userAlert.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Menu", Colors.white),
        elevation: .1,
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        // actions: <Widget>[
        //   // Using Stack to show Notification Badge
        //   new Stack(
        //     children: <Widget>[
        //       new IconButton(
        //           iconSize: 30.0,
        //           icon: Icon(Icons.notifications),
        //           onPressed: () {
        //             alert_list_();
        //             setState(() {
        //               alert_list(context);
        //             });
        //           }),
        //       userAlert.length != 0 ? notify_count() : new Container(),
        //     ],
        //   ),
        // ],
      ),
      drawer: new Drawer(
          elevation: 10.0,
          child: new ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.grey.shade500),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            // color: Colors.grey.shade500,
                            iconSize: 30,
                            icon: Icon(Icons.close),
                          ),
                        ),
                        CircleAvatar(
                          child: Text(gs_currentUser[0],
                              style: TextStyle(fontSize: 30)),
                          radius: 30.0,
                        ),
                        Text(
                          gs_currentUser,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0),
                        ),
                      ])),
              listTile(CustomerList(toPage: '/SalesList'), context, 'sale.png',
                  'SALE'),
              listTile(CustomerList(toPage: '/SalesReturnList'), context,
                  'sale_returns.jpg', 'RETURNS'),
              listTile(ReceiptList(), context, 'receipt.png', 'RECEIPT'),
              listTile(
                  SalesSummary(), context, 'sales_summary.png', 'SALE SUMMARY'),
              listTile(Stocktransfer(), context, 'stock_transfer.png',
                  'STOCK TRANSFER'),
              listTile(OsSummary(), context, 'os_ageing.png', 'O/S AGEING'),
              listTile(StockSummary(), context, 'stock_summary.png',
                  'STOCK SUMMARY'),
              // listTile(null, context, 'about.png', 'ABOUT'),
              listTileSignout(context, 'sign_out.jpg', 'SIGN OUT'),
            ],
          )),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: GridView.count(
            crossAxisCount: 2,
            //padding: EdgeInsets.all(13.0),
            children: <Widget>[
              //--------------------------SALE-------------------------
              card("SALE", CustomerList(toPage: '/SalesList'), Colors.blue[800],
                  this.context, 'sale.png'),

              //--------------------------RETURNS-------------------------
              card("RETURNS", CustomerList(toPage: '/SalesReturnList'),
                  Colors.blue[800], this.context, 'sale_returns.jpg'),

              //--------------------------RECEIPT-------------------------
              card("RECEIPT", ReceiptList(), Colors.blue[800], this.context,
                  'receipt.png'),

              //--------------------------SALE SUMMARY-------------------------
              card("SALE SUMMARY", SalesSummary(), Colors.blue[800],
                  this.context, 'sales_summary.png'),

              //--------------------------STOCK TRANSFER-------------------------
              card("STOCK TRANSFER", Stocktransfer(), Colors.blue[800],
                  this.context, 'stock_transfer.png'),

              //--------------------------O/S AGEING-------------------------
              card("O/S AGEING", OsSummary(), Colors.blue[800], this.context,
                  'os_ageing.png'),

              //--------------------------STOCK SUMMARY-------------------------
              card("STOCK SUMMARY", StockSummary(), Colors.blue[800],
                  this.context, 'stock_summary.png'),

              //--------------------------DAILY ACTIVITY-------------------------
              // card("ALERT", AddAlert(), Colors.blue[800], this.context,
              //     'daily_activity.png')
            ],
          ),
        ),
      ),
    );
  }

  void alert_list(context) {
    // Color color;
    showModalBottomSheet(
        backgroundColor: Color.fromRGBO(59, 87, 110, 1.0),
        context: context,
        builder: (_) {
          return ListView.builder(
            itemBuilder: (context, index) {
              // if (userAlert[index].msg_r == 'N') color = Colors.grey[400];
              // if (userAlert[index].msg_r == 'Y') color = Colors.white;
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            rowData_2(userAlert[index].val4,
                                userAlert[index].val7, 14.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: textData(
                                  userAlert[index].val5, Colors.red, 20.0),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        alert_read_update(userAlert[index].val3).then((value) {
                          print(value);
                          setState(() {
                            alert_list_();
                            Navigator.pop(context);
                          });
                        });
                      },
                    )),
              );
            },
            itemCount: userAlert.length,
          );
        });
  }

  signout() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Sign Out?'),
        actions: <Widget>[
          new ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            // onPressed: () => Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => LoginPage())),
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  notify_count() {
    return new Positioned(
      right: 8,
      top: 8,
      child: new Container(
        padding: EdgeInsets.all(2),
        decoration: new BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          minWidth: 15,
          minHeight: 15,
        ),
        child: Text(
          userAlert.length.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
