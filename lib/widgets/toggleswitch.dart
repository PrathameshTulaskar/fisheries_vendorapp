import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:provider/provider.dart';

class SwitchToggle extends StatefulWidget {
  final bool currentState;
  final Function updateState;
  final String superMarketID;
  SwitchToggle({Key key, this.currentState, this.updateState, this.superMarketID})
      : super(key: key);

  @override
  _SwitchToggleState createState() =>
      _SwitchToggleState(currentState, updateState ,superMarketID );
}

class _SwitchToggleState extends State<SwitchToggle> {
  bool switchControl;
  Function updateControl;
  String superMarketID;
  _SwitchToggleState(this.switchControl, this.updateControl , this.superMarketID);
  // bool switchControl = ;
  var textHolder = "";


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Switch(
        onChanged: (value) {
          if (switchControl == false) {
            setState(() {
              switchControl = true;
             // textHolder = 'Visiblity On';
            });
            print('Visiblity On');
            // Put your code here which you want to execute on Switch ON event.

          } else {
            setState(() {
              switchControl = false;
              //textHolder = 'Visiblity Off';
            });
            print('Visiblity Off');
            // Put your code here which you want to execute on Switch OFF event.
          }
          appState.setSupermarketVisiblity(widget.superMarketID, switchControl);

        },
        value: switchControl,
        activeColor: Colors.white,
        activeTrackColor: Colors.green,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.grey,
      ),
      // Text( switchControl ? 'store visiblity on': 'store visiblity off',
      //   style: TextStyle(fontSize: 12),
      // )
    ]);
  }
}
