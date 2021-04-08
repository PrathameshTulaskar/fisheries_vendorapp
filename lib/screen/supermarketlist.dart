// import 'package:flutter/material.dart';
// import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
// import 'package:fisheries_vendorapp/providers/appstate.dart';
// import 'package:fisheries_vendorapp/screen/addproduct.dart';
// import 'package:fisheries_vendorapp/screen/categorylistpage.dart';
// import 'package:fisheries_vendorapp/screen/myaccount.dart';
// import 'package:fisheries_vendorapp/util/themedata.dart';
// import 'package:fisheries_vendorapp/widgets/colors.dart';
// import 'package:fisheries_vendorapp/widgets/toggleswitch.dart';
// import 'package:fisheries_vendorapp/widgets/widgets.dart';
// import 'package:provider/provider.dart';

// import 'categorylistforstep2.dart';

// class SupermarketList extends StatefulWidget {
//   SupermarketList({Key key}) : super(key: key);
//   @override
//   _SupermarketListState createState() => _SupermarketListState();
// }

// class _SupermarketListState extends State<SupermarketList> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   bool isUploaded = false;
//   @override
//   void initState() {
//     Provider.of<AppState>(context, listen: false).fetchSupermarketbyID();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () =>
//                   Navigator.pushReplacementNamed(context, '/home')),
//           title: TitleTextBuilder(
//             sendText: "Your Outlets",
//           ),
//         ),
//         floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () async {
//             Navigator.pushNamed(context, '/addSuperMarket');
//           },
//           label: Text("Add Outlet"),
//           icon: Icon(Icons.store),
//           backgroundColor: Theme.of(context).primaryColor,
//           isExtended: true,
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(child: ListSupermarkets()),
//             SizedBox(height: 80),
//           ],
//         ));
//   }
// }

// class ListSupermarkets extends StatefulWidget {
//   const ListSupermarkets({
//     Key key,
//   }) : super(key: key);
//   @override
//   _ListSupermarketsState createState() => _ListSupermarketsState();
// }

