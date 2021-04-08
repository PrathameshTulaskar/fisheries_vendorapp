import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';


class Addproduct extends StatefulWidget {
  final String finalSupermarketID;
  Addproduct({Key key, this.finalSupermarketID}) : super(key: key);

  @override
  _AddproductState createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String productName;

  /// Active image file
  File _imageFile;
  final _formKeyProduct = new GlobalKey<FormState>(debugLabel: "addProductKey");
  String categoryValueSelected;
  String unitsSelected;
  bool isUploaded = false;

  // _saveForm() {
  //   var form = formKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     setState(() {
  //       _myActivityResult = _myActivity;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    UnfocusDisposition disposition = UnfocusDisposition.scope;
    final appState = Provider.of<AppState>(context);
    final FocusNode fnOne = FocusNode();
    final FocusNode productQty = FocusNode();
    final FocusNode productWeight = FocusNode();
    final FocusNode price = FocusNode();
    final FocusNode sellingPrice = FocusNode();
    final FocusNode unitSelectn = FocusNode();
    final FocusNode describeCat = FocusNode();
    final FocusNode addBtn = FocusNode();
    final FocusNode productNameFocus = FocusNode();
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                title: TitleTextBuilder(
              sendText: "Add Product",
            ) //("add product"),
                ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: fullWidth(context),
                  // decoration: backgroundDecoration,
                  child: Form(
                    key: _formKeyProduct,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () async {
                                var snackBar = SnackBar(
                                  content: Text("Image Uploading"),
                                  backgroundColor: Colors.yellow[900],
                                );

                                // ImagePicker.platform.pickImage(
                                //         source: ImageSource.gallery,
                                //         imageQuality: 80)
                                //     .then((value) => setState(() {
                                //           _imageFile = value;
                                //           _scaffoldKey.currentState
                                //               .showSnackBar(snackBar);
                                //           appState
                                //               .uploadImage(_imageFile)
                                //               .then((value) {
                                //             if ((value != null) && value) {
                                //               print("uploaded!!");
                                //               setState(() {
                                //                 isUploaded = true;
                                //               });
                                //               if (isUploaded) {
                                //                 _scaffoldKey.currentState
                                //                     .hideCurrentSnackBar();
                                //                 _scaffoldKey.currentState
                                //                     .showSnackBar(SnackBar(
                                //                   content:
                                //                       Text("Image Uploaded"),
                                //                   backgroundColor:
                                //                       Colors.lightGreen,
                                //                 ));
                                //               } else {
                                //                 _scaffoldKey.currentState
                                //                     .hideCurrentSnackBar();
                                //                 _scaffoldKey.currentState
                                //                     .showSnackBar(SnackBar(
                                //                   content: Text(
                                //                       "Oops!! Image not uploaded. Please try again or contact support"),
                                //                   backgroundColor: Colors.red,
                                //                 ));
                                //               }
                                //             }
                                //           });
                                //         }));
                              },
                              child: _imageFile == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      size: 50,
                                    )
                                  : Image.file(
                                      _imageFile,
                                      width: 50.0,
                                      height: 50.0,
                                    ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 230, maxHeight: 300),
                                  child: TextFormField(
                                      focusNode: productNameFocus,
                                      controller: appState.productName,
                                      onChanged: (value) {
                                        setState(() {
                                          productName = value;
                                        });
                                      },
                                      onFieldSubmitted: (term) {
                                        //productNameFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(productQty);
                                      },
                                      //autofocus: true,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          labelText: "Product Name",
                                          hintText: "eg: Sugar - 1kg"),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Required";
                                        } else {
                                          return null;
                                        }
                                      }),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: new Wrap(
                                  spacing: 8.0, // gap between adjacent chips
                                  runSpacing: 4.0, // gap between lines
                                  direction: Axis
                                      .horizontal, // main axis (rows or columns)
                                  children: <Widget>[
                                    TextFormField(
                                      onFieldSubmitted: (term) {
                                        productQty.unfocus();
                                        //primaryFocus.unfocus(disposition: disposition);
                                        FocusScope.of(context)
                                            .requestFocus(productWeight);
                                            //productWeight.nextFocus();
                                      },
                                      onTap: (){
                                        primaryFocus.unfocus(disposition: disposition);
                                      },
                                       textInputAction: TextInputAction.next,
                                      focusNode: productQty,
                                      controller: appState.productQty,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Stock Available"),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                              
                                       textInputAction: TextInputAction.done,
                                focusNode: productWeight,
                                keyboardType: TextInputType.number,
                                controller: appState.productWeight,
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
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: DropDownFormField(
                                
                                filled: false,
                                value: unitsSelected,
                                onSaved: (value) {
                                  appState.productUnits.text = value;
                                  setState(() {
                                    unitsSelected = value;
                                  });
                                  print("onSaved: $value");
                                  print(appState.productUnits.text);
                                },
                                onChanged: (value) {
                                  appState.productUnits.text = value;
                                  setState(() {
                                    unitsSelected = value;
                                  });
                                  print("on changed : $value");
                                  print(appState.productUnits.text);
                                },
                                titleText: null,
                                hintText: "Units",
                                dataSource: [
                                  {'display': 'Kg', 'value': 'Kg'},
                                  {'display': 'mg', 'value': 'mg'},
                                  {'display': 'g', 'value': 'g'},
                                  {'display': 'ltr', 'value': 'ltr'},
                                  {'display': 'ml', 'value': 'ml'}
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                     onFieldSubmitted: (term) {
                                       // price.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(sellingPrice);
                                      },
                                       textInputAction: TextInputAction.next,
                                    focusNode: price,
                                    keyboardType: TextInputType.number,
                                    controller: appState.productPrice,
                                    onChanged: (value) {
                                      appState.sellingPrice.text = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration:
                                        InputDecoration(labelText: "Add Price"),
                                  ),
                                ),
                                SizedBox(width: 30),
                                Expanded(
                                  child: TextFormField(
                                    focusNode: sellingPrice,
                                    keyboardType: TextInputType.number,
                                    controller: appState.sellingPrice,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Selling Amount"),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 25),
                            DropDownFormField(
                              filled: false,
                              titleText: null,
                              hintText: "Please Add Category For Product",
                              value: categoryValueSelected,
                              onSaved: (value) {
                                appState.productCategory.text = value;
                                setState(() {
                                  categoryValueSelected = value;
                                });
                                print("onSaved: $value");
                                print(appState.productCategory.text);
                              },
                              onChanged: (value) {
                                appState.productCategory.text = value;
                                setState(() {
                                  categoryValueSelected = value;
                                });
                                print("on changed : $value");

                                print(appState.productCategory.text);
                              },
                              dataSource: appState.categoriesList ?? [],
                              textField: 'display',
                              valueField: 'value',
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                                focusNode: addBtn,
                                disabledColor: Colors.amber,
                                color: Colors.red,
                                textColor: Colors.white,
                                onPressed: isUploaded == false
                                    ? () async {
                                      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Image Or Product Details Missing.'),backgroundColor: Colors.red,
          ),
        );
                                    
                                      }
                                    : () async {
                                        print(_formKeyProduct
                                            .currentContext.widget.key);
                                        if (_formKeyProduct.currentState
                                                .validate() &&
                                            isUploaded) {
                                          print("here!");
                                          //formKey.currentState.save();
                                          var response =
                                              await appState.addProduct(
                                                  supermarketId:
                                                      widget.finalSupermarketID,
                                                  prodStatus: false);
                                          if (response) {
                                            print("success adding product");
                                            _scaffoldKey.currentState
                                                .hideCurrentSnackBar();
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Product added Successfully"),
                                              backgroundColor: Colors.green,
                                            ));
                                            appState.productName.clear();
                                            appState.productQty.clear();
                                            appState.productWeight.clear();
                                            appState.productUnits.clear();
                                            appState.productPrice.clear();
                                            appState.sellingPrice.clear();
                                            appState.productCategory.clear();
                                            setState(() {
                                              _imageFile = null;
                                              isUploaded = false;
                                              categoryValueSelected = null;
                                              unitsSelected = null;
                                            });
                                          } else {
                                            _scaffoldKey.currentState
                                                .hideCurrentSnackBar();
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Oops!! Something went wrong. Please try again or contact support."),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        }
                                      },
                                child: Text("ADD"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
