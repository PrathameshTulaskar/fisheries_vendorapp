import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/argsList.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/models/product.dart';
import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/services/firestore_services.dart';
import 'package:fisheries_vendorapp/util/themedata.dart';
import 'package:fisheries_vendorapp/widgets/colors.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/productTile.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LowStock extends StatefulWidget {
  LowStock({Key key}) : super(key: key);

  @override
  _LowStockState createState() => _LowStockState();
}

class _LowStockState extends State<LowStock> {
  FirestoreService firebaseService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    final lowStockProductKey = new GlobalKey<FormState>();
    SupermarketDetails supermarket = ModalRoute.of(context).settings.arguments;
    String supermarketId = supermarket.superMarketID;
    final appState = Provider.of<AppState>(context);
    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_vert),
                title: Text("Orders"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                title: Text("Low Stock"),
              )
            ],
            onTap: (index) {
              print(index);
              if (index == 0) {
                Navigator.pushNamed(context, '/viewOrdersPage',
                    arguments: supermarket);
              }
            },
            currentIndex: 1,
          ),
          appBar: AppBar(
            title: Text("Low Stock"),
            // leading: Container(),
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Product>>(
                stream: 
                // Firestore.instance
                //     .collection(
                //         "grocery/products/productList/$supermarketId/supermarketProducts")
                //     .where("stockAvailable", isLessThan: 11)
                //     .snapshots()
                //     .map((event) => event.documents.map((e) {
                //           String productId = e.documentID;
                //           Map<String, dynamic> moreData = e.data;
                //           Map<String, dynamic> productIdMap = {
                //             'productId': productId
                //           };
                //           Map<String, dynamic> mergedMap = {};
                //           mergedMap.addAll(moreData);
                //           mergedMap.addAll(productIdMap);
                //           print(mergedMap);
                //           //listProducts.add(mergedMap);
                //           return mergedMap;
                //         }).toList())
                //     .map((e) => e.map((e) => Product.fromJson(e)).toList()),
                firebaseService.fetchLowStockById(supermarketId),
                builder: (context, snapshot) {
                  //final appState = Provider.of<AppState>(context);

                  var children = <Widget>[];
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      children = [
                        Container(
                            width: fullWidth(context),
                            height: fullHeight(context),
                            child: Center(child: CircularProgressIndicator()))
                      ];
                      break;
                    default:
                      if (snapshot.hasError)
                        children = [Text('Error: ${snapshot.error}')];
                      else {
                        snapshot.data.length == 0
                            ? children = null
                            : snapshot.data.forEach((element) {
                                children.add(
                                  ProductTile(
                                    availableStock: element.stockAvailable,
                                    imgUrl: element.imageUrl,
                                    price: element.price,
                                    productName: element.productName,
                                    productId: element.productId,
                                    //productCategory: widget.args.categoryName,
                                    supermarketId: supermarketId,
                                    productPrice: appState.productPriceUpdate,
                                    productStock: appState.productQtyUpdate,
                                    formkey: lowStockProductKey,
                                    isFeatured: element.isFeatured,
                                    sellPrice: element.sellPrice,
                                    sellingPrice: appState.sellingPriceUpdate,
                                    productStatus:
                                        element.productStatus ?? false,
                                    showDelete: false,
                                    bottomButtonText: "Edit",
                                    onUpdatePressed: () async {
                                      if (lowStockProductKey.currentState
                                          .validate()) {
                                        var response = await appState
                                            .updateStoreProducts(
                                                supermarketId: supermarketId,
                                                //productCategory: widget.args.categoryName,
                                                productId: element.productId)
                                            .catchError((onError) {
                                          print(
                                              "error on add product screen: $onError");
                                        });
                                        if (response) {
                                          print("done");
                                        } else {
                                          print("something went wrong");
                                        }
                                      }
                                    },
                                    onDeletePressed: () async {
                                      print("on delete mode!");
                                       var setState = element.productState == 'archived' ? 'active' : 'archived';
                                      var response = await appState
                                          .deleteProductsFromStore(
                                              supermarketId,
                                              // widget.args.categoryName,
                                              element.productId , setState)
                                          .catchError((onError) {
                                        print(
                                            "error on add product screen: $onError");
                                      });
                                      if (response) {
                                        print("Product Deleted");
                                      } else {
                                        print("Something Went Wrong");
                                      }
                                    },
                                    addToFeaturedList: () async {
                                      print("In Featured product List");
                                      bool tosetVal =
                                          element.isFeatured ? false : true;
                                      if (tosetVal) {
                                        if (appState.featuredProductCount ==
                                            5) {
                                                           ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Fetured Box Is Full!! please remove few items.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                                         
                                          print("limit crossed");
                                        } else {
                                          var response = await appState
                                              .addFeaturedProduct(
                                            //category: widget.args.categoryName,
                                            productId: element.productId,
                                            setValue: element.isFeatured
                                                ? false
                                                : true,
                                            superMarketID: supermarketId,
                                          )
                                              .catchError((onError) {
                                            print(
                                                "error on add product screen: $onError");
                                          });
                                          if (response) {
                                            print("Product featued set");
                                          } else {
                                            print("Something Went Wrong");
                                          }
                                        }
                                      } else {
                                        var response = await appState
                                            .addFeaturedProduct(
                                          //category: widget.args.categoryName,
                                          productId: element.productId,
                                          setValue:
                                              element.isFeatured ? false : true,
                                          superMarketID: supermarketId,
                                        )
                                            .catchError((onError) {
                                          print(
                                              "error on add product screen: $onError");
                                        });
                                        if (response) {
                                          print("Product featued set");
                                        } else {
                                          print("Something Went Wrong");
                                        }
                                      }
                                    },
                                  ),
                                );
                              });
                        //data
                      }
                  }
                  print(
                      "::::::::::::::::::::::::::::::::::::::::::::::::::::::");
                  return children == null ?  Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: fullWidth(context),
                    child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.done_outline,
                                        size: 80,
                                        color: greyColor,
                                      ),
                                      Text(
                                        "Stock Available",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                  ):
                  GridView.count(
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.58,
                      padding: EdgeInsets.only(bottom: 70),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: children);
                  //Column(children: children);
                },
              ),
            ),
          )),
    );
  }
}
