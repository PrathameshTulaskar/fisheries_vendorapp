// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fisheries_vendorapp/models/deliveryBoy.dart';
// import 'package:fisheries_vendorapp/models/orderDetails.dart';
// import 'package:fisheries_vendorapp/providers/appstate.dart';
// import 'package:fisheries_vendorapp/util/themedata.dart';
// import 'package:fisheries_vendorapp/widgets/widgets.dart';
// import 'package:provider/provider.dart';
// import 'myaccount.dart';

// class ListStream extends StatefulWidget {
//   ListStream({Key key}) : super(key: key);

//   @override
//   _ListStreamState createState() => _ListStreamState();
// }

// class _ListStreamState extends State<ListStream> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//             appBar: AppBar(
//               bottom: TabBar(
//                 onTap: (index) {
//                   print(index);
//                 },
//                 tabs: [
//                   Tab(
//                     icon: Icon(Icons.calendar_today),
//                     text: "Today",
//                   ),
//                   Tab(
//                     icon: Icon(Icons.repeat),
//                     text: "Re-attempt",
//                   ),
//                 ],
//               ),
//               title: TitleTextBuilder(
//                 sendText: "Orders Page",
//               ),
//             ),
//             body: StreamBuilder<QuerySnapshot>(
//               stream: Firestore.instance
//                   .collection("grocery/orders/orderList")
//                   .where("supermarketId", isEqualTo: "randomid1")
//                   .where("orderStatus", whereIn: ["Order Placed", "Re-attempt"])
//                   .orderBy("deliveredDate", descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 final appState = Provider.of<AppState>(context);
//                 var deliveryboy = appState.deliveryBoyDetails;
//                 List<Order> orders = [];
//                 var children;
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.none:
//                   case ConnectionState.waiting:
//                     children = Container(
//                         width: fullWidth(context),
//                         height: fullHeight(context),
//                         child: Center(child: CircularProgressIndicator()));
//                     break;
//                   default:
//                     if (snapshot.hasError)
//                       children = [Text('Error: ${snapshot.error}')];
//                     else {
//                       orders = snapshot.data.documents.map((e) {
//                         Map<String, dynamic> moreData = e.data;
//                         Map<String, dynamic> productIdMap = {
//                           'documentID': e.documentID
//                         };
//                         Map<String, dynamic> mergedMap = {};
//                         mergedMap.addAll(moreData);
//                         mergedMap.addAll(productIdMap);
//                         return Order.fromJson(mergedMap);
//                       }).toList();
//                       children = TabBarView(
//                         children: [
//                           TodayOrders(
//                               appState: appState,
//                               orderList: orders,
//                               deliveryboy: deliveryboy),
//                           ReAttemptOrders(
//                             appState: appState,
//                             orderList: orders,
//                             deliveryboy: deliveryboy),
//                         ],
//                       );
//                     }
//                 }
//                 print("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
//                 return children;
//                 //Column(children: children);
//               },
//             )),
//       ),
//     );
//   }
// }

// class ReAttemptOrders extends StatelessWidget {
//   const ReAttemptOrders({
//     Key key,
//     @required this.deliveryboy,
//     @required this.orderList,
//     @required this.appState,
//   }) : super(key: key);

//   final List<Order> orderList;
//   final AppState appState;
//   final DeliveryBoyDetails deliveryboy;

//   @override
//   Widget build(BuildContext context) {
//     var todaysOrderDetails = orderList
//         .where((element) => element.orderStatus == "Re-attempt")
//         .toList();
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//         child: Column(
//           children: <Widget>[
//             Column(
//               children: List.generate(
//                   todaysOrderDetails == null ? 0 : todaysOrderDetails.length,
//                   (index) {
//                 var order = todaysOrderDetails[index];
//                 return OrdersList(
//                   customerAddress: order.customerAddress,
//                   customerId: order.customerId,
//                   deliveryCharges: order.deliveryCharges,
//                   orderDeliveredDate: order.orderDeliveredDate,
//                   orderId: order.orderId,
//                   orderItems: order.orderItems,
//                   orderPlacedDate: order.orderPlacedDate,
//                   paymentMode: order.paymentMode,
//                   productIds: order.productIds,
//                   productsTotal: order.productsTotal,
//                   serviceTax: order.serviceTax,
//                   subTotal: order.subTotal.toString(),
//                   supermarketAddress: order.supermarketAddress,
//                   supermarketId: order.supermarketId,
//                   orderStatus: order.orderStatus,
//                   supermarketName: order.supermarketName,
//                   updateDelivery: () async {
//                     print(order.documentId);
//                     bool response;
//                     if (order.deliveryType == "delivery") {
//                       response = await appState.updateDeliveryStatus(
//                           orderId: order.documentId,
//                           status: "Ready For Pickup",
//                           deliveryBoyId: deliveryboy.boyId,
//                           deliveryBoyName: deliveryboy.boyName);
//                     } else {
//                       response = await appState.updateDeliveryStatus(
//                           orderId: order.documentId,
//                           status: "Ready For Pickup",
//                           deliveryBoyId: "",
//                           deliveryBoyName: "");
//                     }

