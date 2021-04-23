import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fisheries_vendorapp/models/manageAddressArg.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/snackbarNotify.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'locationPickerLatest.dart';

class LocationAdd extends StatefulWidget {
  LocationAdd({Key key}) : super(key: key);

  @override
  _LocationAddState createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd>
    with TickerProviderStateMixin {
  final _formKeyLocation = GlobalKey<FormState>();
  double btnFullWidth = 160.0;
  bool addMoreDetails = false;
  PanelController slideUp;
  //LatLng currentP;
  bool homeBtn = false;
  bool workBtn = false;
  bool otherBtn = false;
  int locationType = 0;
  bool updateFunctionality = false;
  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).fetchCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<AppState>(context, listen: false).fetchCurrentLocation();
    final appState = Provider.of<AppState>(context);
    ManageAddressArg manageAddArg = ModalRoute.of(context).settings.arguments;
    if (manageAddArg != null) {
      appState.supermarketPositionValue = LatLng(
          manageAddArg.locationPoint.latitude,
          manageAddArg.locationPoint.longitude);
      setState(() {
        btnFullWidth = fullWidth(context) - 40;
        addMoreDetails = true;
        updateFunctionality = true;
      });
      switch (manageAddArg.tag) {
        case "Home":
          setState(() {
            homeBtn = true;
            locationType = 1;
          });
          break;
        case "Work":
          setState(() {
            workBtn = true;
            locationType = 2;
          });
          break;
        default:
          {
            setState(() {
              otherBtn = true;
              locationType = 3;
            });
          }
      }
    }
    var selectedColor = Theme.of(context).primaryColor;
    // Geolocator().getCurrentPosition().then((value) {
    //   setState(() {
    //     currentP = LatLng(value.latitude, value.longitude);
    //   });
    // });
    return Scaffold(
        body: appState.supermarketPosition == null
            ? Container(
                width: fullWidth(context),
                height: fullHeight(context),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.location_off,
                      size: 50,
                    ),
                    Text("Enable Location Service."),
                  ],
                )))
            : SlidingUpPanel(
                controller: slideUp,
                isDraggable: true,
                parallaxEnabled: true,
                borderRadius: BorderRadius.circular(15.0),
                minHeight: MediaQuery.of(context).size.height * 0.50,
                // addMoreDetails
                //     ? updateFunctionality
                //         ? MediaQuery.of(context).size.height * 0.50
                //         : maxHeight
                //     : MediaQuery.of(context).size.height * 0.50,
                //maxHeight: MediaQuery.of(context).size.height * 0.80,
                //collapsed: SizedBox(height:10),
                panel: Container(
                  height: fullHeight(context),
                  child: Column(
                    children: <Widget>[
                      BorderHighlight(),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            height: fullHeight(context),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //SizedBox(height: 15),
                                  Text(
                                    "Set delivery location",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(height: 15),
                                  Form(
                                    key: _formKeyLocation,
                                    //autovalidate: true,
                                    child: Column(
                                      children: <Widget>[
                                        textField(
                                          "LOCATION",
                                          true,
                                          appState.location,
                                        ),
                                        SizedBox(height: 10),
                                        textField("AREA", false, appState.area,
                                            validator: (value) {
                                          if (value.length < 5)
                                            return 'Please specify more in detail';
                                          else
                                            return null;
                                        }),
                                        Visibility(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 10),
                                              textField("HOUSE/FLAT NO", false,
                                                  appState.houseNo,
                                                  validator: (value) {
                                                if (value.length < 2)
                                                  return 'Incorrect';
                                                else
                                                  return null;
                                              },
                                                  keyboard:
                                                      TextInputType.number),
                                              SizedBox(height: 10),
                                              textField("LANDMARK", false,
                                                  appState.landMark,
                                                  validator: (value) {
                                                if (value.length < 5)
                                                  return 'Please specify more in detail';
                                                else
                                                  return null;
                                              }),
                                            ],
                                          ),
                                          visible: addMoreDetails,
                                        ),
                                        Visibility(
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(height: 10),
                                              textField("SAVE AS", false,
                                                  appState.otherLocation,
                                                  validator: (value) {
                                                if (value.length < 5)
                                                  return 'Please specify more in detail';
                                                else
                                                  return null;
                                              })
                                            ],
                                          ),
                                          visible: otherBtn,
                                        ),
                                        SizedBox(height: 10),
                                        Visibility(
                                          visible: !otherBtn && addMoreDetails,
                                          child: Column(
                                            children: <Widget>[
                                              Align(
                                                child: Text("TAG AS :"),
                                                alignment: Alignment.centerLeft,
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  BorderBtn(
                                                    buttonText: "HOME",
                                                    // width: 70,
                                                    borderColor: homeBtn
                                                        ? selectedColor
                                                        : greyColor,
                                                    onBtnPress: () {
                                                      setState(() {
                                                        homeBtn = true;
                                                        workBtn = false;
                                                        otherBtn = false;
                                                        locationType = 1;
                                                      });
                                                    },
                                                  ),
                                                  BorderBtn(
                                                      buttonText: "WORK",
                                                      // width: 70,
                                                      borderColor: workBtn
                                                          ? selectedColor
                                                          : greyColor,
                                                      onBtnPress: () {
                                                        setState(() {
                                                          homeBtn = false;
                                                          workBtn = true;
                                                          otherBtn = false;
                                                          locationType = 2;
                                                        });
                                                      }),
                                                  Visibility(
                                                    child: BorderBtn(
                                                        buttonText: "OTHER",
                                                        // width: 70,
                                                        borderColor: greyColor,
                                                        onBtnPress: () {
                                                          setState(() {
                                                            homeBtn = false;
                                                            workBtn = false;
                                                            otherBtn = true;
                                                            locationType = 3;
                                                          });
                                                        }),
                                                    visible: !otherBtn,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 25),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Visibility(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  BorderBtn(
                                                      borderColor:
                                                          btnBorderColor,
                                                      // width: 155,
                                                      onBtnPress: () {
                                                        setState(() {
                                                          btnFullWidth =
                                                              fullWidth(
                                                                      context) -
                                                                  40;
                                                          addMoreDetails = true;
                                                          //slideUp.animatePanelToPosition(0.6,duration: Duration(seconds: 2),curve: Curves.easeIn);
                                                        });
                                                      }),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "for faster delivery",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .overline,
                                                  )
                                                ],
                                              ),
                                              visible: !addMoreDetails,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                AnimatedSize(
                                                    curve: Curves.bounceOut,
                                                    duration:
                                                        Duration(seconds: 1),
                                                    vsync: this,
                                                    child: FillColorBtn(
                                                      updateFunctionality:
                                                          updateFunctionality,
                                                      btnWeight: btnFullWidth,
                                                      formKey: _formKeyLocation,
                                                      appState: appState,
                                                      locationType:
                                                          locationType,
                                                      addMoreDetails:
                                                          addMoreDetails,
                                                      locationId:
                                                          manageAddArg == null
                                                              ? "t"
                                                              : manageAddArg
                                                                  .locationId,
                                                    )),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Visibility(
                                                  child: Text(
                                                    "to quickly browse services",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .overline,
                                                  ),
                                                  visible: !addMoreDetails,
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                body: Stack(children: <Widget>[
                  LocationMap(),
                  Positioned(
                    child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context)),
                    top: 25,
                  )
                ]),
                // GoogleMap(
                //   initialCameraPosition: CameraPosition(target: currentP,zoom: 14.4746),
                //   mapType: MapType.hybrid,
                //   onMapCreated: (GoogleMapController controller) {
                //   _controller.complete(controller);
                // },
                // )
              ));
  }
}

