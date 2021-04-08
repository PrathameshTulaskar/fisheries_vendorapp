import 'dart:async';

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fisheries_vendorapp/models/credentials.dart';
import 'package:fisheries_vendorapp/models/deliveryBoy.dart';
import 'package:fisheries_vendorapp/models/fishBusiness.dart';
import 'package:fisheries_vendorapp/models/customerReviews.dart';
import 'package:fisheries_vendorapp/models/megaHomepage.dart';
import 'package:fisheries_vendorapp/models/orderDetails.dart';
import 'package:fisheries_vendorapp/models/fishProduct.dart';
import 'package:fisheries_vendorapp/models/product.dart';
//import 'package:fisheries_vendorapp/models/product.dart';
import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/services/firestore_services.dart';
import 'package:fisheries_vendorapp/models/facebookAuth.dart';
import 'package:fisheries_vendorapp/models/googleAuth.dart';
import 'package:fisheries_vendorapp/models/phoneAuth.dart';
import 'package:location/location.dart' as locationPermission;

class AppState extends ChangeNotifier {
  // LatLng _supermarketPosition;
  // LatLng get supermarketPosition => _supermarketPosition;
  // set supermarketPositionValue(value) {
  //   _supermarketPosition = value;
  // }

  bool _productActive = false;
  bool get productActive => _productActive;
  set setProductActive(value) {
    _productActive = value;
    notifyListeners();
  }
  String  supermarketPosition;
  // String _businessType;
  // String get businessType => _businessType;
  //  set setBusinessType(value) {
  //   _businessType = value;
  // }
  // Credentials _tempAuthDetails;
  // Credentials get tempAuthDetails => _tempAuthDetails;
  // set settempAuthDetails(value) {
  //   _tempAuthDetails = value;
  // }
  FishBusiness _fishBusiness;
  FishBusiness get fishBusiness => _fishBusiness;
  List<CustomerReviews> _customerReviews = [];
  List<CustomerReviews> get customerReviews => _customerReviews;

  List<FishProduct> _ourFishProduct = [];
  List<FishProduct> get ourFishProduct => _ourFishProduct;
  DocumentSnapshot lastOrderDocument;
  String _setSupermarketID;
  String _vendorUid;
  String _vendorDataCheck;
  String get vendorDataCheck => _vendorDataCheck;
  String get vendorId => _vendorUid;
  String get setSupermarketID => _setSupermarketID;
  bool _editedCheck;
  bool get editedCheck => _editedCheck;
  int _featuredProductCount = 0;
  int get featuredProductCount => _featuredProductCount;
  bool _finalOrderCount = false;
  bool get finalOrderCount => _finalOrderCount;
  List<Order> _ordersLiveData = [];
  List<Order> get ordersLiveData => _ordersLiveData;
  List<SupermarketDetails> _supermarketdet = [];
  List<SupermarketDetails> get supermarketdet => _supermarketdet;

  List<Map<String, String>> _supermarketlist = [];
  List<Map<String, String>> get supermarketlist => _supermarketlist;

  List<Product> _featuredProducts = [];
  List<Product> get featuredProducts => _featuredProducts;
  DeliveryBoyDetails _deliveryBoyDetails;
  DeliveryBoyDetails get deliveryBoyDetails => _deliveryBoyDetails;
  VendorMegaData _vendorData;
  VendorMegaData get vendorData => _vendorData;
  var urls = [];
  List<String> newArg = [];
  List<Map<String, dynamic>> featuredProductList = [];
  FirestoreService firebaseService = FirestoreService();
  final TextEditingController productName = TextEditingController();
  TextEditingController productQty = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productUnits = TextEditingController();
  TextEditingController productWeight = TextEditingController();
  TextEditingController sellingPrice = TextEditingController();
  TextEditingController productCategory = TextEditingController();
  TextEditingController sellingPriceUpdate = TextEditingController();
  TextEditingController orderCancelNote = TextEditingController();
  List<Map<String, String>> _categoriesList = [];
  List<Map<String, String>> get categoriesList => _categoriesList;
  List<String> homepageSlideUrls = [];
  File _imageFileContents;
  File get imageFileContents => _imageFileContents;

