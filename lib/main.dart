import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fisheries_vendorapp/models/closingTime.dart';
import 'package:fisheries_vendorapp/screen/Fishery-Admin/vendorBusinessCard.dart';
import 'package:fisheries_vendorapp/screen/addproduct.dart';
import 'package:fisheries_vendorapp/screen/categorylistforstep2.dart';
import 'package:fisheries_vendorapp/screen/categorylistpage.dart';
import 'package:fisheries_vendorapp/screen/lowStock.dart';
import 'package:fisheries_vendorapp/screen/productlist.dart';
import 'package:fisheries_vendorapp/screen/selectproduct.dart';
import 'package:fisheries_vendorapp/screen/signupStep2.dart';
import 'package:fisheries_vendorapp/screen/test.dart';
import 'package:fisheries_vendorapp/screen/viewOrdersPage.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/appstate.dart';
import 'providers/countries.dart';
import 'providers/phone_auth.dart';
import 'screen/Fishery-Admin/todaysReport.dart';
import 'screen/Login/login_screen.dart';
import 'screen/Signup/signup_screen.dart';
import 'screen/Welcome/welcome_screen.dart';
import 'screen/addregistration.dart';
import 'screen/home.dart';
import 'services/auth/phone_auth/get_phone.dart';
import 'screen/selectBusiness.dart';
import 'screen/Fishery-Admin/selectfish.dart';
import 'screen/Fishery-Admin/fishBusinessPage.dart';
import 'screen/Fishery-Admin/todaysorder.dart';
import 'screen/Fishery-Admin/fishery.dart';
import 'screen/Fishery-Admin/reviewDetails.dart';
import 'services/firestore_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GroceryVendor());
}

class GroceryVendor extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _fireAuth = FirebaseAuth.instance;
    FirestoreService firebaseService = FirestoreService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountryProvider(),
        ),
        ChangeNotifierProvider.value(
          value: AppState(),
        ),
        StreamProvider<User>(create: (context) => _fireAuth.authStateChanges()),
        StreamProvider<ClosingTime>(
            create: (context) => firebaseService.fetchBusinessClosingTime()),
        ChangeNotifierProvider(
          create: (context) => PhoneAuthDataProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'QuickyShop Partner',
          //initialRoute: '/home',
          theme: ThemeData(
            textTheme: TextTheme(
              headline1: GoogleFonts.elMessiri(
                  fontSize: 108,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1.5),
              headline2: GoogleFonts.elMessiri(
                  fontSize: 68,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5),
              headline3: GoogleFonts.elMessiri(
                  fontSize: 54, fontWeight: FontWeight.w400),
              headline4: GoogleFonts.elMessiri(
                  fontSize: 38,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25),
              headline5: GoogleFonts.elMessiri(
                  fontSize: 27, fontWeight: FontWeight.w400),
              headline6: GoogleFonts.elMessiri(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15),
              subtitle2: GoogleFonts.elMessiri(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15),
              subtitle1: GoogleFonts.elMessiri(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1),
              bodyText1: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5),
              bodyText2: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25),
              button: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.25),
              caption: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4),
              overline: GoogleFonts.playfairDisplay(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5),
            ),
            primarySwatch: Colors.red,
            primaryColor: Color(0xFFEE2842),
            appBarTheme: AppBarTheme(
                elevation: 0.0,
                color: Color(0xFFEE2842),
                textTheme: TextTheme(headline6: TextStyle(color: whiteColor)),
                actionsIconTheme: IconThemeData(color: whiteColor)),
          ),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => Homepage(),
            '/signupStep2': (BuildContext context) => SignUpRegistration(),
            '/addproduct': (BuildContext context) => Addproduct(),
            '/productlist': (BuildContext context) => ProductList(),
            '/selectproduct': (BuildContext context) => SelectProducts(),
            // '/supermarketlist': (BuildContext context) => SupermarketList(),
            '/categorylistpage': (BuildContext context) => CategoryListPage(),
            '/categorylistforstep2': (BuildContext context) =>
                CategoryListPageOurProduct(),
            '/signup': (BuildContext context) => SignUpScreen(),
            '/addregistration': (BuildContext context) =>
                AddRegistrationDetail(),
            '/otpLogin': (BuildContext context) => PhoneAuthGetPhone(),
            '/test': (BuildContext context) => SwitchButton(),
            '/welcomePage': (BuildContext context) => WelcomeScreen(),
            '/login': (BuildContext context) => LoginScreen(),
            //'/myaccount': (BuildContext context) => MyAccount(),
            '/viewOrdersPage': (BuildContext context) => OrdersPage(),
            // '/addSuperMarket': (BuildContext context) => AddSuperMarket(),
            '/lowStock': (BuildContext context) => LowStock(),
            // '/supermarket/locationAdd': (BuildContext context) => LocationAdd(),
            // '/signup' : (BuildContext context) => SignUpScreen(),
            //'/otpLogin' : (BuildContext context) => PhoneAuthGetsPhone(),
            '/selectFish': (BuildContext context) => SelectFish(),
            '/todaysorder': (BuildContext context) => TodaysOrder(),
            '/fishery': (BuildContext context) => AddYoutubeLink(),
            '/fishBusinessPage': (BuildContext context) => AddFishBusiness(),
            '/selectBusiness': (BuildContext context) => SelectBusiness(),
            '/vendorBusinessCard': (BuildContext context) =>
                VendorBusinessCard(),
            '/reviewDetails': (BuildContext context) => ReviewDetails(),
            '/customerReviews': (BuildContext context) =>
                CustomerReviewsDetails(),
            '/todaysSale': (BuildContext context) => TodaysSaleReport(),
          },
          //initialRoute: '/welcomePage',
          //home: SelectBusiness()
          //home: VendorBusinessCard()
          home: LoginCheck()),
    );
  }
}

