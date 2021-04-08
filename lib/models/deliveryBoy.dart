class DeliveryBoyDetails {
  String boyId;
  String boyName;
  String boyImage;
  bool onLeave;
  bool isAssigned;

  DeliveryBoyDetails({
    this.boyId,
    this.boyImage,
    this.boyName,
    this.isAssigned,
    this.onLeave
  });
   DeliveryBoyDetails.fromJson(Map<String, dynamic> json):
    boyId = json['documentId'],
    boyName = json['name'],
    boyImage = json['imgUrl'],
    onLeave = json['onLeave'], 
    isAssigned = json['isAssigned']; 
}