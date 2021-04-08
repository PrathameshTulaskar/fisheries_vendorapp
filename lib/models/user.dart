import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String userName;
  String profileUrl;
  String fullName;
  String emailAddress;
  Timestamp birthDate;
  String contactNumber;
  UserModel({this.birthDate,this.contactNumber,this.emailAddress,this.fullName,this.profileUrl,this.userName});
  UserModel.fromJson(Map<String, dynamic> json):
  birthDate = json['birthDate'],
  contactNumber = json['contactNumber'],
  emailAddress = json['email'],
  profileUrl = json['profileUrl'],
  fullName = json['fullName'],
  userName = json['userName'];
} 