  String _sellingAs = "Selling as Per-KG/Price";
  String get sellingAs => _sellingAs;
  set setsellingAs(value) {
    _sellingAs = value;
    notifyListeners();
  }

  String _totalProductCountCat, _selectedSupermarket;
  String get selectedSupermarket => _selectedSupermarket;
  set selectedSupermakretvalue(value) {
    _selectedSupermarket = value;
    notifyListeners();
  }

  setEditedValue(value) {
    _editedCheck = value;
    notifyListeners();
  }

  //FishBusiness
  TextEditingController businessNameController = TextEditingController();
  TextEditingController youtubeLinkController = TextEditingController();
  TextEditingController productTotalQuantityController =
      TextEditingController();
  TextEditingController fishWeight = TextEditingController();
  TextEditingController productPricePerKGController = TextEditingController();
  TextEditingController fishproductPiecesController = TextEditingController();

  List<Map<String, String>> _fisheriesList = [];
  List<Map<String, String>> get fisheriesList => _fisheriesList;
  // String _vendorId;
  //String _vendorName;

  String get totalProductCountCat => _totalProductCountCat;
  //Update Product Variables
  TextEditingController productQtyUpdate = TextEditingController();
  TextEditingController productPriceUpdate = TextEditingController();

  //Add Supermarket Variables
  TextEditingController supermarketNameField = TextEditingController();
  TextEditingController supermarketLocalityField = TextEditingController();
  TextEditingController supermarketPincode = TextEditingController();
  TextEditingController supermarketLandmark = TextEditingController();
  //USER REGISTER FORM
  TextEditingController userNameReg = TextEditingController();
  TextEditingController fullNameReg = TextEditingController();
  TextEditingController emailReg = TextEditingController();
  TextEditingController birthDateReg = TextEditingController();
  TextEditingController contactNumberReg = TextEditingController();
  String supermarketUrl = "";
  String url = "";
  String categoryName;
  String supermarketId;
  //Featured product
  TextEditingController setVariable = TextEditingController();
  //Order Variables
  List<Order> _orderDetailsList = [];
  List<Order> get orderDetailsList => _orderDetailsList;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AppState() {
    //_firebaseAuth.signOut();
    print("AppState Initialized");
    checkLogin();
    // fetchBusinessDetailsByVendorId();

    //fetchCustomerOrders();
  }

  ///
  ///uploadImageToServer Function identifier (prod/profile)
  ///
  uploadImageToServer(String base64String, String fileName, String identifier) {
    try {
      return firebaseService.getImageurl(base64String, fileName, identifier);
    } catch (e) {
      print("Error while uploading : $e");
      return "";
    }
  }

  Future<bool> startFishBusiness() async {
    try {
      await firebaseService.startBusiness(fishBusiness.businessId);
      return true;
    } catch (e) {
      print("error starting business: $e");
      return false;
    }
  }

  Future<List<Order>> fetchTodaysSale() async {
    return await firebaseService.fetchTodaysSale();
  }

  Future<void> resetFishBusinessProduct() async {
    print(fishBusiness.businessId);
    await firebaseService.resetFishBusinessProduct(fishBusiness.businessId);
    await fetchBusinessDetailsByVendorId(hardReload: true);
  }

  Future<bool> checkLogin() async {
    try {
      var authResponse = _firebaseAuth.currentUser;
      if (authResponse != null) {
        _vendorUid = authResponse.uid;
        //_vendorUid = 'fishVendor';
        fetchUserDetails(vendorId: _vendorUid).then((value) {
          if (value != null) {
            _vendorData = value;
            fetchCategories();
            value.businessType == "Fish"
                ? fetchBusinessDetailsByVendorId()
                : fetchSupermarketbyID(vendorId: _vendorUid);
            // firebaseService.fetchLowStockById("randomid1");
            fetchHomepageSlides();
            _vendorDataCheck = "true";
            notifyListeners();
          } else {
            _vendorDataCheck = "false";
            notifyListeners();
          }
        });
      } else {
        _vendorDataCheck = "false";
        notifyListeners();
      }
      return true;
    } catch (e) {
      print("Error while Login Check : $e");
      return false;
    }
  }

