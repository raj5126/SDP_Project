import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:paymentgateway/models/pin_pill_info.dart';
//import 'package:paymentgateway/components/map_pin_pill.dart';
import 'dart:async';

class LiveLocationMap extends StatefulWidget {
  @override
  _LiveLocationMapState createState() => _LiveLocationMapState();
}

class _LiveLocationMapState extends State<LiveLocationMap> {
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = 'Your_API_Key';
  GoogleMapController mapController;
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
    pinPath: '',
    avatarPath: '',
    location: LatLng(0, 0),
    locationName: '',
    labelColor: Colors.grey);

PinInformation sourcePinInfo;
PinInformation destinationPinInfo;

@override
void initState() {
    super.initState();
    location = new Location();
    polylinePoints = PolylinePoints();

    location.onLocationChanged().listen(
      (LocationData cLoc){
          currentLocation = cLoc;
          updatePinOnMap();
      }
    );
    setSourceAndDestinationIcons();
    setInitialLocation();
  }

  void setSourceAndDestinationIcons() async{
      sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png');
      destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0), 'assets/destination_map_marker.png');
  }
  
  void setInitialLocation() async {
    currentLocation = await location.getLocation();
    destinationLocation = LocationData.fromMap({
      "latitude":21.1702 ,
      "longitude":72.8311
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom:15,
      tilt:70 ,
      bearing: 30 ,
      target: LatLng(21.1255, 73.1122)
     );
    if(currentLocation!=null){
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 15,
          tilt: 70,
          bearing:30);
    }
    return Scaffold(
        body:Stack(children: <Widget>[
           GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onTap: (LatLng loc) {
                pinPillPosition = -100;
              },
              onMapCreated: (GoogleMapController controller) {
                //controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                showPinsOnMap();
              }),
          //MapPinPillComponent(
            //  pinPillPosition: pinPillPosition,
              //currentlySelectedPin: currentlySelectedPin)
        ],)
    );
  }

 void showPinsOnMap() {
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    var destPosition = LatLng(destinationLocation.latitude, destinationLocation.longitude);

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: LatLng(21.1702, 72.8311),
        pinPath: "assets/driving_pin.png",
        avatarPath: "assets/friend1.jpg",
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: LatLng(21.1255, 73.1122),
        pinPath: "assets/destination_map_marker.png",
        avatarPath: "assets/friend2.jpg",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));

    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
    //setPolylines();
  }

 void setPolylines() async {
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        currentLocation.latitude,
        currentLocation.longitude,
        destinationLocation.latitude,
        destinationLocation.longitude);

    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

   void updatePinOnMap() async {

    CameraPosition cPosition = CameraPosition(
      zoom: 15,
      tilt: 70,
      bearing: 30,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
      sourcePinInfo.location = pinPosition;
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition,
          icon: sourceIcon));
    });
  }
}