//                     if (response) {
//                       print("Status Updated");
//                     } else {
//                       print("Update failed");
//                     }
//                   },
//                 );
//               }),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             FlatButton(
//               onPressed: null, //() async =>
//               //appState.fetchCustomerOrders(moreFetchBtn: true),
//               child: Text("VIEW MORE ORDERS",
//                   style: Theme.of(context).textTheme.button.copyWith(
//                       color: Theme.of(context).primaryColor,
//                       fontWeight: FontWeight.bold)),
//               padding: EdgeInsets.all(0),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class TodayOrders extends StatelessWidget {
//   const TodayOrders({
//     Key key,
//     @required this.orderList,
//     @required this.deliveryboy,
//     @required this.appState,
//   }) : super(key: key);

//   final List<Order> orderList;
//   final AppState appState;
//   final DeliveryBoyDetails deliveryboy;

//   @override
//   Widget build(BuildContext context) {
//     var reAttempOrderDetails = orderList
//         .where((element) => element.orderStatus == "Order Placed")
//         .toList();
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12.0),
//       child: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//                 //shrinkWrap: true,
//                 itemCount: reAttempOrderDetails == null
//                     ? 0
//                     : reAttempOrderDetails.length,
//                 itemBuilder: (context, index) {
//                   var order = reAttempOrderDetails[index];
//                   return OrdersList(
//                     customerAddress: order.customerAddress,
//                     customerId: order.customerId,
//                     deliveryCharges: order.deliveryCharges,
//                     orderDeliveredDate: order.orderDeliveredDate,
//                     orderId: order.orderId,
//                     orderItems: order.orderItems,
//                     orderPlacedDate: order.orderPlacedDate,
//                     paymentMode: order.paymentMode,
//                     productIds: order.productIds,
//                     productsTotal: order.productsTotal,
//                     serviceTax: order.serviceTax,
//                     subTotal: order.subTotal.toString(),
//                     supermarketAddress: order.supermarketAddress,
//                     supermarketId: order.supermarketId,
//                     orderStatus: order.orderStatus,
//                     supermarketName: order.supermarketName,
//                     updateDelivery: () async {
//                       print(order.documentId);
//                       bool response;
//                       if (order.deliveryType == "delivery") {
//                         response = await appState.updateDeliveryStatus(
//                             orderId: order.documentId,
//                             status: "Ready For Pickup",
//                             deliveryBoyId: deliveryboy.boyId,
//                             deliveryBoyName: deliveryboy.boyName);
//                       } else {
//                         response = await appState.updateDeliveryStatus(
//                             orderId: order.documentId,
//                             status: "Ready For Pickup",
//                             deliveryBoyId: "",
//                             deliveryBoyName: "");
//                       }
//                       if (response) {
//                         print("Status Updated");
//                       } else {
//                         print("Update failed");
//                       }
//                     },
//                   );
//                 }),
//           ),
//           SizedBox(
//             height: 10.0,
//           ),
//           FlatButton(
//             onPressed: null, //() async =>
//             //appState.fetchCustomerOrders(moreFetchBtn: true),
//             child: Text("VIEW MORE ORDERS",
//                 style: Theme.of(context).textTheme.button.copyWith(
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.bold)),
//             padding: EdgeInsets.all(0),
//           ),
//           SizedBox(
//             height: 10.0,
//           ),
//         ],
//       ),
//     );
//   }
// }
