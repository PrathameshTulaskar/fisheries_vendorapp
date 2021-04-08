import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/fishProduct.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';

class TodaysOrder extends StatefulWidget {
  const TodaysOrder({Key key}) : super(key: key);

  @override
  _TodaysOrderState createState() => _TodaysOrderState();
}

class _TodaysOrderState extends State<TodaysOrder> {
  final _formKeyOrders =
      new GlobalKey<FormState>(debugLabel: "formFishKeyOrders");
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    // final closingTime = Provider.of<ClosingTime>(context);
    var deliveryboy = appState.deliveryBoyDetails;
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: Container(
              // height: 50,
              width: 150,
              decoration: BoxDecoration(color: Colors.blue),
              child: StopSellingButton()),
          appBar:
              // AppBar(),
              AppBar(
                leading:IconButton(icon:Icon(Icons.arrow_back),onPressed:()=>Navigator.pushNamed(context, '/vendorBusinessCard')),
            bottom: TabBar(
              onTap: (index) {
                print(index);
              },
              tabs: [
                Tab(
                  icon: Icon(Icons.calendar_today),
                  text: "Today's Order",
                ),
                Tab(
                  icon: Icon(Icons.repeat),
                  text: "Product Status",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("grocery/orders/orderList")
                        .where("businessId",
                            isEqualTo: appState.fishBusiness.businessId)
                        //.where("cancelOrder",isEqualTo: false)
                        .where("orderStatus", whereIn: ["Order Placed"])
                        .orderBy("orderPlacedDate", descending: true)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      var orderDetails = snapshot.data.docs
                          .map((e) => Order.fromJson(e.data()))
                          .toList();
                      var orderDocumentIds =
                          snapshot.data.docs.map((e) => e.id).toList();
                      return
                          // Column(
                          //   children: [
                          //     SizedBox(height: 15),
                          //     Center(
                          //       child: Text("Business Closing Time: ${closingTime.timing}",
                          //           style: TextStyle(fontSize: 20.0)),
                          //     ),
                          //     SizedBox(height: 15),
                          Column(
                        children:
                            List<Widget>.generate(orderDetails.length, (index) {
                          var orderDocument = orderDocumentIds[index];

                          return OrderCard(
                            order: orderDetails[index],
                            onApprovePressed: () async {
                              bool response;
                              print(orderDetails[index].deliveryType);
                              if (orderDetails[index].deliveryType ==
                                  "Delivery") {
                                response = await appState.updateDeliveryStatus(
                                    accountId: "NUll",
                                    orderId: orderDocument,
                                    status: "Order Packed",
                                    deliveryBoyId: deliveryboy.boyId,
                                    deliveryBoyName: deliveryboy.boyName);
                              } else {
                                response = await appState.updateDeliveryStatus(
                                    accountId: "Null",
                                    orderId: orderDocument,
                                    status: "Ready For Pickup",
                                    deliveryBoyId: "",
                                    deliveryBoyName: "");
                              }

                              if (response) {
                                print("Status Updated");
                              } else {
                                print("Update failed");
                              }
                            },
                            onDeclidePressed: () async {
                              //cncel delivery button not working !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                              DateTime dateOrder =
                                  orderDetails[index].orderPlacedDate.toDate();
                              DateTime now = DateTime.now();
                              int difference =
                                  now.difference(dateOrder).inHours;
                              print("order diffference: $difference");
                              if (difference == 0) {
                                AwesomeDialog(
                                    context: context,
                                    btnCancel: ElevatedButton(
                                        onPressed: () async =>
                                            Navigator.pop(context),
                                        child: Text("cancel")),
                                    btnOkColor: Colors.red,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.WARNING,
                                    animType: AnimType.SCALE,
                                    body: Form(
                                        key: _formKeyOrders,
                                        child: Column(
                                          children: <Widget>[
                                            TextFormField(
                                              maxLines: 2,
                                              controller:
                                                  appState.orderCancelNote,
                                              validator: (value) {
                                                if (value.length == 0) {
                                                  return "Required";
                                                }
                                                return null;
                                              },
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                ElevatedButton(
                                                    onPressed: () {
                                                      if (_formKeyOrders
                                                          .currentState
                                                          .validate()) {
                                                        print("validate");
                                                        appState
                                                            .cancelOrder(
                                                                orderDocument)
                                                            .then((value) => print(
                                                                "Cancel Order Clicked"));
                                                      }
                                                    },
                                                    child:
                                                        Text("cancel order")),
                                                ElevatedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("close"))
                                              ],
                                            )
                                          ],
                                        )))
                                  ..show();
                              } else {
                                print("hello");
                                AwesomeDialog(
                                    context: context,
                                    btnCancel: ElevatedButton(
                                        onPressed: () async =>
                                            Navigator.pop(context),
                                        child: Text("cancel")),
                                    btnOkColor: Colors.red,
                                    headerAnimationLoop: false,
                                    dialogType: DialogType.WARNING,
                                    animType: AnimType.BOTTOMSLIDE,
                                    title: "1 Hour Exceeded",
                                    desc: "")
                                  ..show();
                              }
                            },
                          );
                        }),
                      );
                      //   ],
                      // );
                    },
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        "grocery/products/productList/${appState.fishBusiness.businessId}/fishProducts")
                    .snapshots(),
                builder: (context, snapshot) {
                  var fishProduct = snapshot.data.docs == null
                      ? [FishProduct()]
                      : snapshot.data.docs
                          .map((e) => FishProduct.fromSnapshot(e))
                          .toList();
                  var children = <Widget>[];
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      children = [
                        Container(
                            width: fullWidth(context),
                            height: fullHeight(context),
                            child: Center(child: CircularProgressIndicator()))
                      ];
                      break;
                    default:
                      if (snapshot.hasError)
                        children = [Text('Error: ${snapshot.error}')];
                      else {
                        fishProduct.length == 0
                            ? children = null
                            : fishProduct.forEach((element) {
                                //appState.getOurFishProduct().forEach((element) {
                                children.add(ProductStatus(
                                    productId: element.productId,
                                    productName: element.productName,
                                    productStatus:
                                        element.productStatus.toString(),
                                    stockAvailable:
                                        element.stockAvailable.toString(),
                                    price: element.price.toString(),
                                    productImg: element.productImg));
                              });
                        //data
                      }
                  }

