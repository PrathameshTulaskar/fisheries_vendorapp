import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:fisheries_vendorapp/models/megaHomepage.dart';
//import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:provider/provider.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';

import 'Signup/signup_screen.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String name;
  @override
  void initState() { 
    super.initState();
    Provider.of<AppState>(context, listen: false).fetchUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    // String unitsSelected;
    final appState = Provider.of<AppState>(context);
    // final userDetails = Provider.of<User>(context);
    VendorMegaData vendor;
    vendor = appState.vendorData;
    if(vendor != null){
      setState(() {
        name = vendor.vendorName ?? "";
      });
    }
  
    return 
    //appState.vendorData == null ? SignUpScreen() : 
    Selector<AppState,VendorMegaData>(
      builder: (context,value,child){
        return 
        // FirebaseAuth.instance.currentUser == null ? SignUpScreen() :
        value == null ? SignUpScreen() : 
        // value.businessType == null ? SelectBusiness():
        SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: TitleTextBuilder(
              sendText: "Welcome ${value.vendorName}",
            ),
             automaticallyImplyLeading: false,
            //leading: Container(),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: null)
            ],
          ),
          body: Container(
            width: fullWidth(context),
            // decoration: backgroundDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //RaisedButton(child: Text("okokokok"),onPressed: () => Navigator.pushNamed(context, '/welcomePage')),
                SizedBox(height: 25),
                appState.supermarketlist.length == 0 ? Text("No supermarket registered.") :
                 value.businessType == 'Fish' ? Container(): Text(
                   "Your Total Profit chart for ${appState.supermarketlist.length.toString()} outlets is below",
                   style: TextStyle(color: Colors.blueGrey[700], fontSize: 14.5),
                  //sendColor: Colors.orange[300],
                ),
                SizedBox(height: 25),
                Container(
                  width: 330,
                  height: 97,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(width: 5.0, style: BorderStyle.none),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black26,
                        offset: new Offset(20.0, 10.0),
                        blurRadius: 20.0,
                      )
                    ],
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection("grocery/vendors/vendorsList").doc(appState.vendorId).snapshots(),
                    builder: (context, snapshot) {
                      var children;
                      
                      switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        children = Container(
                          width: fullWidth(context),
                          height: fullHeight(context),
                          child: Center(child: CircularProgressIndicator()));
                      break;
                    default:
                    if (snapshot.hasError)
                        children = [Text('Error: ${snapshot.error}')];
                      else {
                        var response = VendorMegaData.fromJson(snapshot.data.data());
                        children = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Total Order",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                response != null ? response.totalOrders.toString() : "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 15),
                              )
                            ],
                          ),
                          
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Sale",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Text("\u20b9" , style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 15),), 
                                  Text( response != null ? response.totalSales.toString() : "" , style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 15),)
                                  ],
                              )
                            ],
                          ),
                          
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Delivered",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 10),
                              Text(
                                 response != null ? response.totalDeliveries.toString() : "",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 15),
                              )
                            ],
                          ),
                          
                        ],
                      );
                      }  
                    }
                    return children;
                    }
                  ),
                ),
                SizedBox(height: 10),
                CarouselSlider(
                  // enlargeMainPage: true,
                  items: appState.homepageSlideUrls.length == 0
                      ? [
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        ]
                      : appState.homepageSlideUrls.map(
                          (urls) {
                            return Container(
                              margin: EdgeInsets.all(5.0),
                              child: FlatButton(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: Image.network(
                                    urls,
                                    fit: BoxFit.cover,
                                    width: 1000.0,
                                    height: 300,
                                  ),
                                ),
                                onPressed: () => print("hello"),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.all(5),
                              ),
                            );
                          },
                        ).toList(),
                                options:CarouselOptions(
                          height:200,
                          aspectRatio:16/9,
                          viewportFraction:0.8,
                          initialPage:0,
                          enableInfiniteScroll:true,
                          reverse:false,
                          autoPlay:true,
                          autoPlayInterval:Duration(seconds:3),
                          autoPlayAnimationDuration:Duration(milliseconds:800),
                          autoPlayCurve:Curves.fastOutSlowIn,
                          enlargeCenterPage:true,
                          scrollDirection:Axis.horizontal,

                        ),
                ),
                //SizedBox(height:50),
                // Container(
                //   width: 300,
                //   height: 100,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //      Expanded(
                //                           child: DropDownFormField(
                //                     filled: false,
                //                     value: appState.setSupermarketID,
                //                     onSaved: (value) {

                //                       appState.setSupermarketIdOnHome(value);
                //                       setState(() {
                //                         unitsSelected = value;
                //                       });
                //                       print("onSaved: $value");
                //                      // print(appState.productUnits.text);
                //                     },
                //                     onChanged: (value) {
                //                       appState.setSupermarketIdOnHome(value);
                //                       setState(() {
                //                         unitsSelected = value;
                //                       });
                //                       print("on changed : ${appState.setSupermarketID}");

                //                       //print(appState.productUnits.text);
                //                     },
                //                     titleText: "Select Your Super Market",
                //                     hintText: "Select Super Market",
                //                     dataSource: appState.supermarketlist,
                //                     textField: 'display',
                //                     valueField: 'value',
                //                   ),
                //      ),
                //     ],
                //   ),
                // ),
                //SizedBox(height: 50),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.97,
                  height: 97,
                  decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: new Border.all(width: 5.0, style: BorderStyle.none),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black26,
                      offset: new Offset(20.0, 10.0),
                      blurRadius: 20.0,
                    )
                  ],
                  ),
                  child: value.businessType == 'Fish' && appState.fishBusiness == null ? InkWell(
                  onTap: (){
                      Navigator.pushNamed(context, '/fishBusinessPage');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.store , color: whiteColor,),
                      Text("Start Selling" , style: TextStyle(color: whiteColor, fontWeight:FontWeight.bold),),
                      Icon(Icons.arrow_forward_ios , color: whiteColor,)
                    ],
                  ),
                  ): value.businessType == 'Fish' ?
                   InkWell(
                  onTap: (){
                      Navigator.pushNamed(context, '/vendorBusinessCard');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.store , color: whiteColor,),
                      Text("Manage Business" , style: TextStyle(color: whiteColor, fontWeight:FontWeight.bold),),
                      Icon(Icons.arrow_forward_ios , color: whiteColor,)
                    ],
                  ),
                  ) :
                  InkWell(
                  onTap: (){
                      Navigator.pushNamed(context, '/supermarketlist');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.store , color: whiteColor,),
                      Text("VIEW OUTLETS" , style: TextStyle(color: whiteColor, fontWeight:FontWeight.bold),),
                      Icon(Icons.arrow_forward_ios , color: whiteColor,)
                    ],
                  ),
                  ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      );
      },
      selector: (buildContext,appstate) => appstate.vendorData,
    );
  }
}
