class AddProductDetails {
  String totalQuantity;
  

 String pricePerKG;
 

  AddProductDetails({
    this.totalQuantity,
  this.pricePerKG,
  
  });
  AddProductDetails.fromJson(Map<String, dynamic> json):
   this.totalQuantity =json['totalQuantity'],
   this.pricePerKG =json['pricePerKG'];
  
}