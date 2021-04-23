import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerLocation {
  String locationId;
  String area;
  String houseNo;
  String landMark;
  String location;
  String locationType;
  String otherLocationName;
  bool otherLocation;
  GeoPoint customerLatLng;
  bool quickLocation;
  CustomerLocation(
      {this.locationId,
      this.area,
      this.houseNo,
      this.landMark,
      this.locationType,
      this.otherLocation,
      this.otherLocationName,
      this.customerLatLng,
      this.location,
      this.quickLocation});
  CustomerLocation.fromSnapshot(DocumentSnapshot snapshot)
      : locationId = snapshot.id,
        area = snapshot.data()['area'],
        houseNo = snapshot.data()['houseNo'],
        landMark = snapshot.data()['landmark'],
        location = snapshot.data()['location'],
        locationType = snapshot.data()['locationType'],
        otherLocation = snapshot.data()['otherLocation'],
        customerLatLng = snapshot.data()['locationPoint']['geopoint'],
        quickLocation = snapshot.data()['quickLocation'];

  CustomerLocation.fromJson(Map<String, dynamic> json)
      : area = json['area'],
        houseNo = json['houseNo'],
        landMark = json['landmark'],
        location = json['location'],
        locationType = json['locationType'],
        otherLocation = json['otherLocation'] ?? false,
        customerLatLng = json['locationPoint'] == null
            ? null
            : json['locationPoint']['geopoint'],
        quickLocation = json['quickLocation'];
}
