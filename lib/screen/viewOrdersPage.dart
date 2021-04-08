import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/deliveryBoy.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/util/themedata.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/orderView.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String filter = "1";
  final _formKeyOrders = new GlobalKey<FormState>(debugLabel: "formKeyOrders");
  @override
  Widget build(BuildContext context) {
    SupermarketDetails supermarketDetails = ModalRoute.of(context).settings.arguments;
    String supermarketId = supermarketDetails.superMarketID;
    String accountId = supermarketDetails.accountId;
    return SafeArea(
      child: DefaultTabController(

        length: 2,
        child: Scaffold(
         persistentFooterButtons: <Widget>[
          Container(
            width: fullWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    OutlineButton(onPressed: (){
                      setState(() {
                        filter = "1";
                      });
                      print("hm");
                    },child: Text("Slot 1",style: Theme.of(context).textTheme.bodyText2),color: Colors.red,borderSide: BorderSide(
                      color: //Colors.red
                      filter == "1" ? Colors.red : Colors.grey
                    ),),SizedBox(width: 8.0,),
                    Text("Morning orders")
                  ],
                ),
                Row(
              children: <Widget>[
                OutlineButton(onPressed: (){
                  print("hm");
                  setState(() {
                    filter = "2";
                  });
                },child: Text("Slot 2",style: Theme.of(context).textTheme.bodyText2),color: Colors.red,borderSide: BorderSide(
                  color: //Colors.red
                  filter == "2" ? Colors.red : Colors.grey
                ),),SizedBox(width: 8.0,),
                Text("Evening orders")
              ],
            ),
              ],
            ),
          ), 
         ],
          bottomNavigationBar: BottomNavigationBar(items: [
            BottomNavigationBarItem(icon: Icon(Icons.swap_vert),label: "Orders",),
            BottomNavigationBarItem(icon: Icon(Icons.warning),label: "Low Stock",)
          ],onTap: (index){
            print(index);
            if(index == 1){
              Navigator.pushNamed(context, '/lowStock',arguments: supermarketDetails);
            }
          },currentIndex: 0,),
            appBar: AppBar(
              
              bottom: TabBar(
                onTap: (index) {
                  print(index);
                },
                tabs: [
                  Tab(
                    icon: Icon(Icons.calendar_today),
                    text: "Today",
                  ),
                  Tab(
                    icon: Icon(Icons.repeat),
                    text: "Re-attempt",
                  ),
                ],
              ),
              title: TitleTextBuilder(
                sendText: "Orders Page",
              ),
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pushNamed(context, '/supermarketlist')),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("grocery/orders/orderList")
                  .where("supermarketId", isEqualTo: supermarketId)
                  //.where("cancelOrder",isEqualTo: false)
                  .where("orderStatus", whereIn: ["Order Placed", "Re-attempt"])
                  .orderBy("orderPlacedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                final appState = Provider.of<AppState>(context);
                var deliveryboy = appState.deliveryBoyDetails;
                List<Order> orders = [];
                var children;
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    children = Container(
                        width: fullWidth(context),
                        height: fullHeight(context),
                        child: Center(child: CircularProgressIndicator()));
                    break;
                  default:
                    if (snapshot.hasError)
                      children = [Text('Error: ${snapshot.error}')];
                    else {
                      print("else statement in stream running...");
                      orders = snapshot.data.docs.map((e) {
                        Map<String, dynamic> moreData = e.data();
                        Map<String, dynamic> productIdMap = {
                          'documentID': e.id
                        };
                        Map<String, dynamic> mergedMap = {};
                        mergedMap.addAll(moreData);
                        mergedMap.addAll(productIdMap);
                        return Order.fromJson(mergedMap);
                      }).toList();
                      var filterSlotOrders = orders.where((element) => element.deliverySlot == int.parse(filter)).toList();
                      children = orders.length == 0 ? Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.hourglass_empty,size: 80,color: greyColor,),
                          Text("No Orders Yet",style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),) :
                      TabBarView(
                        children: [
                          TodayOrders(
                            accountId: accountId,
                              appState: appState,
                              orderList: filterSlotOrders,
                              deliveryboy: deliveryboy,
                              formKey: _formKeyOrders,
                              ),
                          ReAttemptOrders(
                            accountId: accountId,
                            appState: appState,
                            orderList: filterSlotOrders,
                            deliveryboy: deliveryboy,
                            formKey: _formKeyOrders,
                            ),
                        ],
                      );
                    }
                }
                print("::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                return children;
                //Column(children: children);
              },
            )
            ),
      ),
    );
  }
}

