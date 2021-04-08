import 'package:flutter/material.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:intl/intl.dart';

AssetImage backgroundImage = AssetImage("assets/images/background.png");
MaterialColor primaryColor = Colors.deepPurple;
Color white = Colors.white;
// BoxDecoration backgroundDecoration = BoxDecoration(
//     image: DecorationImage(
//         image: AssetImage("assets/images/background.png"), fit: BoxFit.cover));
// fullWidth(BuildContext context) {
//   return MediaQuery.of(context).size.width;
// }
sectionTitle(String title, String actionButtonTitle, Function() action,BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(title,style: Theme.of(context).textTheme.subtitle2,),
      InkWell(
        child: Text(actionButtonTitle),
        onTap: action,
      )
    ],
  );
}
// fullHeight(BuildContext context) {
//   return MediaQuery.of(context).size.height;
// }

Widget errorText(
    String errorText, Color textColor, Color backgroundColor, bool showError) {
  return Visibility(
    child: SizedBox(
        height: 20,
        child: Text(
          errorText,
          style: TextStyle(
            backgroundColor: backgroundColor,
            color: textColor,
          ),
        )),
    visible: showError,
  );
}

Widget successText(
    String errorText, Color textColor, Color backgroundColor, bool showError) {
  return Visibility(
    child: SizedBox(
        height: 20,
        child: Text(
          errorText,
          style: TextStyle(
            backgroundColor: backgroundColor,
            color: textColor,
          ),
        )),
    visible: showError,
  );
}

showLoadingDialog(BuildContext context, GlobalKey key) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
              key: key,
              backgroundColor: Colors.black54,
              children: <Widget>[
                Center(
                  child: Column(children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please Wait....",
                      style: TextStyle(color: Colors.blueAccent),
                    )
                  ]),
                )
              ]),
        );
      });
}

longButton(BuildContext context, Function() onpressed, String buttonName,
    Color buttonColor) {
  return Padding(
      padding: EdgeInsets.fromLTRB(33, 0, 33, 0),
      child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          //color: Color(0xff01A0C7),
          color: buttonColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            onPressed: onpressed,
            child: Text(
              buttonName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.button,
            ),
          )));
}

gradientLongButton(
    BuildContext context, String buttonText, Function() onpressed) {
  return Container(
    height: 50.0,
    child: RaisedButton(
      onPressed: onpressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              //**Prathamesh */
              // List: ,
               colors: [Color(0xff374ABE), Colors.deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0)),
        child: Container(
          constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    ),
  );
}

textFieldWithValidation(
    TextEditingController controllerName,
    //String label,
    String placeHolder,
    IconData icon,
    bool passwordField,
    TextInputType keyboardType,
    String Function(String) validateLogic) {
  return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: TextFormField(
            decoration: InputDecoration(
                icon: Icon(icon),
                //hintText: placeHolder,
                labelText: placeHolder,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none),
            controller: controllerName,
            obscureText: passwordField,
            keyboardType: keyboardType,
            validator: validateLogic,
          )));
}

textFieldLabel(BuildContext context, String labelText) {
  return Container(
    child: Padding(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(labelText, style: Theme.of(context).textTheme.subtitle1)),
    ),
  );
}

// textField(
//     TextEditingController controllerName,
//     //String label,
//     String placeHolder,
//     IconData icon,
//     bool passwordField,
//     TextInputType keyboardType) {
//   return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 0.2,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(10)),
//       ),
//       child: Padding(
//           padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
//           child: TextFormField(
//             decoration: InputDecoration(
//                 icon: Icon(icon),
//                 //hintText: placeHolder,
//                 labelText: placeHolder,
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 focusedErrorBorder: InputBorder.none),
//             controller: controllerName,
//             obscureText: passwordField,
//             keyboardType: keyboardType,
//           )));
// }