  //Set supermarket
  setSupermarketIdOnHome(value) {
    _setSupermarketID = value;
    notifyListeners();
  }

  //Add Super Market
  bool response;
  Future<bool> addSupermarket(String imgUrl) async {
    try {
      // return await firebaseService.addSupermarketService(
      //     _vendorUid,
      //     supermarketNameField.text,
      //     imgUrl,
      //     supermarketLocalityField.text,
      //     supermarketPincode.text,
      //     supermarketLandmark.text,
      //     GeoPoint(
      //         _supermarketPosition.latitude, _supermarketPosition.longitude));
    } catch (e) {
      print("error while adding supermarket:$e");
      return false;
    }
  }

  Future<void> fetchCurrentLocation() async {
    print("CURRENT LOCATION FETCH");
    try {
      // locationPermission.Location.instance.requestPermission();
      // var currentPos; 
      // // = await Geolocator().getCurrentPosition(
      // //   desiredAccuracy: LocationAccuracy.high,
      // // );
      // var coordinates = Coordinates(currentPos.latitude, currentPos.longitude);
      // var addressName =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // // var featureName = addressName.first.featureName;
      // // var addressLine = addressName.first.addressLine;
      // // var googleAddress = await Geocoder.google(goolePlaceApiKey,language: ).findAddressesFromCoordinates(coordinates);
      // // print("address from google : ${googleAddress.first.featureName} : ${googleAddress.first.addressLine}");
      // _supermarketPosition = LatLng(currentPos.latitude, currentPos.longitude);
      // print("LAt: ${currentPos.latitude} \n Long: ${currentPos.longitude}");
      // notifyListeners();
    } catch (e) {
      print(
          "current location function ERROR??????????????????????????????: $e");
      // _supermarketPosition = LatLng(0, 0);
      notifyListeners();
    }
    // print("current position LATLNG: $_supermarketPosition");
  }

  Future<bool> userDataStore(
      {int checkAuth,
      String userIdReg,
      String profileUrl,
      GoogleAuthModel googleSignIn,
      FacebookAuthModel facebookSignIn,
      DateTime birthDate,
      String contactNumber,
      PhoneAuthModel otpData,
      String vendorType}) async {
    var authResponse = _firebaseAuth.currentUser;
    //CHECKAuth
    // 1 => Phone
    // 2 => Google
    // DEFAULT => Facebook
    print("COntact Number : ${contactNumberReg.text}");
    print("COntact Number : ${contactNumber ?? ""}");
    print("USER ID : ${userIdReg ?? ""}");
    print("USER ID : ${authResponse.uid}");
    print("BirthDate : ${birthDate ?? ""}");
    try {
      switch (checkAuth) {
        case 1:
          {
            var response = await firebaseService.userDetailStore(
                authResponse.uid,
                userNameReg.text,
                fullNameReg.text,
                emailReg.text,
                contactNumber,
                profileUrl,
                DateTime.parse(birthDateReg.text),
                vendorType);
            if (response) {
              checkLogin();
              return true;
            } else {
              return false;
            }
          }
          break;
        case 2:
          {
            {
              var response = await firebaseService.userDetailStore(
                  userIdReg,
                  googleSignIn.userName,
                  googleSignIn.fullName,
                  googleSignIn.emailAddress,
                  contactNumberReg.text,
                  profileUrl,
                  DateTime.parse(birthDateReg.text),
                  vendorType);
              if (response) {
                checkLogin();
                return true;
              } else {
                return false;
              }
            }
          }
          break;
        default:
          {
            var response = await firebaseService.userDetailStore(
                userIdReg,
                facebookSignIn.userName,
                facebookSignIn.fullName,
                facebookSignIn.emailAddress,
                contactNumberReg.text,
                profileUrl,
                facebookSignIn.birthDate ?? DateTime.parse(birthDateReg.text),
                vendorType);
            if (response) {
              checkLogin();
              return true;
            } else {
              return false;
            }
          }
          //return await firebaseService.userDetailStore(userIdReg, facebookSignIn.userName, facebookSignIn.fullName, facebookSignIn.emailAddress, contactNumberReg.text, facebookSignIn.profileUrl, facebookSignIn.birthDate);
          break;
      }
    } catch (e) {
      print("Error occured while user data store : $e");
      return false;
    }
  }
//   Future<String> uploadToStore(File imgFile)async{
//     try{
//           final FirebaseStorage _storage =
//         FirebaseStorage(storageBucket: 'gs://grocery-1ee65.appspot.com');

//     StorageUploadTask _uploadTask;
//     String url;
//     /// Starts an upload task
//     print("upload function");
//     DateTime now = new DateTime.now();

//     String filePath = 'users/profile$now.png';
//     _uploadTask = _storage.ref().child(filePath).putFile(imgFile);
//     var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();

//     url = dowurl.toString();
//     print(url);
//     if (url.isNotEmpty) {
//       return url;
//     }else{
//  return null;
//     }

//     }catch(error){
//       print("error uploading image : $error");
//       return null;
//     }

//   }
  //Update SuperMarket Visiblity
  Future<bool> setSupermarketVisiblity(
      String superMarketId, bool visiblity) async {
    response = await firebaseService.updateSupermarketVisiblityService(
        superMarketId, visiblity);
    return response;
  }

