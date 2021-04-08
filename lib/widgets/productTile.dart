import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';

import 'colors.dart';
import 'customWidgets.dart';

class ProductTile extends StatelessWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final String imgUrl;
  final String productName;
  final String availableStock;
  final String price;
  final String productId;
  final String supermarketId;
  final String productCategory;
  final TextEditingController productPrice;
  final TextEditingController productStock;
  final TextEditingController sellingPrice;
  final String sellPrice;
  final bool isFeatured;
  final bool productStatus;
  final bool editedCheckFromAppState;
  final Function onUpdatePressed;
  final Function onDeletePressed;
  final Function addToFeaturedList;
  final GlobalKey<FormState> formkey;
  final bool showDelete;
  final String bottomButtonText;
  const ProductTile(
      {this.editedCheckFromAppState,
      this.bottomButtonText,
      this.productName,
      this.imgUrl,
      this.availableStock,
      this.price,
      this.productId,
      this.supermarketId,
      this.productCategory,
      this.productPrice,
      this.productStock,
      this.onUpdatePressed,
      this.onDeletePressed,
      this.addToFeaturedList,
      this.formkey,
      this.sellPrice,
      this.isFeatured,
      this.productStatus,
      this.sellingPrice,
      this.showDelete
      //this.setVarable
      });

  @override
  Widget build(BuildContext context) {
    String productNameFinal;
    if (productName.length >= 40) {
      productNameFinal = productName.substring(0, 40) + "...";
    } else {
      productNameFinal = productName;
    }

    return Container(
      //height: 330,
      //width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.grey[100]),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
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
                onTap: addToFeaturedList,
              ),
              Subscribed(
                subscribed: productStatus,
                reason: "Verified",
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Image.network(
              imgUrl ?? "",
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // SizedBox(
              //   height: 12,
              // ),
              Align(
                alignment: Alignment.center,
                //productName ?? ""
                child: Container(
                  height: 47,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(productNameFinal,
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold, color: blackColor)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  availableStock != null
                      ? "Stock: ${availableStock ?? ""}"
                      : "",
                  style: Theme.of(context)
                      .textTheme
                      .overline
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(price != null ? "MRP: \u20b9 ${price ?? ""}" : "",
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                    price != null
                        ? "Selling Price: \u20b9 ${sellPrice ?? ""}"
                        : "",
                    style: Theme.of(context)
                        .textTheme
                        .overline
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 8,
              ),
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  child: Container(
                    child: Center(
                        child: Text(
                      "$bottomButtonText",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.bold, color: whiteColor),
                    )),
                    color: bottomButtonText == 'Hidden'
                        ? Colors.grey[300]
                        : addToCartBtn,
                    width: fullWidth(context),
                    height: 32,
                  ),
                ),
                onTap: () {
                  if (availableStock == null) {
                    productStock.text = "00";
                  } else {
                    productStock.text = availableStock;
                  }
                  productPrice.text = price;

                  var t = availableStock == null ? "" : availableStock;
                  var z = sellPrice == null ? "" : sellPrice;
                  sellingPrice.text = sellPrice;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditDialogue(
                        availableStock: t,
                        formkey1: formkey,
                        onDeletePressed: onDeletePressed,
                        onUpdatePressed: onUpdatePressed,
                        price: price,
                        productName1: productName,
                        productStock: productStock,
                        productPrice: productPrice,
                        sellPrice1: z,
                        sellingPriceUpdate: sellingPrice,
                        delete: showDelete,
                        deleteText:
                            bottomButtonText == 'Hidden' ? "Show" : "Hide",
                      );
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class EditDialogue extends StatefulWidget {
  final String productName1;
  final GlobalKey<FormState> formkey1;
  final TextEditingController productPrice;
  final TextEditingController productStock;
  final TextEditingController sellingPriceUpdate;
  final String sellPrice1;
  final String availableStock;
  final String price;
  final Function onUpdatePressed;
  final Function onDeletePressed;
  final bool delete;
  final bool editedCheckFromState;
  final String deleteText;
  EditDialogue(
      {Key key,
      this.deleteText,
      this.editedCheckFromState,
      this.delete,
      this.sellingPriceUpdate,
      this.sellPrice1,
      this.availableStock,
      this.formkey1,
      this.onDeletePressed,
      this.onUpdatePressed,
      this.price,
      this.productName1,
      this.productPrice,
      this.productStock})
      : super(key: key);

  @override
  _EditDialogueState createState() => _EditDialogueState();
}

class _EditDialogueState extends State<EditDialogue> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      elevation: 20.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "${widget.productName1}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          IconButton(
              icon: Icon(Icons.close), onPressed: () => Navigator.pop(context))
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
          child: Form(
              key: widget.formkey1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: widget.productStock,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "enter value";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Available Stock",
                            hintText:
                                "${widget.availableStock} : Current Stock"),
                      ),

                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: widget.productPrice,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "enter value";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "${widget.price}",
                          labelText: "MRP",
                        ),
                      ),

                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: widget.sellingPriceUpdate,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "enter value";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "${widget.sellPrice1}",
                          labelText: "Selling Price",
                        ),
                      ),
                      SizedBox(height: 20),
                      // Row(
                      //   children: <Widget>[
                      //     Center(
                      //       child: Text(widget.editedCheckFromState ? "Product is Now updated" : ""),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height:20),
                      FlatButton(
                          //disabledColor: isUploaded ? Colors.deepPurple : Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.deepPurple),
                          ),
                          color: Colors.white,
                          textColor: Colors.deepPurple,
                          onPressed: widget.onUpdatePressed,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Update"),
                              ],
                            ),
                          )),
                      widget.delete
                          ? FlatButton(onPressed: null, child: null)
                          : FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red),
                              ),
                              color: Colors.red,
                              textColor: Colors.white,
                              onPressed: widget.onDeletePressed,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("${widget.deleteText}"),
                                  ],
                                ),
                              )),
                      // SizedBox(height: 10),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
