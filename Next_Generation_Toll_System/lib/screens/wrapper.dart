import 'package:paymentgateway/models/User.dart';
import 'package:paymentgateway/screens/authenticate/authenticate.dart';
import 'package:paymentgateway/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  store(email) async{
  SharedPreferences eid = await SharedPreferences.getInstance();
  setState(() {
      eid.remove('email');
      eid.setString('email', email);
    });
    }

    @override
    Widget build(BuildContext context) {
      final user = Provider.of<User>(context);
      //print(user);
      if(user==null){
        return Authenticate();
      } 
      else{
        store(user.email);
        return Home(text:user.email);
      }
    }
}