class FillColorBtn extends StatelessWidget {
  final double btnWeight;
  final GlobalKey<FormState> formKey;
  final AppState appState;
  final int locationType;
  final bool addMoreDetails;
  final bool updateFunctionality;
  final String locationId;
  const FillColorBtn(
      {Key key,
      this.btnWeight,
      this.formKey,
      this.appState,
      this.locationType,
      this.addMoreDetails,
      this.locationId,
      this.updateFunctionality})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        if (formKey.currentState.validate() &&
            appState.supermarketPosition.latitude != 0) {
          if (addMoreDetails && locationType == 0) {
            final snackBar = SnackBar(
              content: Text('Select Location Tag'),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            // var response = await appState.newLocationAdd(
            //     locationType, updateFunctionality, locationId);
            // if (response) {
            //   formKey.currentState.reset();
            //   print("all good");
            //   if (updateFunctionality) {
            //     Navigator.pushReplacementNamed(context, '/manageAddress');
            //   } else {
            //     //appState.fetchNearbySupermarkets();
            //     Navigator.of(context).pushNamedAndRemoveUntil(
            //         '/home', (Route<dynamic> route) => false);
            //   }
            //   //Scaffold.of(context).showSnackBar(successNotify());

            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(errorOccured());
            // }
          }
        }
      },
      child: Container(
        width: btnWeight ?? null,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text("CONFIRM LOCATION",
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Colors.white)),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: btnBorderColor),
      ),
      style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: MaterialStateProperty.all(EdgeInsets.all(0))),
    );
  }
}

class BorderHighlight extends StatelessWidget {
  const BorderHighlight({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 35,
              height: 5,
              color: greyColor,
            ),
          )
        ],
      ),
    );
  }
}
