class Product{
  String productName;
  String stockAvailable;
  String price;
  String imageUrl;
  String productId;
  String sellPrice;
  bool productStatus;
  bool isFeatured;
  String productweight;
  String productUnit;
  String productState;
  Product({this.productState,this.productweight,this.productUnit,this.productId,this.productName,this.stockAvailable,this.price,this.imageUrl, this.sellPrice, this.productStatus, this.isFeatured});
  Product.fromJson(Map<String, dynamic> json):
    productId = json['productId'],
    productName = json['productName'],
    stockAvailable = json['stockAvailable'].toString(),
    price = json['originalPrice'].toString(), 
    imageUrl = json['productImg'], 
    sellPrice = json['price'].toString(),
    productStatus = json['productStatus'],
    isFeatured = json['featureProduct'],
    productweight = json['productWeight'].toString(),
    productUnit = json['weightType'],
    productState = json['productState'];

}