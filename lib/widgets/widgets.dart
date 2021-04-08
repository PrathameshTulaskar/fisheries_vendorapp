import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/country.dart';

class PhoneAuthWidgets {
  static Widget getLogo({String logoPath, double height}) => Material(
        type: MaterialType.transparency,
        elevation: 10.0,
        child: Image.asset(logoPath, height: height),
      );
}

class SearchCountryTF extends StatelessWidget {
  final TextEditingController controller;

  const SearchCountryTF({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
      child: Card(
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search your country',
            contentPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String prefix;

  const PhoneNumberField({Key key, this.controller, this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Text("  " + prefix + "  ", style: TextStyle(fontSize: 16.0)),
          SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              autofocus: false,
              keyboardType: TextInputType.phone,
              key: Key('EnterPhone-TextFormField'),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorMaxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IsFeatured extends StatelessWidget {
  final bool isFeatured;
  final Function taphere;
  const IsFeatured({Key key, this.isFeatured, this.taphere}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: isFeatured
          ? Icon(
              Icons.favorite,
              size: 15,
              color: Colors.red[900],
            )
          : Icon(
              Icons.favorite_border,
              size: 15,
              color: Colors.red[900],
            ),
      onTap: taphere,
    );
  }
}

class TitleTextBuilder extends StatelessWidget {
  final String sendText;
  const TitleTextBuilder({Key key, this.sendText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(sendText,
        style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 20 , color: Colors.white));
  }
}
class DialogTextBuilder extends StatelessWidget {
  final String sendText;
  const DialogTextBuilder({Key key, this.sendText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(sendText,
        style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 16 , color: Colors.grey[800]));
  }
}

class Subscribed extends StatelessWidget {
  final bool subscribed;
  final String reason;
  const Subscribed({Key key, this.subscribed, this.reason}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       // SizedBox(height: 15),
        subscribed
            ? Icon(
                Icons.check,
                color: Colors.green,
                size: 20,
              )
            : Icon(
                Icons.warning,
                size: 20,
                color: Colors.red,
              ),
       // SizedBox(height: 15),
        //subscribed ? Text("Subscribed") : Text(reason ?? "not done")
      ],
    );
  }
}

class ProductVerified extends StatelessWidget {
  final bool isVerified;
  final String reason;
  const ProductVerified({Key key, this.reason, this.isVerified})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 15),
        isVerified
            ? Icon(
                Icons.tag_faces,
                color: Colors.green,
                size: 20,
              )
            : Icon(
                Icons.tag_faces,
                size: 20,
                color: Colors.green,
              ),
        SizedBox(height: 15),
        isVerified ? Text("Verified") : Text(reason ?? "On Hold")
      ],
    );
  }
}
class SubText extends StatelessWidget {
  final String sendText;
  final String sendColor;
  const SubText({Key key, this.sendText,this.sendColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(sendText, 
      style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 15 , color: Colors.blueGrey),
    );
  }
}
class SubTitle extends StatelessWidget {
  final String text;

  const SubTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(' $text',
            style: TextStyle(color: Colors.white, fontSize: 14.0)));
  }
}

class ShowSelectedCountry extends StatelessWidget {
  final VoidCallback onPressed;
  final Country country;

  const ShowSelectedCountry({Key key, this.onPressed, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(' ${country.flag}  ${country.name} ')),
              Icon(Icons.arrow_drop_down, size: 24.0)
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableWidget extends StatelessWidget {
  final Function(Country) selectThisCountry;
  final Country country;

  const SelectableWidget({Key key, this.selectThisCountry, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: InkWell(
        onTap: () => selectThisCountry(country), //selectThisCountry(country),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "  " +
                country.flag +
                "  " +
                country.name +
                " (" +
                country.dialCode +
                ")",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
class TextFieldIcon extends StatelessWidget {
  final Widget iconPrefix;
  final String label;
  final bool showIcon; 
  final Function(String) validate;
  final TextEditingController controllerName;
  const TextFieldIcon({Key key, this.controllerName,this.showIcon = false,this.iconPrefix, this.label,this.validate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controllerName,
      decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green
            )
          ),
          border:  OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green
            )
          ),
          //fillColor: Colors.green,
          //focusColor: Colors.green,
          prefixIcon: showIcon ? 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: iconPrefix,
          ): null) ,

          validator: validate,
    );
  }
} 