import "package:flutter/material.dart";
//import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:fisheries_vendorapp/models/product.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/productTile.dart';
import 'package:fisheries_vendorapp/screen/categorylistforstep2.dart';
//import 'package:getflutter/components/list_tile/gf_list_tile.dart';
//import 'package:fisheries_vendorapp/util/themedata.dart';
//import 'package:fisheries_vendorapp/widgets/productTile.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SelectProducts extends StatefulWidget {
  final String supermarketID;
  SelectProducts({Key key, this.supermarketID})
      : super(key: key);
  @override
  _SelectProductsState createState() => _SelectProductsState();
}

class _SelectProductsState extends State<SelectProducts> {
  
  @override
  Widget build(BuildContext context) {
    final ArgsForProd args = ModalRoute.of(context).settings.arguments;
    final appState = Provider.of<AppState>(context);
    final formKey = new GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(
          title:  TitleTextBuilder(
             sendText: "${args.categoryName}",
          ),//Text(),
        ),
        body: SingleChildScrollView(
                  child: Container(
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  //IconButton(icon: Icon(Icons.refresh), onPressed: () =>  setState(() {})),
                  Text("Pick From Our Store"),
                  SizedBox(
                    height: 25,
                  ),
                  //sectionTitle("Dairy","more",(){},context),
                  SizedBox(
                    height: 8.0,
                  ),
                  FutureBuilder<List<Product>>(
                      future: appState.fetchOurproductsFunction(args.categoryName),
                      builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                        var children = <Widget>[];
                        if (snapshot.hasData) {
                          snapshot.data.forEach((element) {
                            print("product weight : ${element.productweight}");
                            children.add(
                              ProductTile(
                                availableStock: element.stockAvailable == "null" ? "0" : element.stockAvailable,
                                imgUrl: element.imageUrl,
                                price: element.price == "null" ? "0" : element.price ,
                                productName: element.productName,
                                productId: element.productId,
                                productCategory: args.categoryName,
                                supermarketId: "",
                                isFeatured: element.isFeatured ?? false,
                                productStatus: element.productStatus ?? true,
                                productPrice: appState.productPriceUpdate,
                                productStock: appState.productQtyUpdate,
                                bottomButtonText: "ADD",
                                showDelete: true,
                                sellPrice: element.sellPrice == "null" ? "0" : element.sellPrice,
                                formkey: formKey,
                                sellingPrice: appState.sellingPriceUpdate,
                                onUpdatePressed: () async {
                                  print(appState.productPriceUpdate.text);
                                  var response = await appState.addProduct(
                                    productNameValue: element.productName,
                                    productCategoryValue: args.categoryName,
                                    productPriceValue: appState.productPriceUpdate.text,
                                    productQuantity: appState.productQtyUpdate.text,
                                    imgUrl: element.imageUrl,
                                    supermarketId: args.supermarketId,
                                    productWt: element.productweight == "null" ? "0" : element.productweight,
                                    productUnit: element.productUnit ?? "" ,
                                    sellPrice: appState.sellingPriceUpdate.text,
                                    prodStatus: true,
                                  ).catchError((onError) {
                                      print(
                                          "error on add product screen: $onError");
                                    });
                                    if (response) {
                                      print("done");
                                     
                                      Navigator.of(context).pop();
                                    } else {
                                      print("something went wrong");
                                    }
                                },
                               
                              ),
                            );
                          });
                        } else {
                          children.add(Center(
                            child: CircularProgressIndicator(),
                          ));
                        }
                        return GridView.count(
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.50,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: children);
                      }),
                       SizedBox(height:30),
                  // InkWell(
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.only(
                  //         bottomLeft: Radius.circular(5),
                  //         bottomRight: Radius.circular(5)),
                  //     child: Container(
                  //       child: Center(
                  //           child: Text(
                  //         "Go to next Category",
                  //         style: Theme.of(context).textTheme.bodyText2.copyWith(
                  //             fontWeight: FontWeight.bold, color: Colors.white),
                  //       )),
                  //       color: Colors.deepPurple,
                  //       width: 200,
                  //       height: 40,
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, "/categorylistforstep2" , arguments: args);
                  //   },
                  //   //focusColor: Colors.red,
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}

