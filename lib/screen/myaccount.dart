import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/orderDetails.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyAccount extends StatefulWidget {
  final SupermarketDetails supermarket;
  MyAccount({Key key, this.supermarket}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).fetchCustomerOrders(
        moreFetchBt: false, supermarketID: widget.supermarket.superMarketID);
    Provider.of<AppState>(context, listen: false)
        .deliveryDetail(widget.supermarket.superMarketID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final firebaseUser = Provider.of<FirebaseUser>(context);
    final appState = Provider.of<AppState>(context);

    var userName = widget.supermarket.supermarketName;

    var deliveryboy = appState.deliveryBoyDetails;
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(deliveryboy == null ? "" : deliveryboy.boyName),
            Text(deliveryboy == null
                ? ""
                : deliveryboy.onLeave ? "Leave" : "Available"),
            Image.network(
              deliveryboy == null ? "" : deliveryboy.boyImage ?? "",
              fit: BoxFit.scaleDown,
              height: 40,
            ),
            IconButton(icon: Icon(Icons.refresh), onPressed: null)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        userName,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      // Text("EDIT",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: Theme.of(context).primaryColor,
                      //     ))
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Text(contactNumber, style: TextStyle(color: greyColor)),
                  //     SizedBox(
                  //       width: 15,
                  //     ),
                  //     Text(emailAddress, style: TextStyle(color: greyColor))
                  //   ],
                  // ),
                  SizedBox(
                    height: 25,
                  ),
                  Divider(
                    color: blackColor,
                    thickness: 1.0,
                    height: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ExpandablePanel(
                      header: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "My Account",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text("Addresses, Payments, Favorites...",
                                  style: TextStyle(color: greyColor)),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                      collapsed: MySeparator(
                        color: greyColor,
                      ),
                      expanded: ListBody(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text("Manage Addresses"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/manageAddress'),
                            contentPadding: EdgeInsets.only(right: 10.0),
                          ),
                          ListTile(
                            leading: Icon(Icons.payment),
                            title: Text("Payments"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            onTap: () => print("tap"),
                            contentPadding: EdgeInsets.only(right: 10.0),
                          ),
                          ListTile(
                            leading: Icon(Icons.mobile_screen_share),
                            title: Text("Refer and Earn"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            onTap: () => print("tap"),
                            contentPadding: EdgeInsets.only(right: 10.0),
                          ),
                          ListTile(
                            leading: Icon(Icons.local_offer),
                            title: Text("Offers"),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                            ),
                            onTap: () => print("tap"),
                            contentPadding: EdgeInsets.only(right: 10.0),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MySeparator(
                            color: greyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, bottom: 10.0, top: 30.0),
                child: Text(
                  "PAST ORDER",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, color: greyColor),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: List.generate(appState.orderDetailsList.length,
                        (index) {
                      var order = appState.orderDetailsList[index];
                     
                      return OrdersList(
                        customerName: order.customerName,
                        customerAddress: order.customerAddress,
                        customerId: order.customerId,
                        deliveryCharges: order.deliveryCharges,
                        orderDeliveredDate: order.orderDeliveredDate,
                        orderId: order.orderId,
                        orderItems: order.orderItems,
                        orderPlacedDate: order.orderPlacedDate,
                        paymentMode: order.paymentMode,
                        productIds: order.productIds,
                        productsTotal: order.productsTotal,
                        // serviceTax: order.serviceTax,
                        subTotal: order.subTotal.toString(),
                        supermarketAddress: order.supermarketAddress,
                        supermarketId: order.supermarketId,
                        orderStatus: order.orderStatus,
                        supermarketName: order.supermarketName,
                        commission: order.commission.toString(),
                        updateDelivery: () async {
                          // print(order.documentId);
                          // bool response;
                          // if (order.deliveryType == "delivery") {
                          //   response = await appState.updateDeliveryStatus(
                          //       orderId: order.documentId,
                          //       status: "Ready For Pickup",
                          //       deliveryBoyId: deliveryboy.boyId,
                          //       deliveryBoyName: deliveryboy.boyName);
                          // } else {
                          //   response = await appState.updateDeliveryStatus(
                          //       orderId: order.documentId,
                          //       status: "Ready For Pickup",
                          //       deliveryBoyId: "",
                          //       deliveryBoyName: "");
                          // }

                          // if (response) {
                          //   print("Status Updated");
                          // } else {
                          //   print("Update failed");
                          // }
                        },
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  appState.finalOrderCount
                      ? Text("No More Orders")
                      : FlatButton(
                          onPressed: () async => appState.fetchCustomerOrders(
                              moreFetchBt: true,
                              supermarketID: widget.supermarket.superMarketID),
                          child: Text("VIEW MORE ORDERS",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                          padding: EdgeInsets.all(0),
                        ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
                  child: Center(
                    child: Text(
                      "App version 1.0.0",
                      style: Theme.of(context).textTheme.overline.copyWith(
                          fontWeight: FontWeight.bold, color: greyColor),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "LOGOUT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(Icons.power_settings_new),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/signup', (Route<dynamic> route) => false);
                      }),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, bottom: 10.0),
                  child: Center(
                    child: Text(
                      "WEBLOZEE Creations",
                      style: Theme.of(context).textTheme.overline.copyWith(
                          fontWeight: FontWeight.bold, color: greyColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class OrdersList extends StatelessWidget {
  final String customerName;
  final String orderId;
  final String commission;
  final String orderStatus;
  final String serviceTax;
  final String customerId;
  final String supermarketId;
  final String supermarketName;
  final String supermarketAddress;
  final String productsTotal;
  final String deliveryCharges;
  final Timestamp orderPlacedDate;
  final Timestamp orderDeliveredDate;
  final String paymentMode;
  final Function updateDelivery;
  final List<ProductIds> productIds;
  final List<OrderItems> orderItems;
  final String subTotal;
  final CustomerOrderAddress customerAddress;
  const OrdersList(
      {Key key,
      this.commission,
      this.customerName,
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
      this.supermarketAddress,
      this.supermarketId,
      this.updateDelivery,
      this.supermarketName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String orders = "";
        String ordersList;
    String orderPlacedFormattedDate;
    if(orderItems.length != 0){
      var date = orderPlacedDate.toDate();
orderPlacedFormattedDate = DateFormat.yMd().add_jm().format(date);
    orderItems.forEach((element) {
      print(element.productName);
      var productName = element.productName;
      var qty = element.productQty;
      var finalOutput = "$productName x $qty";
      orders += finalOutput;
      print("inside for each myAccont $finalOutput");
      print("inside for each myAccont $productName");
    });
    //String ordersList = orders.substring(0, 20) + "...";
    ordersList = orders ?? "" + "...";
     }
    //print(orderItems);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => OrderDetails(
                  customerName: customerName,
                      customerAddress: customerAddress,
                      deliveryCharges: deliveryCharges,
                      orderDeliveredDate: orderDeliveredDate,
                      orderId: orderId,
                      orderItems: orderItems,
                      orderPlacedDate: orderPlacedDate,
                      paymentMode: paymentMode,
                      productsTotal: productsTotal,
                      serviceTax: serviceTax,
                      subTotal: subTotal,
                      supermarketAddress: supermarketAddress,
                      supermarketName: supermarketName,
                      commission: commission,
                    )));
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(customerName ?? "",
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                Text(
                  customerAddress.landMark ?? "",
                  style: TextStyle(color: greyColor),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "\u20b9 ${productsTotal ?? ""}",
                      style: TextStyle(color: greyColor),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 10.0,
                      color: greyColor,
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                MySeparator(
                  color: greyColor,
                ),
                SizedBox(
                  height: 12.0,
                ),
                Text(ordersList ?? "", style: TextStyle(color: greyColor)),
                SizedBox(
                  height: 12.0,
                ),
                //"19 May 2020, 09:50 AM"
                Text(
                  orderPlacedFormattedDate ?? "",
                  style: TextStyle(color: lightGrey),
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "$orderStatus",
                          style: TextStyle(
                            color: orderStatus == 'Order Delivered'
                                ? Colors.green
                                : Colors.red,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Divider(
                  color: blackColor,
                  thickness: 1.0,
                  height: 0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
