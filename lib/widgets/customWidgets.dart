import 'package:flutter/material.dart';

import 'colors.dart';

fullWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

sectionTitle(String title, String actionButtonTitle, Function() action,
    BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: Theme.of(context).textTheme.subtitle2,
      ),
      InkWell(
        child: Text(actionButtonTitle),
        onTap: action,
      )
    ],
  );
}
Widget locationTile(String title, String subtitle, Widget icon,
    BuildContext context, Function() ontap) {
  return ListTile(
    leading: icon,
    isThreeLine: true,
    title: Text(title),
    subtitle: Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          subtitle,
          style:
              Theme.of(context).textTheme.bodyText2.copyWith(color: greyColor),
        ),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: blackColor))),
    ),
    onTap: ontap,
  );
}

Widget textField(String label,bool readOnly,TextEditingController controller,{Function(String) validator,TextInputType keyboard = TextInputType.text}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: label),
    readOnly: readOnly,
    validator: validator,
    keyboardType: keyboard,
  );
}
class BorderBtn extends StatelessWidget {
  final Color borderColor;
  final String buttonText;
  final bool fullWidthBtn;
  final Function onBtnPress;
  const BorderBtn({
   this.borderColor,
   this.buttonText = 'ADD MORE DETAILS',
   this.fullWidthBtn = false,
   this.onBtnPress 
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: onBtnPress,
        child: Container(
          width: fullWidthBtn ? fullWidth(context) : 155,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(buttonText,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: borderColor,fontWeight: FontWeight.bold)),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: borderColor, width: 1)),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.all(0));
  }
}
class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return 
    LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
