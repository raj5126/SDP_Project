import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paymentgateway/screens/editdetails.dart';

  class MapRoute extends StatefulWidget {
    @override
    _MapRouteState createState() => _MapRouteState();
  }

  class _MapRouteState extends State<MapRoute> {
    GoogleMapController mapController;
    final Map<String, Marker> _markers = {};
    String search_src,search_des;
    String source,dest;
    double _sourceA,_sourceB;
    double _destA,_destB;
    var tolls=[];
    int i=0;

    BitmapDescriptor tollicon; 
    BitmapDescriptor destination;
    BitmapDescriptor src;
    
    @override
    Widget build(BuildContext context) {
      createMarker(context);
      return Scaffold(
        body: Stack(  
          children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 160.0, 0.0, 0.0),
                child: GoogleMap(
                  compassEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition :CameraPosition(
                      target: LatLng(20.5937, 78.9629),
                      zoom: 5.0,
                      tilt: 70,
                      bearing: 30
                    ),
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,
                  markers: _markers.values.toSet(),
                ),
              ),
              Positioned(
                top: 40.0,
                right :15.0,
                left: 15.0,
                child: Container(
                  height: 45.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width:2.00),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Source',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0,top: 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location),
                        onPressed: searchandnavigatesource,
                        iconSize: 25.0,
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        search_src = val;
                        source = search_src;
              
                      });
                    },
                  ),
                ),
              ), 
              SizedBox(height :20.0),
              Positioned(
                top: 100.0,
                right :15.0,
                left: 15.0,
                child: Container(
                  height: 45.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.blue, width:2.00),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Destination',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0,top: 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchandnavigatedest,
                        iconSize: 30.0,
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        search_des = val;
                        dest = search_des;
                      });
                    },
                  ),
                ),
              ), 
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: locateToll,
          tooltip: 'Get Path',
          child: Icon(Icons.location_on),
        ),  
        bottomNavigationBar: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(70.0, 5.0, 70.0, 5.0),
              child: ButtonTheme(
                height: 40.0,
                minWidth: 20,
                child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                        color: Colors.black ,
                        child: Text(
                          'Pay Toll',
                          style :TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ), 
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => Editdetails()));
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        
              ),
          ),
            ), 
      )
      );
    }


  void _onMapCreated(GoogleMapController controller){
      setState(() {
        mapController = controller;
      });
    }

  
  createMarker(context){
    if (tollicon==null){
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, "assets/Booth.png").then((icon){
        setState(() {
          tollicon=icon;
        });
      });
    }
  }

storesrc() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    prefs.remove('src');
    prefs.setString('src', search_src);
    print(prefs.getString('src'));
  });
}

storedes() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    prefs.remove('des');
    prefs.setString('des', search_des);
    print(prefs.getString('des'));
  });
}

  searchandnavigatesource(){
      Geolocator().placemarkFromAddress(search_src).then ((result){
        mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target : LatLng(result[0].position.latitude,result[0].position.longitude),
          zoom :10.0
        ),
        
        ));
        setState(() {
          //_markers.clear();
          final marker = Marker(
              markerId: MarkerId("source_loc"),
              position: LatLng(result[0].position.latitude,result[0].position.longitude),
              infoWindow: InfoWindow(title: 'Start Location'),
              //icon: src
        );
        _markers["Source"] = marker;
        storesrc();
      });
      _sourceA = result[0].position.latitude;
      _sourceB = result[0].position.longitude;
      print(_sourceA);
      print(_sourceB);
  });
  }

  searchandnavigatedest(){
    Geolocator().placemarkFromAddress(search_des).then ((result){
      mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target : LatLng(result[0].position.latitude,result[0].position.longitude),
        zoom :10.0
      ),
      
      ));
      setState(() {
        //_markers.clear();
        final marker = Marker(
            markerId: MarkerId("dest_loc"),
            position: LatLng(result[0].position.latitude,result[0].position.longitude),
            infoWindow: InfoWindow(title: 'End Location'),
           // icon: destination
        );
        _markers["dest"] = marker;
        storedes();
        print(dest);
      });
      _destA = result[0].position.latitude;
      _destB = result[0].position.longitude;
      print(_destA);
      print(_destB);
      });
  }


gettolllocation(p) {
     print('Inside gettolllocation');
     print(p.length);
     i=0;
    for (var doc in p){
        tolls=[];
        Stream<QuerySnapshot> querysnapshot = Firestore.instance.collection('TollTax').
                                              where('toll', isEqualTo: doc).snapshots();
    querysnapshot.forEach((field) async {
        field.documents.asMap().forEach((index,data){
          var p = field.documents[index]['location'];
          //print(p);
          tolls.add(p);
        });
        i+=1;
        if(i==p.length){
        print(tolls);  
        tollmark(tolls, tolls.length);
        await storevalue(p);
        loadvalue();
        }
      });
    }
}

locateToll() {
    print('locate toll called..');
    Stream<QuerySnapshot> querysnapshot = Firestore.instance.collection('Virtual_Tollbooth').
                                          where('source', isEqualTo : source.toLowerCase() ).
                                          where('destination', isEqualTo : dest.toLowerCase() ).snapshots();
    querysnapshot.forEach((field){
      field.documents.asMap().forEach((index,data){
                    var p  = field.documents[index]['Toll'];
                    print(p);
                    gettolllocation(p);
        });
     });
}

storevalue(toll) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    prefs.remove('tolllist');
    prefs.setString('tolllist', toll.toString());
  });
}        

loadvalue() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    print(prefs.getString('tolllist'));
  });
}   

tollmark(toll,tolllength){
    setState(() {
          for (i=0;i<tolllength;++i)
            {
              //removeMarker(i.toString());
              final marker = Marker(
                  markerId: MarkerId(i.toString())  ,
                  position: LatLng(toll[i].latitude,toll[i].longitude),
                  infoWindow: InfoWindow(title: 'Toll '),
                  icon:tollicon
              );
              _markers[i.toString()] = marker;
            }
          });
}
     
}