// class _ListSupermarketsState extends State<ListSupermarkets> {
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     return ListView.builder(
//         //shrinkWrap: true,
//         itemCount: appState.supermarketdet == null
//             ? 0
//             : appState.supermarketdet.length,
//         itemBuilder: (BuildContext context, index) {
//           var element = appState.supermarketdet[index];
//           print("Account id from screen: ${element.accountId}");
//           if (element.supermarketName.length >= 25) {
//             element.supermarketName =
//                 element.supermarketName.substring(0, 25) + "...";
//           } else {
//             element.supermarketName = element.supermarketName;
//           }
//           return Card(
//             elevation: 8.0,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     SizedBox(height: 10),
//                     Column(
//                       //crossAxisAlignment: CrossAxisAlignment.center,
//                       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         SizedBox(height: 10),
//                         element.superMarketImage == null
//                             ? Icon(
//                                 Icons.broken_image,
//                                 size: 100,
//                                 color: Colors.deepPurple,
//                               )
//                             : Image.network(
//                                 element.superMarketImage,
//                                 height: 120,
//                                 width: 120,
//                                 // width: MediaQuery.of(context).size.width,
//                                 fit: BoxFit.fill,
//                                 loadingBuilder:
//                                     (context, child, loadingProgress) {
//                                   if (loadingProgress == null) return child;
//                                   return SizedBox(
//                                     height: 100,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Center(
//                                         child: CircularProgressIndicator(
//                                           value: loadingProgress
//                                                       .expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   loadingProgress
//                                                       .expectedTotalBytes
//                                               : null,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                         //SizedBox(height: 20),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(3.5),
//                       child: Column(
//                         //mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           //SizedBox(height: 20),
//                           Wrap(
//                             children: <Widget>[
//                               Container(
//                                 width: 200,
//                                 child: Text(
//                                   element.supermarketName ?? "",
//                                   //"dsf fds fsd f sfsd fsd fdsfds sdfsdfs sdfdf dsfsafsf vhgvfhgvhgvg jhvjhvjhvhj bjhbjbhj",
//                                   textAlign: TextAlign.left,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .subtitle1
//                                       .copyWith(
//                                         fontSize: 16,
//                                       ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Text("Visiblity :"),
//                               SwitchToggle(
//                                 currentState: element.visiblity,
//                                 superMarketID: element.superMarketID,
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Text("Subscription : "),
//                               Subscribed(
//                                 subscribed: element.subscription,
//                                 reason: element.reason,
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     FlatButton(
//                         color: Color(0xFFEE2842),
//                         onPressed: () async {
//                           print("Account id from screen: ${element.accountId}");
//                           // Navigator.pushNamed(context, '/viewOrdersPage',
//                           //     arguments: element.superMarketID);
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return ViewOrdersDialogue(
//                                 superMarketID: element.superMarketID,
//                                 supDetail: element,
//                               );
//                             },
//                           );
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.45,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
//                             child: Center(
//                               child: Text("Orders",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .button
//                                       .copyWith(color: white)),
//                             ),
//                           ),
//                           decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(4)),
//                               border: Border.all(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1)),
//                         ),
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         padding: EdgeInsets.all(0)),

//                     SizedBox(width: 15),
//                     FlatButton(
//                         color: Theme.of(context).primaryColor,
//                         onPressed: () async {
//                           appState
//                               .setSupermarketIdOnHome(element.superMarketID);
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AddProductDialog(
//                                 supDetail: element,
//                                 superMarketID: element.superMarketID,
//                               );
//                             },
//                           );
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.45,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
//                             child: Center(
//                               child: Text("Product",
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .button
//                                       .copyWith(color: white)),
//                             ),
//                           ),
//                           decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(4)),
//                               border: Border.all(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1)),
//                         ),
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         padding: EdgeInsets.all(0)),
//                     //SizedBox(height: 20),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 )
//               ],
//             ),
//           );
//         });
//   }
// }

// class AddProductDialog extends StatefulWidget {
//   final String superMarketID;
//   final SupermarketDetails supDetail;
//   AddProductDialog({Key key, this.superMarketID, this.supDetail})
//       : super(key: key);

//   @override
//   _AddProductDialogState createState() => _AddProductDialogState();
// }

// class _AddProductDialogState extends State<AddProductDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return SimpleDialog(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             "PRODUCTS",
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//           IconButton(
//               icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))
//         ],
//       ),
//       children: <Widget>[
//         Center(
//           child: Column(
//             children: <Widget>[
//               RaisedButton(
//                 padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => CategoryListPage(
//                                 supermarket: widget.supDetail,
//                               )));
//                 },
//                 child: Text("view products",
//                     style: Theme.of(context)
//                         .textTheme
//                         .button
//                         .copyWith(color: whiteColor)),
//                 color: Theme.of(context).primaryColor,
//               ),
//               RaisedButton(
//                 padding: EdgeInsets.symmetric(horizontal: 23.0, vertical: 10),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => Addproduct(
//                                 finalSupermarketID:
//                                     widget.supDetail.superMarketID,
//                               )));
//                 },
//                 child: Text("Add Product",
//                     style: Theme.of(context)
//                         .textTheme
//                         .button
//                         .copyWith(color: whiteColor)),
//                 color: Theme.of(context).primaryColor,
//               ),
//               RaisedButton(
//                 padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => CategoryListPageOurProduct()));
//                 },
//                 child: Text("Quick Add",
//                     style: Theme.of(context)
//                         .textTheme
//                         .button
//                         .copyWith(color: whiteColor)),
//                 color: Theme.of(context).primaryColor,
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

// class ViewOrdersDialogue extends StatefulWidget {
//   final String superMarketID;
//   final SupermarketDetails supDetail;
//   ViewOrdersDialogue({Key key, this.superMarketID, this.supDetail})
//       : super(key: key);

//   @override
//   _ViewOrdersDialogueState createState() => _ViewOrdersDialogueState();
// }

// class _ViewOrdersDialogueState extends State<ViewOrdersDialogue> {
//   @override
//   void initState() {
//     Provider.of<AppState>(context, listen: false)
//         .deliveryDetail(widget.superMarketID);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("Account id from screen: ${widget.supDetail.accountId}");
//     return SimpleDialog(
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             "VIEW ORDERS",
//             style: Theme.of(context).textTheme.subtitle1,
//           ),
//           IconButton(
//               icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))
//         ],
//       ),
//       children: <Widget>[
//         Center(
//           child: Column(
//             children: <Widget>[
//               RaisedButton(
//                 padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => MyAccount(
//                                 supermarket: widget.supDetail,
//                               )));
//                 },
//                 child: Text("Order History",
//                     style: Theme.of(context)
//                         .textTheme
//                         .button
//                         .copyWith(color: whiteColor)),
//                 color: Theme.of(context).primaryColor,
//               ),
//               RaisedButton(
//                 padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10),
//                 onPressed: () {
//                   print("supermarketId: ${widget.superMarketID}");
//                   Navigator.pushNamed(context, '/viewOrdersPage',
//                       arguments: widget.supDetail);
//                 },
//                 child: Text("Today's Orders",
//                     style: Theme.of(context)
//                         .textTheme
//                         .button
//                         .copyWith(color: whiteColor)),
//                 color: Theme.of(context).primaryColor,
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