  //Add Product
  Future<bool> addProduct(
      {String productNameValue,
      String productPriceValue,
      String productQuantity,
      String productCategoryValue,
      String imgUrl,
      String supermarketId,
      String productWt,
      String productUnit,
      String sellPrice,
      bool prodStatus}) async {
    if (url.isNotEmpty || imgUrl.isNotEmpty) {
      print("in appsatate");

      var response = await firebaseService.addProductService(
          productNameValue ?? productName.text,
          productQuantity ?? productQty.text,
          productPriceValue ?? productPrice.text,
          productCategoryValue ?? productCategory.text,
          supermarketId,
          productWt ?? productWeight.text,
          productUnit ?? productUnits.text,
          imgUrl ?? url,
          sellPrice ?? sellingPrice.text,
          prodStatus);

      return response;
    }
    return false;
  }

  // Fetch all categories
  void fetchCategories() async {
    var response = await firebaseService.fetchCategoriesService();
    //List<Map<String,String>> finalOutput = [];
    Map<String, String> mapping = {};
    response.forEach((element) {
      mapping = {
        'display': element,
        'value': element,
      };
      var mappingCat = {
        'categoryName': element,
      };

      featuredProductList.add(mappingCat);
      _categoriesList.add(mapping);
      notifyListeners();
    });
  }

  // fetch homepage slider urls
  void fetchHomepageSlides() async {
    homepageSlideUrls = await firebaseService.fetchHomepageSlider();
    notifyListeners();
  }

  // Upload File to firebase and fetch image URL
  // Future<bool> uploadImage(File imageFile) async {
  //   final FirebaseStorage _storage =
  //       FirebaseStorage(storageBucket: 'gs://grocery-1ee65.appspot.com');

  //   StorageUploadTask _uploadTask;

  //   /// Starts an upload taskr
  //   print("upload function");
  //   DateTime now = new DateTime.now();

  //   String filePath = 'productPictures/productImg$now.png';
  //   _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
  //   var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  //   url = dowurl.toString();
  //   print(url);
  //   if (url.isNotEmpty) {
  //     return true;
  //   }
  //   return false;
  // }

  // Upload File to firebase and fetch image URL
  // Future<String> uploadImageSupermarket(File imageFile) async {
  //   final FirebaseStorage _storage =
  //       FirebaseStorage(storageBucket: 'gs://grocery-1ee65.appspot.com');

  //   StorageUploadTask _uploadTask;

  //   /// Starts an upload task
  //   print("upload function");

  //   /// Unique file name for the file
  //   //Random random = new Random();
  //   //int randomNumber = random.nextInt(50);
  //   DateTime now = new DateTime.now();
  //   String filePath = 'supermarketPics/supermarketImg$now.png';
  //   //String filePath = 'ourProducts/productImg$randomNumber.png';
  //   _uploadTask = _storage.ref().child(filePath).putFile(imageFile);
  //   var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();