class LoginCheck extends StatelessWidget {
  const LoginCheck({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final currentUser = "";
    final currentUser = Provider.of<User>(context);
    //print("login check main : ${appState.vendorDataCheck}");
    // return AddRegistrationDetail();
    return currentUser == null ? SignUpScreen() : Homepage();
    // (currentUser == null) && (appState.vendorDataCheck == null) ? Scaffold(
    //                 body: Container(
    //                     width: fullWidth(context),
    //                     height: fullHeight(context),
    //                     child: Center(child: CircularProgressIndicator())),
    //               ) :
    // currentUser == null || (appState.vendorDataCheck == "false")
    //     ? SignUpScreen()
    //     : Homepage();
  }
}
// class LoginCheck extends StatefulWidget {
//   LoginCheck({Key key}) : super(key: key);

//   @override
//   _LoginCheckState createState() => _LoginCheckState();
// }

// class _LoginCheckState extends State<LoginCheck> {
//   bool loginData = false;
//   @override
//   Widget build(BuildContext context) {
//     final currentUser = Provider.of<FirebaseUser>(context);
//     final appState = Provider.of<AppState>(context);
//     //print("login check main : ${appState.vendorDataCheck}");
//     return (currentUser == null) && (appState.vendorDataCheck == null) ? Scaffold(
//                     body: Container(
//                         width: fullWidth(context),
//                         height: fullHeight(context),
//                         child: Center(child: CircularProgressIndicator())),
//                   ) :
//     currentUser == null || (appState.vendorDataCheck == "false")
//         ? SignUpScreen()
//         : Homepage();
//         // FutureBuilder<DocumentSnapshot>(

//         //     future: Firestore.instance
//         //         .collection("grocery/vendors/vendorList")
//         //         .document(currentUser.uid)
//         //         .get(),
//         //     builder: (BuildContext context, AsyncSnapshot snapshot) {
//         //       var children;
//         //       switch (snapshot.connectionState) {
//         //         case ConnectionState.none:
//         //         case ConnectionState.waiting:
//         //           children = Scaffold(
//         //             body: Container(
//         //                 width: fullWidth(context),
//         //                 height: fullHeight(context),
//         //                 child: Center(child: CircularProgressIndicator())),
//         //           );
//         //           break;
//         //         default:
//         //           if (snapshot.hasError)
//         //             children = [Text('Error: ${snapshot.error}')];
//         //           else if(snapshot.hasData && snapshot.data.exists){
//         //             return new Homepage();
//         //           }else{

//         //              //Navigator.pushNamed(context, '/signup');
//         //             return new SignUpScreen();
//         //           }
//         //       }
//         //       return children;
//         //     });
//   }
// }
