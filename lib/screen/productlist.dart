import 'package:carousel_slider/carousel_slider.dart';
import "package:flutter/material.dart";
// import 'package:getflutter/components/carousel/gf_carousel.dart';
import 'package:fisheries_vendorapp/models/argsList.dart';
import 'package:fisheries_vendorapp/models/product.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/screen/addproduct.dart';
import 'package:fisheries_vendorapp/widgets/customWidgets.dart';
import 'package:fisheries_vendorapp/widgets/productTile.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  final ArgumentList args;
  ProductList({Key key, this.args}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  //int _currentStep = 0;

  @override
  void initState() {
    Provider.of<AppState>(context, listen: false).fetchFeaturedProducts(
        widget.args.supermarketId, widget.args.categoryName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final ArgumentList args = ModalRoute.of(context).settings.arguments;
    final appState = Provider.of<AppState>(context);
    final formKey = new GlobalKey<FormState>();
    bool archived = false;
    return Scaffold(
        appBar: AppBar(
          title: TitleTextBuilder(
            sendText: widget.args.categoryName,
          ), //Text(args.categoryName),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Addproduct(
                          finalSupermarketID: widget.args.supermarketId,
                        )));
          },
          label: Text("PRODUCT"),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border:
                          new Border.all(width: 5.0, style: BorderStyle.none),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black26,
                          offset: new Offset(20.0, 10.0),
                          blurRadius: 20.0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total Products",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(height: 10),
                            Text(
                              appState.totalProductCountCat ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 15),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  sectionTitle(
                      "${widget.args.categoryName}", "", () {}, context),
                  SizedBox(
                    height: 8.0,
                  ),
                  appState.featuredProductCount == 0
                      ? Text("Feature products not available.")
                      : CarouselSlider(
                          
                          items: appState.featuredProducts.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return ProductTileSlide(
                                    productName: i.productName ?? "",
                                    imgURL: i.imageUrl,
                                    mrp: i.sellPrice,
                                    price: i.price,
                                    stock: i.stockAvailable,
                                  );
                                },
                              );
                            },
                          ).toList(),
                          options:CarouselOptions(
                          height:267,
                          aspectRatio:16/9,
                          viewportFraction:0.8,
                          initialPage:0,
                          enableInfiniteScroll:true,
                          reverse:false,
                          autoPlay:true,
                          autoPlayInterval:Duration(seconds:3),
                          autoPlayAnimationDuration:Duration(milliseconds:800),
                          autoPlayCurve:Curves.fastOutSlowIn,
                          enlargeCenterPage:true,
                          scrollDirection:Axis.horizontal,

                        ),
                          // onPageChanged: (index) {},
                        ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: <Widget>[
                      sectionTitle("Product List", " ", () {}, context)
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FutureBuilder<List<Product>>(
                      future: appState.fetchProductsbyCategory(
                          widget.args.supermarketId, widget.args.categoryName),
                      builder:
                          (context, AsyncSnapshot<List<Product>> snapshot) {
                        var children = <Widget>[];
                        if (snapshot.hasData) {
                          if (snapshot.data.length != 0) {
                            print("products available");
                            snapshot.data.forEach((element) {
                              children.add(
                                ProductTile(
                                  availableStock: element.stockAvailable,
                                  imgUrl: element.imageUrl,
                                  price: element.price,
                                  productName: element.productName,
                                  productId: element.productId,
                                  productCategory: widget.args.categoryName,
                                  supermarketId: widget.args.supermarketId,
                                  productPrice: appState.productPriceUpdate,
                                  productStock: appState.productQtyUpdate,
                                  formkey: formKey,
                                  isFeatured: element.isFeatured,
                                  sellPrice: element.sellPrice,
                                  sellingPrice: appState.sellingPriceUpdate,
                                  productStatus: element.productStatus ?? false,
                                  showDelete: false,
                                  bottomButtonText:
                                      element.productState == 'archived' ||
                                              archived
                                          ? "Hidden"
                                          : "Edit",
                                  // editedCheckFromAppState: false,
                                  onUpdatePressed: () async {
                                    if (formKey.currentState.validate()) {
                                      var response = await appState
                                          .updateStoreProducts(
                                              supermarketId:
                                                  widget.args.supermarketId,
                                              //productCategory: widget.args.categoryName,
                                              productId: element.productId)
                                          .catchError((onError) {
                                        print(
                                            "error on edit product screen: $onError");
                                      });
                                      if (response) {
                                        print("done");
                                        appState.setEditedValue(true);
                                        Navigator.pop(context);
                                      } else {
                                        print("something went wrong");
                                      }
                                    }
                                  },
                                  onDeletePressed: () async {
                                    print("on delete mode!");
                                    var setStateVar =
                                        element.productState == 'archived' ||
                                                archived
                                            ? 'active'
                                            : 'archived';
                                    var response = await appState
                                        .deleteProductsFromStore(
                                            widget.args.supermarketId,
                                            //widget.args.categoryName,
                                            element.productId,
                                            setStateVar)
                                        .catchError((onError) {
                                      print(
                                          "error on add product screen: $onError");
                                    });
                                    if (response) {
                                      setState(() {
                                        archived = true;
                                      });
                                      Navigator.pop(context);
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
                                      print(
                                          "featured count : ${appState.featuredProductCount}");
                                      if (appState.featuredProductCount == 5) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context))
                                                ],
                                              ),
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: DialogTextBuilder(
                                                    sendText:
                                                        "We allow only 5 Featured Products. Please remove few featured products to add new.",
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                        print("limit crossed");
                                      } else {
                                        var response = await appState
                                            .addFeaturedProduct(
                                          // category: widget.args.categoryName,
                                          productId: element.productId,
                                          setValue:
                                              element.isFeatured ? false : true,
                                          superMarketID:
                                              widget.args.supermarketId,
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
                                        // category: widget.args.categoryName,
                                        productId: element.productId,
                                        setValue:
                                            element.isFeatured ? false : true,
                                        superMarketID:
                                            widget.args.supermarketId,
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
                          } else {
                            children.add(Center(child: Text("No products")));
                          }
                        } else {
                          children.add(Center(
                            child: CircularProgressIndicator(),
                          ));
                        }
                        return GridView.count(
                            mainAxisSpacing: 15.0,
                            childAspectRatio: 0.58,
                            padding: EdgeInsets.only(bottom: 70),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: children);
                      })
                ],
              ),
            ),
          ),
        ));
  }
}

class ProductTileSlide extends StatelessWidget {
//64
  final String productName;
  final String imgURL;
  final String stock;
  final String mrp;
  final String price;
  const ProductTileSlide(
      {Key key,
      this.productName,
      this.imgURL,
      this.price,
      this.mrp,
      this.stock})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String productNameFinal;
    if (productName.length >= 55) {
      productNameFinal = productName.substring(0, 56) + "...";
    } else {
      productNameFinal = productName;
    }

    return Container(
      //height: 330,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.grey[100]),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          Image.network(
            imgURL,
            fit: BoxFit.fill,
            height: 138,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //crossAxisAlignment: CrossAxisAlignment.baseline,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 35,
                    child: Text("$productNameFinal",
                        //twinkle bag
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Qty: $stock",
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text("\u20b9 $price",
                            style:
                                Theme.of(context).textTheme.overline.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    )),
                        Text("\u20b9 $mrp",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  child: Container(
                    child: Center(
                        child: Text(
                      "Featured",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                    color: Colors.red,
                    width: fullWidth(context),
                    height: 25,
                  ),
                ),
                onTap: null,
                //focusColor: Colors.red,
              )
            ],
          )
        ],
      ),
    );
  }
}
