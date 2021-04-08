import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:fisheries_vendorapp/models/credentials.dart';
import 'package:fisheries_vendorapp/models/facebookAuth.dart';
import 'package:fisheries_vendorapp/models/googleAuth.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/providers/countries.dart';
import 'package:fisheries_vendorapp/providers/phone_auth.dart';
import 'package:fisheries_vendorapp/screen/Login/login_screen.dart';
import 'package:fisheries_vendorapp/screen/Signup/components/background.dart';
import 'package:fisheries_vendorapp/screen/Signup/components/social_icon.dart';
import 'package:http/http.dart' as http;
import 'package:fisheries_vendorapp/widgets/select_country.dart';
import 'package:fisheries_vendorapp/screen/Signup/components/verify.dart';
import 'package:fisheries_vendorapp/widgets/already_have_an_account_acheck.dart';
import 'package:fisheries_vendorapp/widgets/rounded_button.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../addregistration.dart';
import 'or_divider.dart';

class Body extends StatelessWidget {
  //google sign in
  // final GoogleSignIn googleAuth = new GoogleSignIn(scopes: [
  //   "https://www.googleapis.com/auth/user.birthday.read",
  //   "https://www.googleapis.com/auth/user.phonenumbers.read"
  // ]);
  //Facebook sign in
 // final FacebookLogin fbLogin = new FacebookLogin();
  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final countriesProvider = Provider.of<CountryProvider>(context);
    final loader = Provider.of<PhoneAuthDataProvider>(context).loading;
    //OTP AUTH
    _showSnackBar(String text) {
      final snackBar = SnackBar(
        content: Text('$text'),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }

    startPhoneAuth() async {
      final phoneAuthDataProvider =
          Provider.of<PhoneAuthDataProvider>(context, listen: false);
      phoneAuthDataProvider.loading = true;
      var countryProvider =
          Provider.of<CountryProvider>(context, listen: false);
      bool validPhone = await phoneAuthDataProvider.instantiate(
          dialCode: countryProvider.selectedCountry.dialCode,
          onCodeSent: () {
            Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (BuildContext context) => PhoneAuthVerify()));
          },
          onFailed: () {
            _showSnackBar(phoneAuthDataProvider.message);
          },
          onError: () {
            _showSnackBar(phoneAuthDataProvider.message);
          });
      if (!validPhone) {
        phoneAuthDataProvider.loading = false;
        _showSnackBar("Oops! Number seems invaild");
        return;
      }
    }

    return Scaffold(
      key: scaffoldKey,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              // PhoneAuthGetPhone(),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: ShowSelectedCountry(
                  country: countriesProvider.selectedCountry,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SelectCountry()),
                    );
                  },
                ),
              ),
              // RoundedInputField(
              //   hintText: "Your Email",
              //   onChanged: (value) {},
              // ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
                child: PhoneNumberField(
                  controller:
                      Provider.of<PhoneAuthDataProvider>(context, listen: false)
                          .phoneNumberController,
                  prefix: countriesProvider.selectedCountry.dialCode ?? "+91",
                ),
              ),
              // RoundedPasswordField(
              //   onChanged: (value) {},
              // ),
              RoundedButton(
                text: "SIGNUP",
                press: () async {
                  await startPhoneAuth();
                }, // => Navigator.pushNamed(context, '/home'),
              ),
              SizedBox(height: size.height * 0.03),
              // AlreadyHaveAnAccountCheck(
              //   login: false,
              //   press: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return LoginScreen();
              //         },
              //       ),
              //     );
              //   },
              // ),
              // OrDivider(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
                  // SocalIcon(
                  //   iconSrc: "assets/icons/facebook.svg",
                  //   press: () {
                  //     fbLogin.logIn([
                  //       'email',
                  //       'public_profile',
                  //       'user_birthday'
                  //     ]).then((result) {
                  //       switch (result.status) {
                  //         case FacebookLoginStatus.loggedIn:
                  //           FacebookAccessToken facebookAccessToken =
                  //               result.accessToken;
                  //           AuthCredential authCredential =
                  //               FacebookAuthProvider.getCredential(
                  //                   accessToken: facebookAccessToken.token);
                  //           FirebaseAuth.instance
                  //               .signInWithCredential(authCredential)
                  //               .then((signedInUser) {
                  //             print(
                  //                 'Signed in as ${signedInUser.additionalUserInfo.profile}');
                  //             var fbDetails = FacebookAuthModel.fromJson(
                  //                 signedInUser.additionalUserInfo.profile);
                  //             Credentials loginData = Credentials(
                  //                 fbSignIn: fbDetails,
                  //                 identifier: "fb",
                  //                 userId: signedInUser.user.uid);
                  //             //Navigator.of(context).pushReplacementNamed('/addregistration',arguments: loginData);
                  //                 Navigator.pushAndRemoveUntil(
                  //                 context, MaterialPageRoute(
                  //                   builder: (context) => new AddRegistrationDetail(userData: loginData,)),
                  //                   (Route<dynamic> route) => false,);
                  //             // Navigator.of(context).pushNamedAndRemoveUntil(
                  //             //     '/addregistration',
                  //             //     (Route<dynamic> route) => false,
                  //             //     arguments: loginData);
                  //           }).catchError((e) {
                  //             print("fb login error : $e");
                  //           });
                  //           break;
                  //         case FacebookLoginStatus.cancelledByUser:
                  //           print('Cancelled by you');
                  //           break;
                  //         case FacebookLoginStatus.error:
                  //           print('Error');
                  //           print(result.errorMessage);
                  //           break;
                  //       }
                  //     }).catchError((e) {
                  //       print(e);
                  //     });
                  //   },
                  // ),
                  // SocalIcon(
                  //   iconSrc: "assets/icons/twitter.svg",
                  //   press: () {},
                  // ),
                  // SocalIcon(
                  //   iconSrc: "assets/icons/google-plus.svg",
                  //   press: () {
                  //     googleAuth.signIn().then((result) {
                  //       //_handleGetContact(result);
                  //       result.authentication.then((googleKey) {
                  //         final AuthCredential credential =
                  //             GoogleAuthProvider.getCredential(
                  //           accessToken: googleKey.accessToken,
                  //           idToken: googleKey.idToken,
                  //         );
                  //         FirebaseAuth.instance
                  //             .signInWithCredential(credential)
                  //             .then((signedInUser) {
                  //           print(
                  //               'Signed in as ${signedInUser.additionalUserInfo.profile}');
                  //           var googleData = GoogleAuthModel.fromJson(
                  //               signedInUser.additionalUserInfo.profile);
                  //           Credentials loginData = Credentials(
                  //               googleSignIn: googleData,
                  //               userId: signedInUser.user.uid);
                  //               print("gmail userid: ${signedInUser.user.uid}");
                  //               Navigator.pushAndRemoveUntil(
                  //                 context, MaterialPageRoute(
                  //                   builder: (context) => new AddRegistrationDetail(userData: loginData,)),
                  //                   (Route<dynamic> route) => false,);
                           
                  //         }).catchError((e) {
                  //           print(e);
                  //         });
                  //       }).catchError((e) {
                  //         print(e);
                  //       });
                  //     }).catchError((e) {
                  //       print(e);
                  //     });
                  //   },
                  // ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _handleGetContact(GoogleSignInAccount acc) async {
  //   final http.Response response = await http.get(
  //     'https://people.googleapis.com/v1/people/me/connections'
  //     '?personFields=phoneNumbers',
  //     headers: await acc.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data = json.decode(response.body);
  //   print(data);
  //   print("google header : ${acc.authHeaders}");
  // }

}
