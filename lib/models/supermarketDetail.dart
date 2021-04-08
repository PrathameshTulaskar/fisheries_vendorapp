
class SupermarketDetails {
  String supermarketName;
  String superMarketID; 
  String superMarketImage;
  bool visiblity;
  bool subscription;
  String reason;
  String accountId;
  SupermarketDetails({this.accountId,this.reason,this.superMarketID,this.supermarketName,this.superMarketImage, this.visiblity, this.subscription});
  SupermarketDetails.fromJson(Map<String,dynamic> json) :
  supermarketName = json['supermarket'], 
  superMarketID = json['supermarketId'],
  superMarketImage = json['supermarketImage'],
  visiblity = json['visiblity'],
  subscription = json['subscription'],
  accountId = json['vendorAccId'],
  reason = json['reason'];
}