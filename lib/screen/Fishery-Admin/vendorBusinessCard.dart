import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:provider/provider.dart';

class VendorBusinessCard extends StatefulWidget {
  VendorBusinessCard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VendorBusinessCardState createState() => _VendorBusinessCardState();
}

class _VendorBusinessCardState extends State<VendorBusinessCard> {
  bool error = false;
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, '/home')),
        title: Text("Manage Business"),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Center(
            child: Container(
                // height: 135,
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(width: 1.0, color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 1.0,
                      spreadRadius: 0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ///Align(alignment:Alignment.topRight,child: Text("Reviews")),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 50),
                          Text(appState.fishBusiness.businessName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                child: Text("Reviews",
                                    style: TextStyle(color: Colors.green)),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/reviewDetails');
                                }),
                          ),
                        ]),
                    SizedBox(
                      height: 50,
                    ),
                    // Text("Total Sale:20"),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          appState.fishBusiness.productAvailable
                              ? InkWell(
                                  child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                      ),
                                      child:
                                          Center(child: Text("Today's Order"))),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/todaysorder');
                                  })
                              : InkWell(
                                  child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[200],
                                      ),
                                      child: Center(
                                          child: Text("Start Business"))),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/fishery');
                                  }),
                          InkWell(
                              child: Container(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child:
                                        Center(child: Text("Orders History")),
                                  )),
                              onTap: () {
                                Navigator.pushNamed(
                                  context, '/orderHistory',
                                  // arguments:
                                );
                              }),
                        ]),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                )),
          )
        ]),
      ),
    );
  }
}
