import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatefulWidget {
  OrderHistory({Key key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {

  final _formKeyOrders = new GlobalKey<FormState>(debugLabel: "formKeyOrders");
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: <Widget>[],

        appBar: AppBar(
          title: TitleTextBuilder(
            sendText: "Orders History",
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.pushNamed(context, '/vendorBusinessCard')),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("grocery/orders/orderList")
                    .where("businessId",
                        isEqualTo: appState.fishBusiness.businessId)
                  .snapshots(),
                builder: (BuildContext context, snapshot) {
                  
                  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
                  var orderDetails = snapshot.data.docs
                      .map((e) => Order.fromJson(e.data()))
                      .toList();
                  var orderDocumentIds =
                      snapshot.data.docs.map((e) => e.id).toList();
                  return
                
                      Column(
                    children:
                        List<Widget>.generate(orderDetails.length, (index) {
                      var orderDocument = orderDocumentIds[index];
                     
                      return OrderHistoryCard(
                        customerName: orderDetails[index].customerName,
                        custAddress:
                            orderDetails[index].customerAddress.houseNo,
                        productQty:
                            orderDetails[index].orderItems.length.toString(),
                        // productQty: orderDetails[index].subTotal.toString(),
                        productTotal: orderDetails[index].subTotal.toString(),
                        
                      );
                      // OrderCard(
                      //   order: orderDetails[index],
                      //   onApprovePressed: () async {
                      //     bool response;
                      //     print(orderDetails[index].deliveryType);
                      //     if (orderDetails[index].deliveryType == "Delivery") {
                      //       response = await appState.updateDeliveryStatus(
                      //         accountId: "NUll",
                      //         orderId: orderDocument,
                      //         status: "Order Packed",
                      //         // deliveryBoyId: deliveryboy.boyId,
                      //         // deliveryBoyName: deliveryboy.boyName
                      //       );
                      //     } else {
                      //       response = await appState.updateDeliveryStatus(
                      //           accountId: "Null",
                      //           orderId: orderDocument,
                      //           status: "Ready For Pickup",
                      //           deliveryBoyId: "",
                      //           deliveryBoyName: "");
                      //     }

                      //     if (response) {
                      //       print("Status Updated");
                      //     } else {
                      //       print("Update failed");
                      //     }
                      //   },
                      //   onDeclidePressed: () async {
                      //     //cncel delivery button not working !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                      //     DateTime dateOrder =
                      //         orderDetails[index].orderPlacedDate.toDate();
                      //     DateTime now = DateTime.now();
                      //     int difference = now.difference(dateOrder).inHours;
                      //     print("order diffference: $difference");
                      //     if (difference == 0) {
                      //       AwesomeDialog(
                      //           context: context,
                      //           btnCancel: ElevatedButton(
                      //               onPressed: () async => Navigator.pop(context),
                      //               child: Text("cancel")),
                      //           btnOkColor: Colors.red,
                      //           headerAnimationLoop: false,
                      //           dialogType: DialogType.WARNING,
                      //           animType: AnimType.SCALE,
                      //           body: Form(
                      //               key: _formKeyOrders,
                      //               child: Column(
                      //                 children: <Widget>[
                      //                   TextFormField(
                      //                     maxLines: 2,
                      //                     controller: appState.orderCancelNote,
                      //                     validator: (value) {
                      //                       if (value.length == 0) {
                      //                         return "Required";
                      //                       }
                      //                       return null;
                      //                     },
                      //                   ),
                      //                   Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: <Widget>[
                      //                       ElevatedButton(
                      //                           onPressed: () {
                      //                             if (_formKeyOrders.currentState
                      //                                 .validate()) {
                      //                               print("validate");
                      //                               appState
                      //                                   .cancelOrder(
                      //                                       orderDocument)
                      //                                   .then((value) => print(
                      //                                       "Cancel Order Clicked"));
                      //                             }
                      //                           },
                      //                           child: Text("cancel order")),
                      //                       ElevatedButton(
                      //                           onPressed: () =>
                      //                               Navigator.pop(context),
                      //                           child: Text("close"))
                      //                     ],
                      //                   )
                      //                 ],
                      //               )))
                      //         ..show();
                      //     } else {
                      //       print("hello");
                      //       AwesomeDialog(
                      //           context: context,
                      //           btnCancel: ElevatedButton(
                      //               onPressed: () async => Navigator.pop(context),
                      //               child: Text("cancel")),
                      //           btnOkColor: Colors.red,
                      //           headerAnimationLoop: false,
                      //           dialogType: DialogType.WARNING,
                      //           animType: AnimType.BOTTOMSLIDE,
                      //           title: "1 Hour Exceeded",
                      //           desc: "")
                      //         ..show();
                      //     }
                      //   },
                      // );
                    }),
                  );
                  //   ],
                  // );
                },
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}

class OrderHistoryCard extends StatefulWidget {
  String customerName;
  String custAddress;
  String productTotal;
  String productQty;

  OrderHistoryCard(
      {Key key,
      this.customerName,
      this.custAddress,
      this.productTotal,
      this.productQty})
      : super(key: key);
  @override
  _OrderHistoryCardState createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            // height: 100,
            width: MediaQuery.of(context).size.width * 0.90,
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cust. Name: ${widget.customerName}"),
                Text("Cust. Address:${widget.custAddress}"),
                Text("Product Qty:${widget.productQty}"),
                Text("Product Total:${widget.productTotal}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
