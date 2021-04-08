import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
//import 'package:fisheries_vendorapp/util/themedata.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  final String customerName;
  final String commission;
  final String orderId;
  final Timestamp orderDeliveredDate;
  final List<OrderItems> orderItems;
  final String productsTotal;
  final String deliveryCharges;
  final Timestamp orderPlacedDate;
  final String paymentMode;
  final String supermarketName;
  final String supermarketAddress;
  final String serviceTax;
  final CustomerOrderAddress customerAddress;
  final String subTotal;
  const OrderDetails(
      {Key key,
      this.commission,
      this.serviceTax,
      this.customerName,
      this.orderDeliveredDate,
      this.subTotal,
      this.customerAddress,
      this.deliveryCharges,
      this.orderId,
      this.orderItems,
      this.orderPlacedDate,
      this.paymentMode,
      this.productsTotal,
      this.supermarketAddress,
      this.supermarketName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      String orderPlacedFormattedDate;
      if(orderDeliveredDate != null){
        var date = orderDeliveredDate.toDate();
        orderPlacedFormattedDate = DateFormat.yMd().add_jm().format(date); 
      }
    var orderItemsTotal =
        orderItems == null ? "" : orderItems.length.toString();
    var customerAdd = customerAddress.landMark;
    var children = <Widget>[];
    orderItems.forEach((element) {
      var productNameQty = element.productName + " x " + element.productQty;
      var orders = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //Text(productNameQty ?? ""),
          Container(width: fullWidth(context) * 0.83,child: Text(productNameQty ?? "")),
          Text("\u20b9 ${element.productTotal}")
        ],
      );
      children.add(orders);
    });
    Widget icon;
    String locationTypeFiltered;
    switch (customerAddress.locationType) {
      case "Home":
        icon = Icon(Icons.home);
        locationTypeFiltered = customerAddress.locationType;
        break;
      case "Work":
        icon = Icon(Icons.work);
        locationTypeFiltered = customerAddress.locationType;
        break;
      default:
        {
          icon = Icon(Icons.location_on);
          locationTypeFiltered = customerAddress.area;
        }
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: BackButton(color: blackColor),
        bottom: PreferredSize(
            child: Container(
              color: blackColor,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        backgroundColor: whiteColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("ORDER $orderId",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: blackColor)),
            Text("Delivered,$orderItemsTotal Items, \u20b9 $subTotal.00",
                style: Theme.of(context)
                    .textTheme
                    .overline
                    .copyWith(color: greyColor))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: fullWidth(context),
          height: fullHeight(context),
          decoration: BoxDecoration(color: backgroundGrey),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: whiteColor),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 32.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    supermarketName ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                  Text(supermarketAddress ?? "",
                                      style: TextStyle(color: greyColor))
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: VerticalLine(),
                          ),
                          Row(
                            children: <Widget>[
                              icon,
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    customerName ?? "",
                                    //customerAddress.addressName ?? "",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Text(
                                    customerAddress.landMark ?? "",
                                    //customerAdd ?? "",
                                    style: TextStyle(color: greyColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                color: whiteColor,
                child: Column(
                  children: <Widget>[
                    Divider(
                      color: greyColor,
                      thickness: 0.3,
                      height: 0,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      title: Text(
                          "Order Delivered on ${orderPlacedFormattedDate ?? ""}"),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                //decoration: BoxDecoration(color: Colors.grey[200]),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, bottom: 10.0, top: 30.0),
                  child: Text(
                    "DETAILS",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.bold, color: greyColor),
                  ),
                ),
              ),
              Container(
                color: whiteColor,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: children,
                      ),
      //               Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: <Widget>[
      //     //Text(productNameQty ?? ""),
      //     Container(width: fullWidth(context) * 0.83,child: Text("rawa x 2")),
      //     Text("\u20b9 233")
      //   ],
      // ),
                      SizedBox(
                        height: 20,
                      ),
                      MySeparator(
                        color: greyColor,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Item Total"),
                          Text("\u20b9 $productsTotal"),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     Text("Delivery Charges"),
                      //     Text("\u20b9 $deliveryCharges"),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Taxes"),
                          Text("\u20b9 ${serviceTax ?? 0}"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Product Commission"),
                          Text("\u20b9 ${commission ?? 0}"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: blackColor,
                        thickness: 0.3,
                        height: 0,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Paid Via $paymentMode"),
                          Text(
                            "Total \u20b9 ${double.parse(productsTotal) - double.parse(commission)}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class VerticalLine extends StatelessWidget {
  const VerticalLine({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //final boxWidth = 100;
        //constraints.constrainWidth();
        final dashWidth = 1.0;
        final dashHeight = 5.0;
        final dashCount = 5;
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: greyColor),
              ),
            );
          }),
          direction: Axis.vertical,
        );
      },
    );
  }
}