  //   supermarketUrl = dowurl.toString();
  //   print(supermarketUrl);
  //   if (supermarketUrl.isNotEmpty) {
  //     notifyListeners();
  //     return supermarketUrl;
  //   }
  //   return "";
  // }

  assignImageUrl(File img) {
    print("appstate in assign: $img");
    _imageFileContents = img;
    notifyListeners();
  }

  //Fetch Supermarkets By ID
  void fetchSupermarketbyID({String vendorId}) async {
    try {
      _supermarketdet = await firebaseService
          .fetchSupermarketByVendor(vendorId ?? _vendorUid);
      Map<String, String> p;
      _supermarketlist = [];
      _supermarketdet.forEach((element) {
        p = {
          'display': element.supermarketName,
          'value': element.superMarketID
        };
        _supermarketlist.add(p);
        _supermarketlist.toSet().toList();
      });
      //print(_supermarketlist);
      notifyListeners();
    } catch (error) {
      print("in supermarket fetch app state: $error");
    }
  }

  //Fetch products by category
  Future<List<Product>> fetchProductsbyCategory(
      String supermarketId, String categoryName) async {
    List<Product> response = await firebaseService.fetchProductByCategory(
        supermarketId, categoryName);
    _totalProductCountCat = response.length.toString();
    // notifyListeners();
    return response;
  }

  //Update Prodcuts
  Future<bool> updateStoreProducts(
      {String supermarketId, String productId, String sellingPrice}) async {
    return await firebaseService.updateProducts(
        supermarketId,
        productPriceUpdate.text,
        productQtyUpdate.text,
        sellingPriceUpdate.text,
        productId);
  }

  // Low Stock Products
  Stream<List<Product>> lowStockProducts(String supermarketId) {
    print("low stock stream called from appstate");
    return firebaseService.fetchLowStockById(supermarketId);
  }

  //Delete Products
  Future<bool> deleteProductsFromStore(
      String supermarketId, String productId, String state) async {
    return await firebaseService.deleteProduct(supermarketId, productId, state);
  }

  //Fetch Our Products
  Future<List<Product>> fetchOurproductsFunction(String productCategory) async {
    return await firebaseService.ourProductsServices(productCategory);
  }

// Add to featured Product List
  Future<bool> addFeaturedProduct(
      {String productId,
      bool setValue,
      //String category,
      String superMarketID}) async {
    return await firebaseService.addFeaturedProduct(
        productId, setValue, superMarketID);
  }

  // Update Delivery Status
  Future<bool> updateDeliveryStatus(
      {String accountId,
      String orderId,
      String status,
      String deliveryBoyId,
      String deliveryBoyName}) async {
    var currentDate = DateTime.now();

    try {
      response = await firebaseService.updateOrderStatusToDelivery(
          Timestamp.fromDate(currentDate),
          accountId,
          _vendorUid,
          orderId,
          status,
          deliveryBoyId,
          deliveryBoyName);
      return true;
    } catch (error) {
      print("in update status appState: $error");
      return false;
    }
  }

  //Delivery Boy Details
  void deliveryDetail(String supermarketId) {
    firebaseService.fetchDeliveryBoy(supermarketId).listen((event) {
      String boyId = event.id;
      print("from stream appstate Delivery BOy: $boyId");
      Map<String, dynamic> moreData = event.data();
      Map<String, dynamic> productIdMap = {'documentId': boyId};
      Map<String, dynamic> mergedMap = {};
      mergedMap.addAll(moreData);
      mergedMap.addAll(productIdMap);
      _deliveryBoyDetails = DeliveryBoyDetails.fromJson(mergedMap);
      notifyListeners();
    });
  }

// Fetch Vendor Details
  Future<VendorMegaData> fetchUserDetails({String vendorId}) async {
    var userId = _firebaseAuth.currentUser;
    print("user details fetch with vendor id : ${vendorId ?? _vendorUid}");
    print("in appSatate");
    return await firebaseService.fetchVendorDetails(vendorId ?? userId.uid);
    // if(response != null){
    //   _vendorData = response;
    //   notifyListeners();
    //   return true;
    // }else{
    //   return false;
    // }
  }