                  return children == null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          width: fullWidth(context),
                        )
                      : GridView.count(
                          crossAxisCount: 1,
                          //crossAxisSpacing: 5.80,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 3.70,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: children,
                        );
                  //Column(children: children);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StopSellingButton extends StatelessWidget {
  const StopSellingButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        // shape: Border.all(width: 1),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(5.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Stop Selling',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.0)),
          ),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white)),
        // color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final appState = Provider.of<AppState>(context);
              return AlertDialog(
                title: Text('Stop Selling'),
                actions: [
                  TextButton(
                    child: Text('No'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[50])),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                      child: Text('Yes'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[50])),
                      onPressed: () async {
                        await appState.resetFishBusinessProduct();
                        Navigator.pushNamed(context, '/todaysSale');
                      }),
                ],
                content: StopSelling(),
              );
            },
          );
        });
  }
}

class StopSelling extends StatelessWidget {
  const StopSelling({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 300,
      child: Row(children: [
        Text('Stop selling for today?'),
      ]),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Function onApprovePressed;
  final Function onDeclidePressed;
  final Order order;
  // final String orderDocumentId;
  const OrderCard({
    Key key,
    this.order,
    this.onApprovePressed,
    this.onDeclidePressed,
    // this.orderDocumentId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(order.orderItems[0].productName);
    final orderTime =
        DateFormat("h:mma").format(order.orderPlacedDate.toDate());
    return
        // Text(order.orderItems[0].productName);
        Container(
      // height: 220,
      // width: MediaQuery.of(context).size.width,
      child: Card(
          color: Colors.grey[200],

          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(4.0),
          // //         bottomRight: Radius.circular(4.0)),
          //     side: BorderSide(
          //         color: Colors.black, width: 1)),

          child: Container(
            // width: MediaQuery.of(context).size.width * 0.90,
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text("Order Id: "),
                          Text(order.orderId,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))
                        ],
                      ),
                      Row(
                        children: [
                          Text("Order Time: "),
                          Text(orderTime,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      )
                    ]),
                SizedBox(height: 15),
                Center(
                    child: Text(
                  order.customerName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Text("Bill Total"),
                      Text("Rs. ${order.subTotal.toString()}/-")
                    ]),
                    TextButton(
                        style: ButtonStyle(
                            // minimumSize:
                            //     MaterialStateProperty.all(Size.fromHeight(46)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[200])),

                        // minWidth:
                        //     MediaQuery.of(context).size.width * 0.489,

                        child: Text("order  Details",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Order Details',
                            body: Column(
                                children: List<Widget>.generate(
                                    order.orderItems.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 8, bottom: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(order.orderItems[index].productName),
                                      Text(order.orderItems[index].productQty),
                                      // Text(order.orderItems[index].productQty),
                                      
                                    ]),
                              );
                            })),
                            // btnCancelOnPress: () {},
                            // btnOkOnPress: () {}
                          ).show();
                        }),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )),
                              // minimumSize: MaterialStateProperty.all(
                              //     Size.fromHeight(46)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: Text("Decline",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          onPressed: onApprovePressed),
                      TextButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              )),
                              // minimumSize: MaterialStateProperty.all(
                              //     Size.fromHeight(46)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.zero,
                          // ),
                          // height: 46,
                          // minWidth: MediaQuery.of(context).size.width * 0.3885,
                          // color: Colors.green,
                          child: Text("Approve",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          onPressed: onApprovePressed),
                    ]),
                SizedBox(height: 10),
              ],
            ),
          )),
    );
  }
}

