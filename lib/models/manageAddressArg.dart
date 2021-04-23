import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAddressArg{
  String tag;
  GeoPoint locationPoint;
  String locationId;
  ManageAddressArg({ this.locationPoint,this.tag,this.locationId});
}