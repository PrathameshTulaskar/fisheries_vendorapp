import "package:flutter/material.dart";
import 'package:fisheries_vendorapp/widgets/widgets.dart';
//import 'package:fisheries_vendorapp/util/themedata.dart';

class SignUpRegistration extends StatefulWidget {
  @override
  _SignUpRegistrationState createState() => _SignUpRegistrationState();
}

class _SignUpRegistrationState extends State<SignUpRegistration> {
  int _currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleTextBuilder(sendText: "Register With Us"),
      ),
      body: SingleChildScrollView(
       // scrollDirection: Axis.horizontal,
        child: Column(
          children: <Widget>[
            Form(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                                              child: TextFormField(
                                 // controller: appState.productWeight,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "First Name",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 9, 9, 9)),
                                ),
                      ),
                              Expanded(
                                                              child: TextFormField(
                                 // controller: appState.productWeight,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Last Name",
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 9, 9, 9)),
                                ),
                              ),
                    ],
                  ),
                  TextFormField(
                               // controller: appState.productWeight,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: "Phone No.",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 9, 9, 9)),
                              ),
                              TextFormField(
                                //controller: appState.productWeight,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: "Email",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 9, 9, 9)),
                              ),
                              TextFormField(
                                //controller: appState.productWeight,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Required";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: "Product Net Weight",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 9, 9, 9)),
                              ),
                              
                ],
              )),
           // steps(),
            SizedBox(height:30),
            InkWell(
                child: ClipRRect(
borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5)),
                  child: Container(
                    child: Center(
                        child: Text(
                      "Proceed to add products",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                    )),
                    color: Colors.deepPurple,
                    width:200,
                    height: 40,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/categorylistforstep2");
                },
                //focusColor: Colors.red,
              )
          ],
        ),
      ),
    );
  }

  Widget steps() {
    return Column(
      children: <Widget>[
        Stepper(
              //type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep >= 2) return;
                setState(() {
                  _currentStep += 1;
                });
              },
              onStepCancel: () {
                if (_currentStep <= 0) return;
                setState(() {
                  _currentStep -= 1;
                });
              },
              steps: [
                Step(

                  title: Text("User Details"),
                  content: new Wrap(
                    children: <Widget>[
                      Icon(Icons.person),
                      Text("Name"),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "enter value";
                          }
                          else{
                            return null;
                          }
                        } ,
                      ),
                      Icon(Icons.phone),
                      Text("Phonne Number"),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "enter value";
                          }
                          else{
                            return null;
                          }
                        } ,
                      ),
                      Icon(Icons.phone),
                      Text("Phonne Number"),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "enter value";
                          }
                          else{
                            return null;
                          }
                        } ,
                      )
                    ],
                  ),
                ),
                Step(
                  title: Text("Verification"),
                  content: new Wrap(
                    children: <Widget>[
                      Icon(Icons.phone),
                      Text("Verify Code"),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "enter value";
                          }
                          else{
                            return null;
                          }
                        } ,
                      )
                    ],
                  ),
                ),
                Step(
                  title: Text("Business"),
                  content: new Wrap(
                    children: <Widget>[
                      Icon(Icons.home),
                      Text("Shop Name"),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "enter value";
                          }
                          else{
                            return null;
                          }
                        } ,
                      ),
                      Text("Shop Details"),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return "enter value";
                          }
                          else{
                            return null;
                          }
                        } ,
                      )
                    ],
                  ),
                ),
              ],
            ),
      ],
    );
  }
}