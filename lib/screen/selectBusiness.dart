import 'package:flutter/material.dart';

class SelectBusiness extends StatelessWidget {
  const SelectBusiness({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            appBar:AppBar(),
            body: SingleChildScrollView(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height:40),
                            Center(
                              child: InkWell(child: CircleAvatar(radius:140,backgroundImage: AssetImage('assets/images/fish.png'),
                              child: Container(height:50,width:297,
                              decoration: BoxDecoration(color:Colors.black.withOpacity(0.8),borderRadius: BorderRadius.circular(8)),
                                child: Center(child: Text("Fish Seller",style:TextStyle(fontWeight:FontWeight.bold,fontSize:40,fontStyle:FontStyle.italic,color:Colors.white),)))
                              ),
                              onTap:()=>Navigator.pushNamed(context, '/selectFish')),
                            ),

               SizedBox(height:40),       

                           Center(
                              child: InkWell(child: CircleAvatar(radius:140,backgroundImage: AssetImage('assets/images/fish.png'),
                              child: Container(height:50,width:297,
                              decoration: BoxDecoration(color:Colors.black.withOpacity(0.8),borderRadius: BorderRadius.circular(8)),
                                child: Center(child: Text("Grocery Seller",style:TextStyle(fontWeight:FontWeight.bold,fontSize:40,fontStyle:FontStyle.italic,color:Colors.white),)))
                              ),
                              onTap:()=>Navigator.pushNamed(context, '/')),
                            ),

          ],
        ),
            ),
      ),
    );
  }
}