class ProductStatus extends StatefulWidget {
  final String productName;
  final String stockAvailable;
  final String productStatus;
  final String productImg;
  final String price;
  final String productId;
  ProductStatus({
    Key key,
    this.productId,
    this.productName,
    this.stockAvailable,
    this.productStatus,
    this.productImg,
    this.price,
  }) : super(key: key);
  @override
  _ProductStatusState createState() => _ProductStatusState();
}

class _ProductStatusState extends State<ProductStatus> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    bool isToggled2 = true;
    bool isToggled = !(isToggled2);
    final _formKey = GlobalKey<FormState>();

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Image.network(widget.productImg),
          SizedBox(width: 5),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fish Name: ${widget.productName}"),
                SizedBox(height: 5),
                Text("Price: ${widget.price}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stock: ${widget.stockAvailable}"),
                    SizedBox(width: 30),
                    Container(
                        height: 32,
                        decoration:
                            BoxDecoration(color: Colors.red.withOpacity(0.8)),
                        child: TextButton(
                          
                          child: Text("Update", style: TextStyle(fontSize: 12,color:Colors.black)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(widget.productName ?? "fishName"),
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                  content: Container(
                                    height: 150,
                                    width: 300,
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 300,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: appState
                                                  .productTotalQuantityController,
                                              decoration: InputDecoration(
                                                  labelText: 'Stock Available'),
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
                                                  return 'Text is empty';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 300,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: appState
                                                  .productPricePerKGController,
                                              decoration: InputDecoration(
                                                  labelText: 'price'),
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
                                                  return 'Text is empty';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: Text('Done'),
                                            // color: Colors.blue[50],
                                            onPressed: () {
                                              Navigator.pop(context);
                                              appState.updateproductDetails(
                                                  todayOrder: true);
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )),
                    SizedBox(width: 50),
                    // Container(
                    //   height: 20.0,
                    //   width: 40.0,
                    //   child: Switch(
                    //     value: appState.productActive,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         print(value);
                    //         appState.setProductActive = value;
                    //         isToggled = !value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    FlutterSwitch(
                      height: 20.0,
                      width: 40.0,
                      padding: 4.0,
                      toggleSize: 15.0,
                      borderRadius: 10.0,
                      activeColor: Colors.blue,
                      value: appState.productActive,
                      onToggle: (value) {
                        var fishDetail = FishProduct(
                          productId: widget.productId,
                        );
                        // appState.setProductActive = value;

                        print('$value');
                        // setState(() {
                        appState.setProductActive = value;
                        isToggled = value ? false : true;
                        appState.updateVendorPoductStatus(
                            appState.productActive, fishDetail);
                        // });
                      },
                    ),
                  ],
                ),
              ]),
          SizedBox(height: 5),
        ]),
      ),
    );
  }
}
