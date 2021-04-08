import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerReviews {
  String profile;
  int  rating;
  String userName;
  String review;
  //String productStatus;
  CustomerReviews({
   // this.totalQuantity,
  //this.pricePerKG,
 this.profile,
 this.rating,
 this.userName,
 this.review,
  });
  CustomerReviews.fromSnapshot(DocumentSnapshot snapshot):
   //this.totalQuantity =json['totalQuantity'],
   //this.pricePerKG =json['pricePerKG'];\
   this.profile =snapshot.data()['profile'],
   this.rating =snapshot.data()['rating'],
   this.userName =snapshot.data()['userName'],
   this.review =snapshot.data()['review'];
  
  
}