import 'package:cloud_firestore/cloud_firestore.dart';

class FishBusiness {
  String businessName;

  String businessId;
  GeoPoint supermarketLocation;
  String pinCode;
  String landMark;
  String vendorName;
  String vendorId;
  String overallReview;
  bool productAvailable;

  FishBusiness(
      {this.overallReview,
      this.businessName,
      this.supermarketLocation,
      this.pinCode,
      this.landMark,
      this.vendorName,
      this.vendorId,
      this.businessId,this.productAvailable});
  FishBusiness.fromJson(Map<String, dynamic> json)
      : this.businessName = json['businessName'],
        this.supermarketLocation = json['location']['geopoint'],
        this.pinCode = json['pinCode'],
        this.landMark = json['landMark'],
        this.vendorName = json['vendorName'],
        this.vendorId = json['vendorId'],
        this.productAvailable = json['productAvailable'],
        this.overallReview = json['overallReview'].toString();

  FishBusiness.fromSnapshot(DocumentSnapshot snapshot)
      : this.businessName = snapshot.data()['businessName'],
        this.supermarketLocation = snapshot.data()['location']['geopoint'],
        this.pinCode = snapshot.data()['pinCode'],
        this.landMark = snapshot.data()['landMark'],
        this.overallReview = snapshot.data()['overallReview'].toString(),
        this.vendorName = snapshot.data()['vendorName'],
        this.businessId = snapshot.id,
        this.productAvailable = snapshot.data()['productAvailable'],
        this.vendorId = snapshot.data()['vendorId'];
}
