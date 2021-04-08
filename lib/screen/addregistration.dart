import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/credentials.dart';
import 'package:fisheries_vendorapp/screen/home.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';

class AddRegistrationDetail extends StatefulWidget {
  @required
  final Credentials userData;
  AddRegistrationDetail({Key key, this.userData}) : super(key: key);

  @override
  _AddRegistrationDetailState createState() => _AddRegistrationDetailState();
}

class _AddRegistrationDetailState extends State<AddRegistrationDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKeyReg =
      new GlobalKey<ScaffoldState>();
  File _imageFile;
  final picker = ImagePicker();
  bool phoneAuth = false;
  bool googleAuth = false;
  bool facebookAuth = false;
  bool isSuccess;
  String profileUrl = "";
  String businessType;
  String selectedBusiness = "Selling?";
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  //   // Provider.of<AppState>(context, listen: false).fetchHomepageSlides();
  //   // Provider.of<AppState>(context, listen: false).fetchUserDetails(widget.userData.userId);
  //   Provider.of<AppState>(context, listen: false).checkLogin();
  // }
  // }
  // Navigator.push(
  //   context, new MaterialPageRoute(
  //     builder: (context) => new SecondPage()));

  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentUser = Provider.of<User>(context);
    Credentials userTempData = widget.userData;
    // Credentials userTempData = Credentials(
    //     identifier: "phone",
    //     userId: "jOOmNzt4H9U6ZY58w89KHP83jIL2",
    //     contactNumber: "789798789789");
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("grocery/vendors/vendorsList")
            .doc(currentUser.uid)
            .get(),
        //appState.getUserDetails(),
        // stream: Firestore.instance
        //     .collection("grocery/customers/customersList")
        //     .document(userData.userId)
        //     .snapshots(),
        builder: (context, snapshot) {
          // final appState = Provider.of<AppState>(context);
          var children;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              children = Scaffold(
                body: Container(
                    width: fullWidth(context),
                    height: fullHeight(context),
                    child: Center(child: CircularProgressIndicator())),
              );
              break;
            default:
              if (snapshot.hasError)
                children = [Text('Error: ${snapshot.error}')];
              else {
                if (snapshot.hasData && snapshot.data.exists) {
                  // appState.getUserDetails();
                  appState.checkLogin().then((value) {
                    return Homepage();
                  });
                  print("stream running on add registration : ");
                  //Provider.of<AppState>(context, listen: false).checkLogin();
                  //PROVIDERS IF ADDED ANYWHERE HERE OR HOMEPAGE IT CREATES ISSUE.
                  // Navigator.pushReplacementNamed(context, '/home');
                } else {
                  switch (userTempData.identifier) {
                    case "phone":
                      {
                        //setState(() {
                        phoneAuth = true;
                        //});
                      }
                      break;
                    case "fb":
                      {
                        //setState(() {
                        facebookAuth = true;
                        //  });
                      }
                      break;
                    default:
                      {
                        // setState(() {
                        googleAuth = true;
                        // });
                      }
                  }
                  print("else statement in future running...");
                  children = SafeArea(
                    child: Scaffold(
                      key: _scaffoldKeyReg,
                      appBar: AppBar(
                        title: Text("User Information"),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.done),
                            onPressed: () async {
                              var image = _imageFile.readAsBytesSync();
                              String basename = Timestamp.now()
                                  .microsecondsSinceEpoch
                                  .toString();
                              var fileType = _imageFile.path
                                  .split("/")
                                  .last
                                  .split(".")
                                  .last;
                              var imageNameWithType = "$basename.$fileType";
                              // _imageFile.path.split("/").last;
                              print("Image Name: " +
                                  imageNameWithType +
                                  "image Base64: " +
                                  base64Encode(image));
                              // base64Encode(image);
                              // String imageUrlLink =
                              //     await appState.uploadImageToServer(
                              //         base64Encode(image),
                              //         imageNameWithType,
                              //         "profile");
                              var stoper = false;
                              // if (imageUrlLink.isEmpty) {
                              //   setState(() {
                              //     isSuccess = false;
                              //   });
                              // } 
                              // else {

                                if (_formKey.currentState.validate() &&
                                    !stoper) {
                                  switch (userTempData.identifier) {
                                    case "phone":
                                      {
                                        if (selectedBusiness != "Selling?") {
                                          // if (profileUrl.length > 1 && selectedBusiness != "Selling?") {
                                          print(
                                              "phone auth data store with user ID:${userTempData.userId}");
                                          appState
                                              .userDataStore(
                                            profileUrl: " ",
                                            contactNumber:
                                                widget.userData.contactNumber,
                                            userIdReg: userTempData.userId,
                                            checkAuth: 1,
                                            vendorType: selectedBusiness,
                                          )
                                              .then((value) {
                                            // ScaffoldMessenger.of(context).showSnackBar(
                                            //   // SnackBar(content: Text(value),)
                                            //   );
                                            if (value) {
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      '/home',
                                                      (Route<dynamic> route) =>
                                                          false);
                                            } else {
                                              setState(() {
                                                isSuccess = value;
                                              });
                                            }
                                          });
                                        } else {
                                          print(
                                              " Business Selected. $selectedBusiness || $profileUrl");
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      Colors.yellow[900],
                                                  //duration: Duration(seconds: 240),
                                                  behavior:
                                                      SnackBarBehavior.fixed,
                                                  content: Text(
                                                      "Profile Picture or Business Not Selected.")));
                                        }
                                      }
                                      break;
                                    case "fb":
                                      {
                                        appState
                                            .userDataStore(
                                          profileUrl: "imageUrlLink",
                                          facebookSignIn: userTempData.fbSignIn,
                                          userIdReg: userTempData.userId,
                                        )
                                            .then((value) {
                                          if (value) {
                                            // Navigator.pushReplacementNamed(
                                            //     context, '/home');
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/home',
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } else {
                                            setState(() {
                                              isSuccess = value;
                                            });
                                          }
                                        });
                                      }
                                      break;
                                    default:
                                      {
                                        appState
                                            .userDataStore(
                                          profileUrl: "imageUrlLink",
                                          googleSignIn:
                                              userTempData.googleSignIn,
                                          userIdReg: userTempData.userId,
                                          checkAuth: 2,
                                        )
                                            .then((value) {
                                          if (value) {
                                            // Navigator.pushReplacementNamed(
                                            //     context, '/home');
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/home',
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } else {
                                            setState(() {
                                              isSuccess = value;
                                            });
                                          }
                                        });
                                      }
                                  }
                                }
                              // }
                            },
                          )
                        ],
                      ),
                      body: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  facebookAuth || googleAuth
                                      ? SizedBox(height: 20)
                                      : Container(),
                                  facebookAuth || googleAuth
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFieldIcon(
                                                controllerName:
                                                    appState.contactNumberReg,
                                                showIcon: true,
                                                iconPrefix: Icon(Icons.phone),
                                                label: "Contact Number",
                                                validate: (value) {
                                                  if (value.length < 10) {
                                                    return "Invalid phone number";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  (_imageFile == null && phoneAuth)
                                      ? SizedBox(height: 30)
                                      : Container(),
                                  (phoneAuth)
                                      ? TextButton(
                                          onPressed: () async {
                                            var selected ='';
                                                // await ImagePicker.pickImage(
                                                //     source:
                                                //         ImageSource.gallery);
                                            // var selected = await picker.pickImage(
                                            //     source: ImageSource.gallery);
                                            setState(() {
                                              // _imageFile = File(selected.path);
                                            });
                                            var response = '';
                                            // var response = await appState
                                            //     .uploadToStore(_imageFile);
                                            // _scaffoldKeyReg.currentState
                                            //     .showSnackBar(SnackBar(
                                            //         backgroundColor:
                                            //             Colors.yellow[900],
                                            //         duration:
                                            //             Duration(seconds: 240),
                                            //         behavior:
                                            //             SnackBarBehavior.fixed,
                                            //         content: Text(
                                            //             "Profile Pic Uploading...")));
                                            if (response != null) {
                                              setState(() {
                                                profileUrl = response;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      //duration: Duration(seconds: 240),
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      content:
                                                          Text("Uploaded.")));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .hideCurrentSnackBar();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      //duration: Duration(seconds: 240),
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      content: Text(
                                                          "Upload failed try again.")));
                                              print("chalna mare");
                                              setState(() {
                                                _imageFile = null;
                                              });
                                            }

                                            //_showSnack();
                                          },
                                          child: (_imageFile == null)
                                              ? Icon(
                                                  Icons.image,
                                                  size: 50,
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: whiteColor,
                                                  backgroundImage: FileImage(
                                                      _imageFile,
                                                      scale: 1),
                                                  radius: 50,
                                                  // child: Image.file(
                                                  //   _imageFile,
                                                  //   width: 150.0,
                                                  //   height: 150.0,
                                                  // ),
                                                ),
                                        )
                                      : Container(),
                                  (_imageFile == null && phoneAuth)
                                      ? Text("Pick profile")
                                      : Container(),
                                  phoneAuth
                                      ? SizedBox(height: 20)
                                      : Container(),
                                  phoneAuth
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFieldIcon(
                                                controllerName:
                                                    appState.fullNameReg,
                                                showIcon: true,
                                                iconPrefix:
                                                    Icon(Icons.account_circle),
                                                label: "Full Name",
                                                validate: (value) {
                                                  if (value == null) {
                                                    return "Required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  phoneAuth
                                      ? SizedBox(height: 20)
                                      : Container(),
                                  phoneAuth
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFieldIcon(
                                                controllerName:
                                                    appState.userNameReg,
                                                showIcon: true,
                                                iconPrefix: Icon(Icons
                                                    .perm_contact_calendar),
                                                label: "Username",
                                                validate: (value) {
                                                  if (value == null) {
                                                    return "Required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  phoneAuth
                                      ? SizedBox(height: 20)
                                      : Container(),
                                  phoneAuth
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TextFieldIcon(
                                                controllerName:
                                                    appState.emailReg,
                                                showIcon: true,
                                                iconPrefix: Icon(Icons.email),
                                                label: "Email Address",
                                                validate: (value) {
                                                  if (value == null) {
                                                    return "Required";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  (!facebookAuth ||
                                          userTempData.fbSignIn.birthDate ==
                                              null)
                                      ? SizedBox(height: 30)
                                      : Container(),
                                  (!facebookAuth ||
                                          userTempData.fbSignIn.birthDate ==
                                              null)
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: DateTimeField(
                                                minLines: 1,
                                                controller:
                                                    appState.birthDateReg,
                                                format:
                                                    DateFormat("yyyy-MM-dd"),
                                                decoration: InputDecoration(
                                                    prefixIcon:
                                                        Icon(Icons.cake),
                                                    hintText: "Birthday"),
                                                onShowPicker:
                                                    (context, currentValue) {
                                                  return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1900),
                                                    initialDate: currentValue ??
                                                        DateTime(1996),
                                                    lastDate: DateTime(2100),
                                                  );
                                                },
                                              ),
                                            ),
                                            // Expanded(
                                            //     child: Container(
                                            //       width:200,
                                            //       child: DropdownButton<String>(

                                            //   items: <String>[
                                            //       'Fish',
                                            //       'Grocery',
                                            //   ].map((String value) {
                                            //       return new DropdownMenuItem<
                                            //           String>(
                                            //         value: value,
                                            //         child: new Text(value),
                                            //       );
                                            //   }).toList(),
                                            //   onChanged: (_) {},
                                            // ),
                                            //     )),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(height: 30),
                                  Row(children: <Widget>[
                                    Expanded(
                                        child: DropdownButton(
                                            isExpanded: true,
                                            value:
                                                selectedBusiness, // A global variable used to keep track of the selection
                                            items: [
                                              'Selling?',
                                              'Fish',
                                              'Grocery'
                                            ].map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (String selectedItem) {
                                              setState(() => selectedBusiness =
                                                  selectedItem);
                                            })),
                                  ]),
                                  Visibility(
                                    child: Center(
                                      child: Text(
                                        "Something went wrong... try again.",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    visible:
                                        (isSuccess != null && !(isSuccess)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
          }

          return children;
        });
  }

  // _showSnack() {
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(
  //     content: Text("Image Uploading"),
  //   ));
  // }
}
