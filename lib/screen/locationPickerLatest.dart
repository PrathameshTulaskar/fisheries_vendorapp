import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fisheries_vendorapp/models/map_picker.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/screen/locationPicker.dart';

import '../keys.dart';

class LocationMap extends StatefulWidget {
  LocationMap({Key key}) : super(key: key);

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationPermission>(
          future: Geolocator.checkPermission(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return FutureBuilder<Position>(
                      future: Geolocator.getCurrentPosition(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return PlacePickerScreen(
                                googlePlacesApiKey: goolePlaceApiKey,
                                initialPosition: LatLng(snapshot.data.latitude,
                                    snapshot.data.longitude),
                                mainColor: Theme.of(context).primaryColor,
                                mapStrings: MapPickerStrings.english(),
                                placeAutoCompleteLanguage: 'es',
                              );
                            }
                        }
                      });
                }
            }
          }),
    );
  }
}
