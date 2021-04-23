import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:provider/provider.dart';
import 'package:youtube_parser/youtube_parser.dart';

class AddYoutubeLink extends StatefulWidget {
  AddYoutubeLink({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddYoutubeLinkState createState() => _AddYoutubeLinkState();
}

class _AddYoutubeLinkState extends State<AddYoutubeLink> {
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
    var _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Video"),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 150),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.70,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  color: Colors.white),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        readOnly: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "paste your link here"),
                        controller: appState.youtubeLinkController,
                        validator: (value) {
                          print(value);
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      tooltip: "paste",
                      onPressed: () async {
                        appState.youtubeLinkController.text =
                            await FlutterClipboard.paste();
                        String foo =
                            getIdFromUrl(appState.youtubeLinkController.text);
                        if (foo == null &&
                            appState.youtubeLinkController.text.length != 0) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          setState(() {
                            error = false;
                          });
                          //code here
                        }
                      },
                      icon: Icon(Icons.paste),
                    ),
                    Text("Paste")
                  ],
                ),
                // SizedBox(width:20),
                Column(
                  children: [
                    IconButton(
                      tooltip: "reset",
                      onPressed: () {
                        appState.youtubeLinkController.clear();
                      },
                      icon: Icon(Icons.refresh_rounded),
                    ),
                    Text("Reset")
                  ],
                ),
              ],
            ),
            SizedBox(height: 45),
            error
                ? Text("Link Incorrect",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.red))
                : Container(),
            SizedBox(height: 8.0),
            Container(
              height: 60,
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: TextButton(
                  child: Text('Select Fish'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[200])),
                  // color: Colors.blue[200],
                  onPressed: () => {
                        // String youtubeLink,
                        if (appState.youtubeLinkController
                            .toString()
                            .contains('youtube.com'))
                          {
                            appState.updatevideoLink(),
                            Navigator.pushNamed(context, '/selectFish'),
                            print("in flatbutton"),
                          }
                        else
                          {
                            print("your link does not exist"),
                          }
                      }),
            ),
          ],
        ),
      ),
    );
  }
}

