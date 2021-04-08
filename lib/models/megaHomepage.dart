class VendorMegaData {
  String vendorId;
  String vendorName;
  int totalOrders;
  int totalSales;
  int totalDeliveries;
  String businessType;
  VendorMegaData(this.vendorName, this.totalDeliveries, this.totalOrders,
      this.totalSales, this.vendorId,this.businessType);
  VendorMegaData.fromJson(Map<String, dynamic> json)
      : vendorName = json['userName'],
        totalOrders = json['totalOrders'],
        totalSales = json['totalSales'],
        businessType = json['businessType'] ?? null,
        totalDeliveries = json['totalDeliveries'];
}
