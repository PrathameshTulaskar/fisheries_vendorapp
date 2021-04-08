import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CategoryListPageOurProduct extends StatefulWidget {
  CategoryListPageOurProduct({Key key}) : super(key: key);

  @override
  _CategoryListPageOurProductState createState() =>
      _CategoryListPageOurProductState();
}

class _CategoryListPageOurProductState
    extends State<CategoryListPageOurProduct> {
  @override
  Widget build(BuildContext context) {
    // ArgsForProd dummy = ArgsForProd(
    //   categoryName: "",
    // );
    final ArgsForProd args =
        ModalRoute.of(context).settings.arguments ?? ArgsForProd();
    final appstate = Provider.of<AppState>(context);
    appstate.newArg.add(args.categoryName ?? "");

    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          title: TitleTextBuilder(
            sendText: "Select Category To Add Product",
          ),
         
        ),
        body: Container(
          child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: appstate.categoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  var categoryName = appstate.categoriesList[index]['display'];
                  ArgsForProd argumentList = ArgsForProd(
                    categoryName: categoryName,
                    supermarketId: appstate.setSupermarketID,
                  );
                  return CategoryCard(
                    categoryName: categoryName,
                    args: appstate.newArg,
                    argument: argumentList,
                  );
                },
              ),
            ),
           
          ],
        )));
  }
}

class CategoryCard extends StatelessWidget {
  final List<String> args;
  final String categoryName;
  final ArgsForProd argument;
  const CategoryCard({
    this.categoryName,
    this.args,
    this.argument,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: args.contains(categoryName)
              ? BoxDecoration(color: Colors.green[600])
              : BoxDecoration(color: Colors.white60),
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
        
        Navigator.pushNamed(context, "/selectproduct", arguments: argument);
      },
    );
  }
}

class ArgsForProd {
  String categoryName;
  String supermarketId;
  ArgsForProd({this.categoryName, this.supermarketId});
}