  Future<void> fetchVendorDetails({String vendorId}) async {
    var userId = _firebaseAuth.currentUser;
    print("user details fetch with vendor id : ${vendorId ?? _vendorUid}");
    print("in appSatate");
    _vendorData =
        await firebaseService.fetchVendorDetails(vendorId ?? userId.uid);
  }

//Featured Product List
  void fetchFeaturedProducts(String supermarketId, String category) {
    try {
      firebaseService
          .fetchFeaturedProducts(category, supermarketId)
          .listen((event) {
        _featuredProducts = event;
        _featuredProductCount = event.length;
        print(_featuredProducts);
        print(_featuredProductCount);
        notifyListeners();
      });
    } catch (error) {
      print("cannot fetch featured products: $error");
    }
  }

  //Cancel Order::
  Future<void> cancelOrder(String documentId) async {
    print("cancel order from appstate");
    await firebaseService.cancelOrderService(documentId, orderCancelNote.text);
  }

  //Fetch Orders for order history: for each supermarket
  Future<void> fetchCustomerOrders(
      {bool moreFetchBt, String supermarketID}) async {
    _orderDetailsList.clear();
    try {
      print("In appState market ID: $supermarketID");
      print("in appstate file to fetch orders:");
      var response = await firebaseService.fetchOrders(
          supermarketID, lastOrderDocument, moreFetchBt);
      //lastOrderDocument,
      // print(response.documents.length);
      print("documents count: ${response.docs.length}");
      print("documents count: ${response.docs.first.id}");
      if (response.docs.length > 0) {
        lastOrderDocument = response.docs.last;
        var orderList =
            response.docs.map((e) => Order.fromJson(e.data())).toList();
        _orderDetailsList.addAll(orderList);
      } else {
        _finalOrderCount = true;
      }
      //lastOrderDocument = response.documents[response.documents.length - 1];
      // print("$lastOrderDocument  :Last Order Document Found");
      print("got response");

      notifyListeners();
    } catch (e) {
      print("error from appstate fetch customer orders : $e");
    }
  }

  Future<bool> addFishBusiness() async {
    try {
      //print("${_vendorData.vendorId} || ${_vendorData.vendorName} ");

      // _fishBusiness = await firebaseService.addFishBusiness(
      //     _vendorUid,
      //     //_vendorData.vendorName ?? '',
      //     _vendorData.vendorName,
      //     // _vendorId,
      //     // _vendorName,
      //     businessNameController.text,
      //     supermarketLocalityField.text,
      //     supermarketPincode.text,
      //     supermarketLandmark.text,
      //     GeoPoint(
      //         _supermarketPosition.latitude, _supermarketPosition.longitude)
      //         );
      // print(
      //     "businessName: ${businessNameController.text} + pincode: ${supermarketPincode.text} + landmark: ${supermarketLandmark.text}");

      // notifyListeners();
      // if (_fishBusiness == null) {
      //   return false;
      // } else {
      //   return true;
      // }
    } catch (e) {
      print("error in AppState");
      print("error while adding FishBusiness:$addFishBusiness");
      return false;
    }
  }

  Future<bool> updatevideoLink() async {
    // print(businessId);
    print('$_vendorUid');
    print(
      youtubeLinkController.text,
    );
    print("inAppstate");

    return await firebaseService.updatevideoLink(
        youtubeLinkController.text, fishBusiness.businessId);
  }

