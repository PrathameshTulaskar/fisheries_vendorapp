import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fisheries_vendorapp/screen/Login/components/background.dart';
import 'package:fisheries_vendorapp/screen/Signup/signup_screen.dart';
import 'package:fisheries_vendorapp/widgets/already_have_an_account_acheck.dart';
import 'package:fisheries_vendorapp/widgets/rounded_button.dart';
import 'package:fisheries_vendorapp/widgets/rounded_input_field.dart';
import 'package:fisheries_vendorapp/widgets/rounded_password_field.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () => Navigator.pushNamed(context, '/home'),
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}