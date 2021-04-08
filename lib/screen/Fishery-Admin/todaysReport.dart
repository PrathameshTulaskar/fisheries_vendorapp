import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodaysSaleReport extends StatefulWidget {
  TodaysSaleReport({Key key}) : super(key: key);

  @override
  _TodaysSaleReportState createState() => _TodaysSaleReportState();
}

class _TodaysSaleReportState extends State<TodaysSaleReport> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Today's Sale"),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<Order>>(
              future: appState.fetchTodaysSale(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('EEE, M/d/y').format(DateTime.now()),style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 12),
                    snapshot.data == null
                        ? DataTable(
                            columns: [
                                DataColumn(label: Text("Order Number")),
                                DataColumn(label: Text("Customer Name")),
                                DataColumn(label: Text("Order Total")),
                              ],
                            rows: List<DataRow>.generate(snapshot.data.length,
                                (index) {
                              return DataRow(cells: [
                                DataCell(Text(snapshot.data[0].orderId)),
                                DataCell(Text(snapshot.data[0].customerName)),
                                DataCell(Text(snapshot.data[0].productsTotal)),
                              ]);
                            }))
                        // Table(
                        //     children: [
                        //       TableRow(children: [
                        //         TableCell(
                        //           child: Text("Order Number"),
                        //         ),
                        //         TableCell(
                        //           child: Text("Customer Name"),
                        //         ),
                        //         TableCell(
                        //           child: Text("Order Total"),
                        //         )
                        //       ])
                        //     ],
                        //   )
                        : Align(
                            alignment: Alignment.center,
                            child: Text("Orders Empty.")),
                    SizedBox(height: 20),
                    OutlineButton.icon(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                     
                        onPressed: () => Navigator.pushReplacementNamed(context,'/home'),
                        label: Text("Back To Homepage"),
                        icon: Icon(
                          Icons.home_outlined,
                          color: Theme.of(context).primaryColor,
                          semanticLabel: "Homepage",
                        ))
                  ],
                );
              }),
        ));
  }
}