  Future<void> updateproductDetails(
      {FishProduct details, bool todayOrder, bool isFullFish,String productId}) async {
    print(
        "Product Id: ${details.productId}\n stock available: ${details.stockAvailable.toString()}\nproduct price: ${details.price.toString()} \n BusinessID: ${fishBusiness.businessId}");
    try {
      if (todayOrder) {
        var fishProductDetails = FishProduct(
          originalPrice: int.tryParse(productPricePerKGController.text) ?? 0,
          price: int.tryParse(productPricePerKGController.text) ?? 0,
          productId: details.productId,
          stockAvailable:
              int.tryParse(productTotalQuantityController.text) ?? 0,
        );
        return await firebaseService.addProductDetails(
            fishProductDetails, _fishBusiness.businessId, todayOrder);
      } else {
        print("select product appstate else condition");
        var fishProductDetails = FishProduct(
          originalPrice: int.tryParse(productPricePerKGController.text) ?? 0,
          price: int.tryParse(productPricePerKGController.text) ?? 0,
          productCategory: details.productCategory,
          productId: details.productId,
          productImg: details.productImg,
          productName: details.productName,
          productPieces: _sellingAs == "Selling as fish/Price"
              ? 0
              : fishproductPiecesController.text == null
                  ? 1
                  : int.tryParse(fishproductPiecesController.text) ?? 0,
          productStatus: true,
          productWeight: _sellingAs == "Selling as Per-KG/Price"
              ? 1
              : fishWeight.text == null
                  ? 1
                  : int.tryParse(fishWeight.text),
          stockAvailable:
              int.tryParse(productTotalQuantityController.text) ?? 0,
        );

        return await firebaseService.addProductDetails(
            fishProductDetails, _fishBusiness.businessId, todayOrder);
      }
    } catch (e) {
      print("UPDATE PRODUCT ERROR FROM APPSTATE: $e ");
      print("businessId:${_fishBusiness.businessId}");
      return false;
    }
  }

  // Future<void> addProductDetails(FishProduct details,) async {
  //   try {
  //     //print("${_vendorData.vendorId} || ${_vendorData.vendorName} ");
  //     var fishProductDetails = FishProduct(
  //       originalPrice: int.parse(productPricePerKGController.text),
  //       price: int.parse(productPricePerKGController.text),
  //       productCategory: details.productCategory,
  //       productId: details.productId,
  //       productImg: details.productImg,
  //       productName: details.productName,
  //       productPieces: int.parse(fishproductPiecesController.text),
  //       productStatus: true,
  //       productWeight: 1,
  //       stockAvailable: int.parse(productTotalQuantityController.text),
  //     );
  //     return await firebaseService.addProductDetails(
  //         fishProductDetails, fishBusiness.businessId);
  //   } catch (e) {
  //     print("error while adding supermarket:$addProductDetails");
  //     return null;
  //   }
  // }

  Future<List<FishProduct>> getOurFishProduct() async {
    print("fishproduct list count:  ${_ourFishProduct.length}");

    return await firebaseService.getOurFishProductList();

// await firebaseService.getOurFishProductList("s6AjGpKZbKg9IkFqvqQC");
  }

  Future<void> fetchBusinessDetailsByVendorId({bool hardReload = false}) async {
    // var res = hardReload == null ? false : hardReload;
    print("fetch business testing");
    if (fishBusiness == null || hardReload) {
      print("business detail fetching...");
      _fishBusiness =
          await firebaseService.fetchBusinessDetailsByVendorId(_vendorUid);
      deliveryDetail(_fishBusiness.businessId);
    }
    print("Business Details Exists");
  }

  Future<List<FishProduct>> getVendorFishProducts() async {
    return await firebaseService
        .getVendorFishProducts('fisherRandomBusinessId');
  }

  // Future<void> updateVendorFishProduct(String productId) async {
  //   print(
  //     productTotalQuantityController,
  //   );
  //   print(fishproductPiecesController);
  //   try {
  //     var fishProductDetails = FishProduct(
  //       stockAvailable: int.parse(productTotalQuantityController.text),
  //       price: int.parse(productPricePerKGController.text),
  //     );

  //     return await firebaseService.updateVendorFishProduct(
  //         fishProductDetails, productId);
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> updateVendorPoductStatus(
      bool productStatus, FishProduct fishDetail) async {
    try {
      return await firebaseService.updateVendorProductStatus(
          fishDetail, fishBusiness.businessId, productStatus);
    } catch (e) {
      return false;
    }
  }

  Future<List<CustomerReviews>> getCustomerReviewsList() async {
    print("review List");

    return await firebaseService.getCustomerReviewsList();

// await firebaseService.getOurFishProductList("s6AjGpKZbKg9IkFqvqQC");
  }
}
