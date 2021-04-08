import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/fishProduct.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class SelectFish extends StatefulWidget {
  final String title;
  final Function onPressed;
  final Function onClickFunction;

  SelectFish({
    Key key,
    this.title,
    this.onPressed,
    this.onClickFunction,
  }) : super(key: key);

  @override
  _SelectFishState createState() => _SelectFishState();
}

class _SelectFishState extends State<SelectFish> {
  final formKey = GlobalKey<FormState>();
  bool visibleData = true;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? ""),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          height: 70,
                          decoration: BoxDecoration(color: Colors.lightGreen),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Step 1-Video Uploaded'),
                              IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.white,
                                  onPressed: () {})
                            ],
                          )),
                      // Container(
                      //     height: 70,
                      //     decoration: BoxDecoration(color: Colors.grey[100]),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Text('Step 2-Repeat Yesterdays Product'),
                      //         IconButton(
                      //             icon: Icon(Icons.radio_button_unchecked),
                      //             color: Colors.black,
                      //             onPressed: () {})
                      //       ],
                      //     )),
                      Container(
                          height: 70,
                          decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Step 2-Select Fish'),
                              IconButton(
                                  icon: Icon(Icons.radio_button_unchecked),
                                  color: Colors.black,
                                  onPressed: () {})
                            ],
                          )),
                      FutureBuilder<List<FishProduct>>(
                        future: appState.getOurFishProduct(),
                        builder: (context, snapshot) {
                          var children = <Widget>[];
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              children = [
                                Container(
                                    width: fullWidth(context),
                                    height: fullHeight(context),
                                    child: Center(
                                        child: CircularProgressIndicator()))
                              ];
                              break;
                            default:
                              if (snapshot.hasError)
                                children = [Text('Error: ${snapshot.error}')];
                              else {
                                snapshot.data.length == 0
                                    ? children = null
                                    : snapshot.data.forEach((element) {
                                        //appState.getOurFishProduct().forEach((element) {
                                        var productId= element.productId;
                                        children.add(FishTile(
                                            productImg: element.productImg,
                                            productName: element.productName,
                                            originalPrice: element.originalPrice
                                                .toString(),
                                            price: element.price.toString(),
                                            productId: element.productId,
                                            productCategory:
                                                element.productCategory,
                                            productPieces: element.productPieces
                                                .toString(),
                                            productStatus:
                                                element.productStatus,
                                            productWeight:
                                                element.productWeight,
                                            stockAvailable: element
                                                .stockAvailable
                                                .toString(),
                                            formState: formKey,
                                            visibleData: visibleData,
                                            onClick: () {
                                              setState(() {
                                                //appState.addProductDetails(element);
                                                appState
                                                    .updateVendorPoductStatus(
                                                        false,
                                                        FishProduct(
                                                            productId: element
                                                                .productId));
                                                visibleData = true;
                                              });
                                            },
                                            onPressed: () {
                                              print(
                                                  "FISH ELEMENT ID: ${element.productId} \n");
                                              // appState.updateproductDetails(
                                              //     element);
                                              if (formKey.currentState
                                                  .validate()) {
                                                print("FORM VALIDATED");
                                                appState.updateproductDetails(
                                                    details: element,
                                                    todayOrder: false);
                                                setState(() {
                                                  if(element.productId==productId){
                                                    // visibleData = false;
                                                  }
                                                  else{
                                                    print("wrong Way");
                                                  }
                                                  // visibleData = false;
                                                });
                                                Navigator.pop(context);
                                              } else {
                                                print('validate issue');
                                              }
                                            }));
                                        print("hello");
                                        print(
                                            "Image url is ${element.productImg}");
                                      });
                                //data
                              }
                          }

                          print(
                              "::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                          return children == null
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  width: fullWidth(context),
                                )
                              : GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5.80,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 0.77,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: children,
                                );
                          //Column(children: children);
                        },

                        //  GridView.count(

                        //   crossAxisCount: snapshot.data== null ?? snapshot.data.length,
                        //   itemBuilder:(context, index){
                        //     // ignore: unused_local_variable
                        //     FishProduct fishDetail =snapshot.data[index];
                        //     return FishData(
                        //       productImg: snapshot.data[index].productImg,
                        //       productName:snapshot.data[index].productName,
                        //        originalPrice:snapshot.data[index].originalPrice,
                        //        price: snapshot.data[index].price,
                        //        productId: snapshot.data[index].productId,
                        //        productCategory:snapshot.data[index].productCategory ,
                        //        productPieces:snapshot.data[index].productPieces ,
                        //        productStatus: snapshot.data[index].productStatus,
                        //        productWeight: snapshot.data[index].productWeight,
                        //        stockAvailable: snapshot.data[index].stockAvailable,

                        //     );
                        //   }
                        // );
                      ),
                      FlatButton(
                        child: Text('Start Selling'),
                        color: Colors.blue[100],
                        onPressed: () async {
                          var response = await appState.startFishBusiness();
                          if (response) {
                            Navigator.pushNamed(context, '/todaysorder');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Something went wrong. Try again.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}

class FishTile extends StatefulWidget {
  final Function onPressed;
  final Function onClick;
  final String productId;
  final String originalPrice;
  final String price;
  final String productCategory;
  final String productImg;
  final String productName;
  final String productPieces;
  final bool productStatus;
  final int productWeight;
  final String stockAvailable;
  final GlobalKey<FormState> formState;
  final bool visibleData;

  const FishTile({
    Key key,
    this.onPressed,
    this.productName,
    this.originalPrice,
    this.productCategory,
    this.price,
    this.productId,
    this.productImg,
    this.productPieces,
    this.productWeight,
    this.productStatus,
    this.stockAvailable,
    this.formState,
    this.visibleData,
    this.onClick,
  }) : super(key: key);

  @override
  _FishTileState createState() => _FishTileState();
}

class _FishTileState extends State<FishTile> {
  bool isFullFish = false;
  // String sellingAs = "Selling as Per-KG/Price";
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Container(
      //decoration:BoxDecoration(color:Colors.grey[200]),

      child: Card(
        child: Column(
          children: [
            // Visibility(
            //   child: ,
            //   visible: widget.visibleData,
            //   replacement: Container(
            //     child: Image.asset('assets/images/select.png'),
            //   ),
            // ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.productImg,
                  //Image.asset('assets/images/select.png',

                  width: 180,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.productName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Visibility(
                    child: Container(
                      width: 22,
                      decoration: const ShapeDecoration(
                        color: Colors.lightBlueAccent,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.add, size: 15),
                        color: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var appstateInBuilder =
                                  Provider.of<AppState>(context);
                              return AlertDialog(
                                title: Text(widget.productName ?? ""),
                                scrollable: true,
                                actionsPadding: EdgeInsets.all(0),
                                actions: [
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                                content: Container(
                                  height: 260,
                                  width: 300,
                                  child: Form(
                                    key: widget.formState,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 300,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: appState
                                                .productTotalQuantityController,
                                            decoration: InputDecoration(
                                                labelText: 'Stock Available'),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return 'Text is empty';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        DropdownButton(
                                            isExpanded: true,
                                            value: appstateInBuilder
                                                .sellingAs, // A global variable used to keep track of the selection
                                            items: [
                                              'Selling as Per-KG/Price',
                                              'Selling as fish/Price'
                                            ].map((item) {
                                              return DropdownMenuItem(
                                                value: item,
                                                child: Text(item),
                                              );
                                            }).toList(),
                                            onChanged: (String selectedItem) {
                                              print(selectedItem);
                                              // setState(() {
                                              appstateInBuilder.setsellingAs =
                                                  selectedItem;
                                              print(
                                                  "Selling As: $selectedItem");
                                              if (appstateInBuilder.sellingAs ==
                                                  "Selling as Per-KG/Price") {
                                                isFullFish = false;
                                              } else {
                                                isFullFish = true;
                                              }
                                              // });
                                            }),
                                        !isFullFish
                                            ? Container(
                                                height: 50,
                                                width: 300,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: appState
                                                      .fishproductPiecesController,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Approx Pieces/KG'),
                                                  validator: (text) {
                                                    if (text == null ||
                                                        text.isEmpty) {
                                                      return 'Text is empty';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              )
                                            : Container(
                                                height: 50,
                                                width: 300,
                                                child: TextFormField(
                                                  controller:
                                                      appState.fishWeight,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: 'Fish Weight'),
                                                  validator: (text) {
                                                    if (text == null ||
                                                        text.isEmpty) {
                                                      return 'Text is empty';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                        Container(
                                          height: 50,
                                          width: 300,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: appState
                                                .productPricePerKGController,
                                            decoration: InputDecoration(
                                              labelText: !isFullFish
                                                  ? 'Price Per Kg'
                                                  : 'Fish Price',
                                            ),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return 'Text is empty';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        ElevatedButton(
                                          // style: ButtonStyle(c),
                                          child: Text('Done'),
                                          // color: Colors.blue[50],
                                          onPressed: widget.onPressed,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    visible: widget.visibleData,
                    replacement: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.black,
                      onPressed: widget.onClick,
                      //() {
                      //setState(() {
                      //this.visibleData = true;
                      //});
                      //}
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
