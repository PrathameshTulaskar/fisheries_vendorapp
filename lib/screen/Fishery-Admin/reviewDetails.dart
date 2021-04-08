import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fisheries_vendorapp/providers/appstate.dart';
import 'package:fisheries_vendorapp/models/customerReviews.dart';
import 'package:provider/provider.dart';


class ReviewDetails extends StatefulWidget {
  const ReviewDetails({Key key}) : super(key: key);

  @override
  _ReviewDetailsState createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends State<ReviewDetails> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SafeArea(
          child: Scaffold(
            appBar:AppBar(title:Text("Reviews"),),
            body: Column(
              children: [
                SizedBox(height:10),
                Center(child:Text("${appState.fishBusiness.overallReview}/5", style:TextStyle(fontWeight:FontWeight.bold,fontSize:25))),
                SizedBox(height:10),
                Expanded(
                                  child: FutureBuilder<List<CustomerReviews>>(
                               future: appState.getCustomerReviewsList(),
                               builder: (context, snapshot) {
                  //  var children = <Widget>[];
                  //  switch (snapshot.connectionState) {
                  //    case ConnectionState.none:
                  //    case ConnectionState.waiting:
                  //      children = [
                  //        Container(
                  //            width: MediaQuery.of(context).size.width*0.80,
                  //            height: MediaQuery.of(context).size.height*0.80,
                  //            child:
                  //                Center(child: CircularProgressIndicator()))
                  //      ];
                  //      break;
                  //    default:
                  //      if (snapshot.hasError)
                  //        children = [Text('Error: ${snapshot.error}')];
                  //      else {
                  //        snapshot.data.length == 0
                  //            ? children = null
                  //            : snapshot.data.forEach((element) {
                  //                //appState.getOurFishProduct().forEach((element) {
                  //                children.add(CustomerReviewsDetails(
                  //                    profile: element.profile,
                  //                    userName:
                  //                        element.userName,
                  //                    rating:
                  //                        element.rating.toString(),
                  //                    review:element.review,    
                  //                    ));
                  //              });
                  //        //data
                  //      }
                  //  }

                   return ListView.builder(
                     

                           itemCount: snapshot.data==null ? 0 : snapshot.data.length,
                           itemBuilder: (BuildContext context, int index) {
                           return CustomerReviewsDetails(
                                       profile: snapshot.data[index].profile,
                                       userName:
                                           snapshot.data[index].userName,
                                       rating:
                                           snapshot.data[index].rating,
                                       review:snapshot.data[index].review,    
                                       );
                          },
                         );
                      //  GridView.count(
                      //      crossAxisCount: 1,
                      //      //crossAxisSpacing: 5.80,
                      //      mainAxisSpacing: 8.0,
                      //      childAspectRatio: 3.70,
                      //      physics: NeverScrollableScrollPhysics(),
                      //      shrinkWrap: true,
                      //      children: children,
                      //    );
                   //Column(children: children);
                               },
                             ),
                ),
              ],
            ),
      ),
    );
  }
}


class CustomerReviewsDetails extends StatefulWidget {
  final String profile;
  final String userName;
  final int rating;
  final String review;
  CustomerReviewsDetails({Key key,
  this.profile,
  this.userName,
  this.rating,
  this.review,

  }) : super(key: key);

  @override
  _CustomerReviewsDetailsState createState() => _CustomerReviewsDetailsState();
}

class _CustomerReviewsDetailsState extends State<CustomerReviewsDetails> {
  @override
  Widget build(BuildContext context) {
    return Card(

          child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.profile),),
           title: Text(widget.userName??""),
           subtitle: Text(widget.review??""),
          //  isThreeLine: true,
           trailing:widget.rating==null?Container():
              widget.rating ==1 ?Icon(Icons.star,color: Colors.yellow,size:14.0) :
              widget.rating ==2 ?Container(
                width:70,
                child: Row(children: [
                  Icon(Icons.star,color: Colors.yellow,size:14.0),
                  Icon(Icons.star,color: Colors.yellow,size:14.0)
                ],),
              ):
              widget.rating ==3 ?Container(width:70,
                child: Row(children: [
                  Icon(Icons.star,color: Colors.yellow,size:14.0),Icon(Icons.star,color: Colors.yellow,size:14.0),
                  Icon(Icons.star,color: Colors.yellow,size:14.0)
                ],),
              ):
              widget.rating ==4 ?Container(width:70,
                child: Row(children: [
                  Icon(Icons.star,color: Colors.yellow,size:14.0),Icon(Icons.star,color: Colors.yellow,size:14.0),Icon(Icons.star,color: Colors.yellow,size:14.0),
                  Icon(Icons.star,color: Colors.yellow,size:14.0)
                ],),
              ):Container(width:70,
                child: Row(children: [
                  Icon(Icons.star,color: Colors.yellow,size:14.0),Icon(Icons.star,color: Colors.yellow,size:14.0),Icon(Icons.star,color: Colors.yellow,size:14.0),Icon(Icons.star,color: Colors.yellow,size:14.0),
                  Icon(Icons.star,color: Colors.yellow,size:14.0)
                ],),
              )
            
          

           
         ),
    );
  }
}