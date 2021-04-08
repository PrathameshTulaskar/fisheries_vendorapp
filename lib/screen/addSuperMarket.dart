// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fisheries_vendorapp/providers/appstate.dart';
// import 'package:fisheries_vendorapp/widgets/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class AddSuperMarket extends StatefulWidget {
//   AddSuperMarket({Key key}) : super(key: key);

//   @override
//   _AddSuperMarketState createState() => _AddSuperMarketState();
// }

// class _AddSuperMarketState extends State<AddSuperMarket> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   bool isUploaded = false;
//   String supermarketPicUrl;

//   @override
//   void initState() {
//     Provider.of<AppState>(context, listen: false).fetchCurrentLocation();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final appStateDialog = Provider.of<AppState>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: TitleTextBuilder(
//           sendText: "Add Outlet",
//         ),
//       ),
//       body: SingleChildScrollView(
//               child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: formKey,
//             child: Column(
//               children: <Widget>[
//                 TextFormField(
//                     controller: appStateDialog.supermarketNameField,
//                     onChanged: (value) => print(value),
//                     decoration: InputDecoration(
//                         labelText: "Add Outlet Name",
//                         hintText: "eg: Super Market Name"),
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return "enter value";
//                       } else {
//                         return null;
//                       }
//                     }),
//                 SizedBox(height: 25),
//                 Text("Add A Picture To Your SuperMarket"),
//                 SizedBox(height: 20),
//                 FlatButton(
//                   onPressed: () async {
//                     var snackBar = SnackBar(
//                       content: Text("Image Uploading"),
//                       backgroundColor: Colors.yellow[900],
//                     );

//                     File selected = await ImagePicker.pickImage(
//                         source: ImageSource.gallery, imageQuality: 80);
//                     appStateDialog.assignImageUrl(selected);
//                     if(selected.path != null){
//                        _scaffoldKey.currentState.showSnackBar(SnackBar(
//                         backgroundColor: Colors.amber[900],
//                         duration: Duration(seconds: 240),
//                         behavior: SnackBarBehavior.fixed,
//                         content: Text("Upload Started")));
//                     }
//                     // appStateDialog.uploadImageSupermarket(appStateDialog.imageFileContents).then((value) {
//                     //   if(value.isNotEmpty){
//                     //     setState(() {
//                     //       isUploaded = true;
//                     //       supermarketPicUrl = value;
//                     //     });
//                     //     if (isUploaded) {
//                     //       _scaffoldKey.currentState.hideCurrentSnackBar();
//                     //       _scaffoldKey.currentState.showSnackBar(SnackBar(
//                     //           backgroundColor: Colors.green,
//                     //           duration: Duration(seconds: 240),
//                     //           behavior: SnackBarBehavior.fixed,
//                     //           content: Text("Image Uploaded")));
//                     //     } 
//                     //   }         
//                     //   else {
//                     //     _scaffoldKey.currentState.hideCurrentSnackBar();
//                     //     _scaffoldKey.currentState.showSnackBar(SnackBar(
//                     //         backgroundColor: Colors.red,
//                     //         duration: Duration(seconds: 240),
//                     //         behavior: SnackBarBehavior.fixed,
//                     //         content: Text(
//                     //             "Opps! Something went wrong. Please try again or contact support")));
//                     //   }
//                     // });
//                   },
//                   child: appStateDialog.imageFileContents == null
//                       ? Icon(
//                           Icons.add_a_photo,
//                           size: 50,
//                         )
//                       : Image.file(
//                           appStateDialog.imageFileContents,
//                           width: 120.0,
//                           height: 120.0,
//                           fit: BoxFit.fill,
//                         ),
//                 ),
//                 SizedBox(height: 25),
          
//                 FlatButton(
//                     disabledColor: Colors.grey,
//                     color: Theme.of(context).primaryColor,
//                     textColor: Colors.white,
//                     onPressed: appStateDialog.imageFileContents == null
//                         ? null
//                         : () async {
//                             if (formKey.currentState.validate() && isUploaded) {
//                               print("here!");
//                               //formKey.currentState.save();
//                                 Navigator.pushNamed(context,'/supermarket/locationAdd',arguments: supermarketPicUrl);          
//                             }
//                           },
//                     child: Text("Next"))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class SupermarketBasicDetail{
//   String supermarketName;
//   String supermarketPic;
//   SupermarketBasicDetail({this.supermarketName,this.supermarketPic});
// }