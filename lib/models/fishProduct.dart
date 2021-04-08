import 'package:cloud_firestore/cloud_firestore.dart';

class FishProduct {
  String productId;
   int originalPrice;
   int price;
   String productCategory;
   String productImg;
   String productName;
   int productPieces;
  bool productStatus;
   int productWeight;
   int stockAvailable;
  //String productStatus;
  FishProduct({
   // this.totalQuantity,
  //this.pricePerKG,
   this.originalPrice,
   this.price,
   this.productCategory,
   this.productImg,
   this. productName,
   this.productPieces,
  this.productId,
   this.productWeight,
   this.stockAvailable,
  this.productStatus,
  });
  FishProduct.fromSnapshot(DocumentSnapshot snapshot):
   //this.totalQuantity =json['totalQuantity'],
   //this.pricePerKG =json['pricePerKG'];\
   this.originalPrice =snapshot.data()['originalPrice'],
   this.price =snapshot.data()['price'],
   this.productCategory =snapshot.data()['productCategory'],
   this.productImg =snapshot.data()['productImg'],
   this. productName =snapshot.data()['productName'],
   this.productPieces =snapshot.data()['productPieces'],
  this.productStatus=snapshot.data()['productStatus'],
   this.productWeight =snapshot.data()['productWeight'],
   this.productId = snapshot.id,
   this.stockAvailable =snapshot.data()['stockAvailable'];
  
}