class ReAttemptOrders extends StatelessWidget {
  const ReAttemptOrders({
    Key key,
    @required this.deliveryboy,
    @required this.orderList,
    @required this.appState,
    this.accountId,
    this.formKey
  }) : super(key: key);
  final List<Order> orderList;
  final AppState appState;
  final DeliveryBoyDetails deliveryboy;
  final GlobalKey<FormState> formKey;
  final String accountId;
  @override
  Widget build(BuildContext context) {
    var todaysOrderDetails = orderList
        .where((element) => element.orderStatus == "Re-attempt")
        .toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: <Widget>[

            Expanded(
                child: ListView.builder(
                itemCount: todaysOrderDetails == null ? 0 : todaysOrderDetails.length,
                itemBuilder: (BuildContext context, int index) {      
                  var order = todaysOrderDetails[index];
                  print("order type: ${order.deliveryType}");
                  return OrdersList(
                    customerAddress: order.customerAddress,
                    customerId: order.customerId,
                    deliveryCharges: order.deliveryCharges,
                    orderDeliveredDate: order.orderDeliveredDate,
                    orderId: order.orderId,
                    orderItems: order.orderItems,
                    orderPlacedDate: order.orderPlacedDate.toDate(),
                    paymentMode: order.paymentMode,
                    productIds: order.productIds,
                    productsTotal: order.productsTotal,
                   // serviceTax: order.serviceTax,
                    subTotal: order.subTotal.toString(),
                    //: order.supermarketAddress,
                    supermarketId: order.supermarketId,
                    orderStatus: order.orderStatus,
                    cancelorder: ()async{
                      //cncel delivery button not working !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                      DateTime dateOrder = order.orderPlacedDate.toDate();
                      DateTime now = DateTime.now();
                      int difference = now.difference(dateOrder).inHours;
                      print("order diffference: $difference");
                      if(difference == 0){
                        AwesomeDialog(
                          context: context,
                          btnCancel: RaisedButton(onPressed: ()async => Navigator.pop(context), child: Text("cancel")),
                          btnOkColor: Colors.red,
                          headerAnimationLoop: false,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.SCALE,
                          body: Form(
                            key: formKey,
                            child: Column(
                            children: <Widget>[
                              TextFormField(
                                maxLines: 2,
                                controller: appState.orderCancelNote,
                                validator: (value){
                                  if(value.length == 0){
                                    return "Required";
                                  }return null;
                                },
                              ),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(onPressed: (){
                                     if(formKey.currentState.validate()){
                                       print("validate");
                                      appState.cancelOrder(order.documentId).then((value) => print("Cencel Order Clicked"));
                                     }
                                  }, child: Text("cancel order")),
                                  RaisedButton(onPressed: () => Navigator.pop(context), child: Text("close"))
                                ],
                              )
                            ],
                          ))
                        )..show();
                        
                      }else{
                        print("hello");
                        AwesomeDialog(
                          context: context,
                          btnCancel: RaisedButton(onPressed: ()async => Navigator.pop(context), child: Text("cancel")),
                          btnOkColor: Colors.red,
                          headerAnimationLoop: false,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.BOTTOMSLIDE,
                          title: "1 Hour Exceeded",
                          desc: ""
                        )..show();
                      }
                    },
                    //supermarketName: order.supermarketName,
                    updateDelivery: () async {
                      print(order.documentId);
                      bool response;
                      print(order.deliveryType);
                      if (order.deliveryType == "Delivery") {
                        response = await appState.updateDeliveryStatus(

                          accountId: accountId,
                            orderId: order.documentId,
                            status: "Order Packed",
                            deliveryBoyId: deliveryboy.boyId,
                            deliveryBoyName: deliveryboy.boyName);
                      } else {
                        response = await appState.updateDeliveryStatus(
                          accountId: accountId,
                            orderId: order.documentId,
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
                   
                  );
               },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            // FlatButton(
            //   onPressed: null, //() async =>
            //   //appState.fetchCustomerOrders(moreFetchBtn: true),
            //   child: Text("VIEW MORE ORDERS",
            //       style: Theme.of(context).textTheme.button.copyWith(
            //           color: Theme.of(context).primaryColor,
            //           fontWeight: FontWeight.bold)),
            //   padding: EdgeInsets.all(0),
            // ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
class TodayOrders extends StatelessWidget {
  const TodayOrders({
    Key key,
    @required this.orderList,
    @required this.deliveryboy,
    @required this.appState,
    this.formKey,
    this.accountId
  }) : super(key: key);
  final String accountId;
  final List<Order> orderList;
  final AppState appState;
  final DeliveryBoyDetails deliveryboy;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    var reAttempOrderDetails = orderList
        .where((element) => element.orderStatus == "Order Placed")
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                //shrinkWrap: true,
                itemCount: reAttempOrderDetails == null
                    ? 0
                    : reAttempOrderDetails.length,
                itemBuilder: (context, index) {
                  var order = reAttempOrderDetails[index];
                  print("order type: ${order.deliveryType}");
                  return Card(
                    elevation: 5.0,
                      margin: EdgeInsets.only(top:15.0),
                      child: OrdersList(
                      slotNumber: order.deliverySlot,
                      tokenNumber: order.tokenNumber,
                      customerAddress: order.customerAddress,
                      customerId: order.customerId,
                      deliveryCharges: order.deliveryCharges,
                      orderDeliveredDate: order.orderDeliveredDate,
                      orderId: order.orderId,
                      orderItems: order.orderItems,
                      orderPlacedDate: order.orderPlacedDate.toDate(),
                      paymentMode: order.paymentMode,
                      productIds: order.productIds,
                      productsTotal: order.productsTotal,
                      //serviceTax: order.serviceTax,
                      subTotal: order.subTotal.toString(),
                      //supermarketAddress: order.supermarketAddress,
                      supermarketId: order.supermarketId,
                      orderStatus: order.orderStatus,
                      cancelorder: ()async{
                        DateTime dateOrder = order.orderPlacedDate.toDate();
                        print("cancel order database time : $dateOrder");
                        DateTime now = DateTime.now();
                        int difference = now.difference(dateOrder).inHours;
                        print("order diffference during cancel order: $difference");
                        if(difference <= 0){
                          AwesomeDialog(

                            context: context,
                            //btnCancel: RaisedButton(onPressed: ()async => Navigator.pop(context), child: Text("close")),
                            btnOkColor: Colors.red,
                            headerAnimationLoop: false,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.SCALE,
                            body: Form(
                              key: formKey,
                              child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Reason?"
                                  ),
                                  maxLines: 2,
                                  controller: appState.orderCancelNote,
                                  validator: (value){
                                    if(value.length == 0){
                                      return "Required";
                                    }return null;
                                  },
                                ),
                                SizedBox(height:10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(onPressed: (){
                                       if(formKey.currentState.validate()){
                                         print("validate");
                                        appState.cancelOrder(order.documentId).then((value) { 
                                          appState.orderCancelNote.clear();
                                          Navigator.pushReplacementNamed(context, '/viewOrdersPage',arguments:order.supermarketId);
                                        });
                                        
                                       }
                                    }, child: Text("Submit")),
                                    RaisedButton(onPressed: () => Navigator.pop(context), child: Text("close"))
                                  ],
                                )
                              ],
                            ))
                          )..show();
                          
                        }else{
                          print("hello");
                          AwesomeDialog(
                            context: context,
                           // btnCancel: RaisedButton(onPressed: ()async => Navigator.pop(context), child: Text("close")),
                            btnOkColor: Colors.red,
                            headerAnimationLoop: false,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            title: "1 Hour Exceeded",
                            desc: ""
                          )..show();
                        }
                      },
                      customerName: order.customerName,
                      updateDelivery: () async {
                        print(order.documentId);
                        bool response;
                        if (order.deliveryType == "Delivery") {
                          response = await appState.updateDeliveryStatus(
                            accountId: accountId,
                              orderId: order.documentId,
                              status: "Order Packed",
                              deliveryBoyId: deliveryboy.boyId,
                              deliveryBoyName: deliveryboy.boyName);
                        } else {
                          response = await appState.updateDeliveryStatus(
                            accountId: accountId,
                              orderId: order.documentId,
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
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 20.0,
          ),
          // FlatButton(
          //   onPressed: null, //() async =>
          //   //appState.fetchCustomerOrders(moreFetchBtn: true),
          //   child: Text("VIEW MORE ORDERS",
          //       style: Theme.of(context).textTheme.button.copyWith(
          //           color: Theme.of(context).primaryColor,
          //           fontWeight: FontWeight.bold)),
          //   padding: EdgeInsets.all(0),
          // ),
         
        ],
      ),
    );
  }
}
