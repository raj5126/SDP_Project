
import 'package:paymentgateway/screens/history.dart';
import 'package:paymentgateway/screens/livelocation.dart';
import 'package:paymentgateway/screens/maproute.dart';
import 'package:paymentgateway/service/auth.dart';
import 'package:flutter/material.dart';
class  Home extends StatelessWidget {
  final String text;
  Home({Key key, @required this.text}):super(key:key);
  final AuthService _auth = AuthService(); 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //title : Text("Home Screen"),
          title: Text(text), 
          backgroundColor: Colors.black,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon:Icon(Icons.person),
              label: Text("Logout"),
              color : Colors.red,
              onPressed: () async{
                await _auth.signOut();
              }, 
             )
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 0.0),
          child:ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Advance Pay Toll For Journey'),
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MapRoute()));},
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.my_location),
                  title: Text('Pay Toll For Journey Based on live location'),
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => LiveLocationMap()));},
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.message),
                  title: Text('History'),
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> UserHistory()));},
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}