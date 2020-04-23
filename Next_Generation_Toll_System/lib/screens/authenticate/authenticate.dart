import 'package:paymentgateway/screens/authenticate/register.dart';
import 'package:paymentgateway/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
   
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isSignedIn = true;

  void toggleView(){
    setState(() => isSignedIn = !isSignedIn);
  }

  @override  Widget build(BuildContext context) {
   if (isSignedIn){
     return SignIn(toggleView: toggleView);
   }
   else{
     return Register(toggleView: toggleView);
   }
 }
}