textFieldBlack(
  TextEditingController controllerName,
  String label,
  String hintText,
  TextInputType keyboardType,
  Function(String value) validationLogic,
  bool readOnly,
) {
  return Padding(
    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: TextFormField(
        //autovalidate: false,
        readOnly: readOnly,
        validator: validationLogic,
        keyboardType: keyboardType,
        controller: controllerName,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(labelText: label, hintText: hintText)),
  );
}

// dateFormField(TextEditingController controllerName, String labelText,
//     Color fieldBackground, bool readOnly, DatePickerMode datePickerType) {
//   return Padding(
//       padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//       child: DateTimeField(
//         format: DateFormat("yyyy-MM-dd"),
//         readOnly: readOnly,
//         controller: controllerName,
//         //autovalidate: true,
//         validator: (date) => (date == null) ? 'Date Required' : null,

//         decoration: InputDecoration(
//           errorStyle: TextStyle(
//               fontWeight: FontWeight.bold,
//               backgroundColor: Colors.white,
//               fontSize: 12),
//           filled: true,
//           fillColor: fieldBackground,
//           labelText: labelText,
//         ),
//         onShowPicker: (context, currentValue) {
//           return showDatePicker(
//             context: context,
//             firstDate: DateTime(1900),
//             initialDate: currentValue ?? DateTime.now(),
//             lastDate: DateTime(2100),
//             initialDatePickerMode: datePickerType,
//           );
//         },
//       ));
// }

// timePickerField(TextEditingController controllerName, String labelText,
//     Color fieldBackground, Function(DateTime value) onChanged) {
//   return Padding(
//       padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//       child: DateTimeField(
//         controller: controllerName,
//         validator: (time) => (time == null) ? 'Time Required' : null,
//         decoration: InputDecoration(
//           errorStyle: TextStyle(
//               fontWeight: FontWeight.bold,
//               backgroundColor: Colors.white,
//               fontSize: 12),
//           filled: true,
//           fillColor: fieldBackground,
//           labelText: labelText,
//         ),
//         onChanged: onChanged,
//         format: DateFormat("hh:mm a"),
//         onShowPicker: (context, currentValue) async {
//           final time = await showTimePicker(
//             context: context,
//             initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//           );
//           return DateTimeField.convert(time);
//         },
//       ));
// }

Widget textArea(TextEditingController controllerName, String labelText,
    String validationMessage, Color backgroundColor) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: TextFormField(
      maxLines: 3,
      controller: controllerName,
      keyboardType: TextInputType.multiline,
      validator: (value) => value.isEmpty ? validationMessage : null,
      //style: TextStyle(color: Colors.white,),
      decoration: InputDecoration(
        errorStyle: TextStyle(
            fontWeight: FontWeight.bold, backgroundColor: Colors.white),
        labelText: labelText,
        fillColor: backgroundColor,
        filled: true,
      ),
    ),
  );
}

Widget showProgress() {
  return Center(
    child: SizedBox(
        width: 40.0,
        height: 40.0,
        child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor))),
  );
}

// VALIDATION
String validateName(String value) {
  if (value.length < 3)
    return 'Name must be more than 2 charater';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
// VALIDATION
Widget homeMenuItem(
    String title, String subtitle, Widget iconImage,BuildContext context, Function() onPressed) {
  return Container(
    width: 100,
    height: 97,
    decoration: new BoxDecoration(
      color: Colors.white,
      border: new Border.all(

          //color: Colors.green,
          width: 5.0,
          style: BorderStyle.none),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      boxShadow: [
        new BoxShadow(
          color: Colors.black26,
          offset: new Offset(20.0, 10.0),
          blurRadius: 20.0,
        )
      ],
    ),
    child: FlatButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              child: iconImage,
              radius: 15,
            ),
          ),
          SizedBox(height: 1),
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 15),
          
            textAlign: TextAlign.center,
          ),

          Text(
            subtitle,
            style: TextStyle(fontSize: 12),
          ),
          //SizedBox(height:20)
        ],
      ),
    ),
  );
}
