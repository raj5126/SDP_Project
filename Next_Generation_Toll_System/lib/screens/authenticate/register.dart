import 'package:paymentgateway/service/auth.dart';
import 'package:paymentgateway/shared/constants.dart';
import 'package:paymentgateway/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth= AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;
  
  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Register'),
        actions: <Widget>[
          FlatButton.icon(
            color: Colors.red,
            icon:Icon(Icons.person),
            label: Text("Existing User"),
            onPressed: (){
              widget.toggleView();
            },
          ),
        ],
      ),
      body:Container(
        padding: EdgeInsets.symmetric(vertical: 30.0,horizontal: 50.0),
        child:  Form(
          key: _formkey,
          child: Column(
            children:  <Widget>[
              SizedBox(height: 30.0),
              Text(
                error,
                style : TextStyle(
                  color:Colors.red,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: txtdecoration.copyWith(hintText : 'Email'),
                validator: (val) => val.isEmpty ? 'Enter Valid Email': null,
                onChanged: (val){
                    setState(() => email=val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: txtdecoration.copyWith(hintText: 'Password'),
                validator: (val) => val.length < 6  ? 'Enter a password 6+ chars long': null,
                obscureText: true,
                onChanged: (val){
                     setState(() => password=val);
                }),
                SizedBox(height: 40.0),
                ButtonTheme(
                    minWidth: 90.0,
                    height: 40.0,
                    child: RaisedButton(
                    color: Colors.blue[600] ,
                    child: Text(
                      'Sign Up',
                       style :TextStyle(
                         color: Colors.white,
                         fontSize: 20.0,
                       ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                    
                    onPressed: () async {
                      
                      if (_formkey.currentState.validate())
                      {
                        //print(email); 
                        //print(password);
                        setState(() => loading = true);
                        dynamic result = await _auth.registerwithemailandpassword(email, password);
                        if(result == null){
                            setState((){
                              error='INVALID USERNAME OR PASSWORD.';
                              loading=false;
                            });
                        }
                      }
                    },
                    ),
                )
            ],
            ),
        ),
      ),
    );
  }
}