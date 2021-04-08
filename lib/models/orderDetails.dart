import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String documentId;
  String orderId;
  double commission;
  String customerId;
  String customerName;
  String supermarketId;
  String supermarketName;
  String supermarketAddress;
  String productsTotal;
  String deliveryCharges;
  int deliverySlot;
  String tokenNumber;
  //String serviceTax;
  Timestamp orderPlacedDate;
  Timestamp orderDeliveredDate;
  String paymentMode;
  String deliveryType;
  String orderStatus;
  List<ProductIds> productIds;
  List<OrderItems> orderItems;
  int subTotal;
  CustomerOrderAddress customerAddress;
  Order({this.commission,this.tokenNumber,this.deliverySlot,this.orderStatus,this.documentId,this.productIds,this.orderDeliveredDate,this.customerName,this.deliveryType,this.customerAddress,this.customerId,this.deliveryCharges,this.orderPlacedDate,this.orderId,this.orderItems,this.paymentMode,this.productsTotal,this.subTotal,this.supermarketAddress,this.supermarketId,this.supermarketName});
  factory Order.fromJson(Map<String,dynamic> json){
    var orderItems = json['orderItems'] as List;
    var listProductIds = json['productIds'] as List;
    List<ProductIds> productIdsList = listProductIds.map((e) => ProductIds(productId: e)).toList();
    List<OrderItems> orderItemList = orderItems.map((e) => OrderItems.fromJson(e)).toList();
    var custAddress = CustomerOrderAddress.fromJson(json['customerAddress']);
    return Order(
      documentId: json['documentID'],
      customerAddress: custAddress,
      customerId: json['customerId'],
      deliveryCharges: json['deliveryCharges'],
      orderPlacedDate: json['orderPlacedDate'],
      orderId: json['orderId'],
      orderItems: orderItemList,
      paymentMode: json['paymentMode'],
      productsTotal: json['productsTotal'],
      subTotal: json['subTotal'],
      supermarketAddress: json['supermarketAddress'],
      supermarketId: json['supermarketId'],
      supermarketName: json['supermarketName'],
      customerName: json['customerName'],
      orderDeliveredDate: json['deliveredDate'],
      //serviceTax: json['serviceTax'],
      deliveryType: json['orderType'],
      orderStatus: json["orderStatus"],
      productIds : productIdsList,
      deliverySlot : json['deliverySlot'],
      tokenNumber: json['tokenNumber'],
      commission: json['commission'],
    );
  }
}
class ProductIds{
  String productId;
  ProductIds({this.productId});
}
class OrderItems{
  String productName;
  String productQty;
  String productTotal;
  OrderItems({
    this.productName,
    this.productQty,
    this.productTotal,
  });
  factory OrderItems.fromJson(Map<String,dynamic> json){
    return OrderItems(
      productName : json['productName'],
      productQty : json['productQty'],
      productTotal : json['productTotal'],
    );
  }
}
class CustomerOrderAddress{
  String area;
  String houseNo;
  String landMark;
  String location;
  String locationType;
  GeoPoint customerLatLng;
  CustomerOrderAddress({
   this.area,this.customerLatLng,this.location,this.landMark,this.houseNo,this.locationType
  });
  CustomerOrderAddress.fromJson(Map<String,dynamic> json):
    area = json['area'],
    customerLatLng = json['locationPoint']['geopoint'],
    houseNo = json['houseNo'],
    landMark = json['landmark'],
    locationType = json['locationType'];
}