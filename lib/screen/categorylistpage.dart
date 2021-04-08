import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/models/argsList.dart';
import 'package:fisheries_vendorapp/models/supermarketDetail.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/screen/productlist.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatefulWidget {
  final SupermarketDetails supermarket;
  CategoryListPage({Key key , this.supermarket}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() { 
    super.initState();
    Provider.of<AppState>(context,listen: false).deliveryDetail(widget.supermarket.superMarketID);
    //appstate.deliveryDetail(args.superMarketID);
  }
  bool checkresp = false;
  @override
  Widget build(BuildContext context) {
    //final SupermarketDetails args = ModalRoute.of(context).settings.arguments;
    
    final appstate = Provider.of<AppState>(context);
   //// appstate.selectedSupermakretvalue = args.superMarketID;
    
    
    var deliveryboy = appstate.deliveryBoyDetails;
    //Provider.of<DeliveryBoyDetails>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          title: TitleTextBuilder(
            sendText:widget.supermarket.supermarketName ,
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(deliveryboy == null ? "" : deliveryboy.boyName),
              Text(deliveryboy == null ? "" : deliveryboy.onLeave ? "Leave" : ""),
              Image.network( deliveryboy == null ? "" : deliveryboy.boyImage,fit: BoxFit.scaleDown,height: 40,),
              IconButton(icon: Icon(Icons.refresh), onPressed: ()=> appstate.deliveryDetail(widget.supermarket.superMarketID))
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: appstate.categoriesList == null ? 0 : appstate.categoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  var categoryName = appstate.categoriesList[index]['display'];
                  return CategoryCard(
                    categoryName: categoryName,
                    supermarketId: widget.supermarket.superMarketID,
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    this.categoryName,
    this.supermarketId,
  });
  final String categoryName;
  final String supermarketId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white60),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.black38))),
                child:
                    Icon(Icons.settings_backup_restore, color: Colors.black38),
              ),
              title: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.black38, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.black38, size: 30.0)),
        ),
      ),
      onTap: () {
       ArgumentList argument = ArgumentList(
           categoryName: categoryName,
          supermarketId: supermarketId
       );
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList(
                            args: argument,
                          )));
      },
    );
  }
}


