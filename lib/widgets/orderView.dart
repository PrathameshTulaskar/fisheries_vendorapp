//Order List Widget
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:intl/intl.dart';

import 'colors.dart';
import 'customWidgets.dart';
import 'orderDetails.dart';

class OrdersList extends StatelessWidget {
  final String orderId;
  final String tokenNumber;
  final int slotNumber;
  final String customerName;
  final String orderStatus;
  final String serviceTax;
  final String customerId;
  final String supermarketId;
  final String productsTotal;
  final String deliveryCharges;
  final DateTime orderPlacedDate;
  final Timestamp orderDeliveredDate;
  final String paymentMode;
  final Function updateDelivery;
  final Function cancelorder;
  final List<ProductIds> productIds;
  final List<OrderItems> orderItems;
  final String subTotal;
  final CustomerOrderAddress customerAddress;
  const OrdersList(
      {Key key,
      this.slotNumber,
      this.tokenNumber,
      this.serviceTax,
      this.orderStatus,
      this.orderDeliveredDate,
      this.customerAddress,
      this.customerId,
      this.deliveryCharges,
      this.orderId,
      this.orderItems,
      this.orderPlacedDate,
      this.paymentMode,
      this.productIds,
      this.productsTotal,
      this.subTotal,
      this.supermarketId,
      this.updateDelivery,
      this.cancelorder,
      this.customerName})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    int difference = 0;
    String orders = "";
    String orderDate = DateFormat.jm().format(orderPlacedDate);
    // Timer.periodic(Duration(seconds: 60), (timer) {
    //   print("periodic check difference");
    //     difference = now.difference(dateOrder).inHours;
    //   if(difference == 1) {
    //     timer.cancel();
    //   }
    // });
    // var orderDate = DateFormat('K:mm a').format();
    // widget.orderItems.forEach((element) {
    //   //print(element.productName);
    //   var productName = element.productName;
    //   var qty = element.productQty;
    //   var finalOutput = "$productName x $qty";
    //   orders += finalOutput;
    //   // print("inside for each myAccont $finalOutput");
    //   // print("inside for each myAccont $productName");
    // });
    //String ordersList = orders.substring(0, 20) + "...";
    String ordersList = orders ?? "" + "...";
    //print(orderItems);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width:192,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(customerName ?? "",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                          Text(customerAddress.landMark ?? "",style: TextStyle(color: greyColor),),
                        ],
                      ),
                    ),
                    RaisedButton.icon(onPressed: () => AwesomeDialog(
                      context: context,
                      btnCancel: RaisedButton(onPressed: () => Navigator.pop(context), child: Text("close")),
                      btnOkColor: Colors.red,
                      headerAnimationLoop: false,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      body: Container(
                         height: 300,
                        child: DataTable(columns: [
                          DataColumn(label: Text("Product",style: Theme.of(context).textTheme.subtitle1,)),
                          DataColumn(label: Text("Quantity",style: Theme.of(context).textTheme.subtitle1,)),
                          //DataColumn(label: Text("Price",style: Theme.of(context).textTheme.subtitle1,)),
                        ], rows: orderItems.map((e) => DataRow(cells: <DataCell>[
                          DataCell(Center(child: Text(e.productName))),
                          DataCell(Center(child: Text(e.productQty))),
                        ])).toList())
                      ),
                    )..show(), icon: Icon(Icons.assignment), label: Text("PRODUCTS"))
                  ],
                ),
              ),
             
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Order Placed: ",style: Theme.of(context).textTheme.subtitle1,),
                         
                        Text(orderDate ?? "",
                          style: TextStyle(color: lightGrey),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Row(
                      children: <Widget>[
                        Text("Total: ",style: Theme.of(context).textTheme.subtitle1,),
                         Text(
                      "\u20b9${subTotal ?? ""}",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 8.0,
              // ),
              // MySeparator(
              //   color: greyColor,
              // ),
             
              // Text(ordersList ?? "", style: TextStyle(color: greyColor)),
              // SizedBox(
              //   height: 12.0,
              // ),
              //"19 May 2020, 09:50 AM"
              Center(
                child: Container(decoration: BoxDecoration(border: Border.all(width: 1)),child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(tokenNumber?? "", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,)),
                )),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      onPressed: updateDelivery,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text("ORDER PACKED",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: blackColor)),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.green, width: 2)),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0)),        
                  FlatButton(
                      onPressed: cancelorder,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text("CANCEL ORDER",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: blackColor)),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.red, width: 2)),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0)),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Divider(
                color: blackColor,
                thickness: 2.0,
                height: 0,
              ),
            ],
          ),
        )
      ],
    );
  }
}