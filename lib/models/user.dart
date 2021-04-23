import 'package:cloud_firestore/cloud_firestore.dart';

import 'location.dart';

class UserModel {
  bool intialSlider;
  String userName;
  String profileUrl;
  String fullName;
  String emailAddress;
  Timestamp birthDate;
  String contactNumber;
  CustomerLocation userLocation;
  bool coupon;
  UserModel(
      {this.intialSlider,this.coupon,
      this.birthDate,
      this.contactNumber,
      this.emailAddress,
      this.fullName,
      this.profileUrl,
      this.userName,
      this.userLocation});
  UserModel.fromJson(Map<String, dynamic> json)
      : 
      intialSlider = json['intialSlider'] == null ? false: json['intialSlider'],
      birthDate = json['birthDate'],
        contactNumber = json['contactNumber'],
        emailAddress = json['email'],
        profileUrl = json['profileUrl'],
        fullName = json['fullName'],
        userName = json['userName'],
        coupon = json['couponAllowed'],
        userLocation =
            json['location'] == null ? null : CustomerLocation.fromJson(json);
}

//  'area':locationDetail.area,
//           'houseNo' : locationDetail.houseNo,
//           'landmark' : locationDetail.landMark,
//           'locationType' : locationDetail.locationType,
//           'location':locationDetail.location,
//           'locationPoint': location.data,
//           'otherName': otherLocationName,
//           'quickLocation':locationDetail.quickLocation,
