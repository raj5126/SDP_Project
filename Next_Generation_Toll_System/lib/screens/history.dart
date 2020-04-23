import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor : Colors.white,
        appBar: AppBar(
          title: Text("Previous Transaction"),
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: ListPage(),
      );
  }
}


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String email;

  loademail() async{
       SharedPreferences prefs = await SharedPreferences.getInstance();
       setState(() {
          email = prefs.getString('email');
        });
  }

@override
void initState(){
  setState(() {
    loademail();
  });
  super.initState();
}

  Future getPosts() async{
    var firestore = Firestore.instance;
    QuerySnapshot qn  = await firestore.collection('User_History').where('name',isEqualTo:email).getDocuments();
    print(qn.documents);
    return qn.documents;
  }
  navigateToDetail(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsPage(post: post,)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(  
      child : FutureBuilder(
        future: getPosts(),
        builder: (_, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: Text("Loading..."),
            );
          }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){
                  return ListTile(
                  title: Text(snapshot.data[index].data["source"].toString().toUpperCase() + ' => ' + snapshot.data[index].data["destination"].toString().toUpperCase()),
                  subtitle: Text((new DateFormat('dd-MM-yyyy').format(snapshot.data[index].data["journeydate"].toDate())).toString()),
                  onTap: ()=>navigateToDetail(snapshot.data[index]),
                );
              });
          }
      }),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final DocumentSnapshot post;
  DetailsPage({this.post});
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text("Details"),
        backgroundColor: Colors.black,
      ),
      body:Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Source : ' + ' ' + widget.post.data['source'].toString().toUpperCase(),
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 20.0
                  ),
            ),
            SizedBox(height:10.0),
            Text('Destination : ' + ' ' + widget.post.data['destination'].toString().toUpperCase(),
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 20.0
                  ),
            ),
            SizedBox(height:10.0),
            Text('Total Fair : ' + ' ' + widget.post.data['total_fair'].toString(),
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 20.0
                  ),
            ),
            SizedBox(height:10.0),
            Text('Journey Date : ' + ' ' + new DateFormat('dd-MM-yyyy').format(widget.post.data['journeydate'].toDate()).toString(),
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 20.0
                  ),
            ),
          ],
        ),
      )
    );
  }
}