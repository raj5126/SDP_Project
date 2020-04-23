import 'package:paymentgateway/service/auth.dart';
import 'package:paymentgateway/shared/constants.dart';
import 'package:paymentgateway/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


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
        title: Text('Sign In to App'),
        actions: <Widget>[
          FlatButton.icon(
            color: Colors.red,
            icon:Icon(Icons.person),
            label: Text("New User"),
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
                SizedBox(height: 30.0),
                ButtonTheme(
                    minWidth: 90.0,
                    height: 40.0,
                    child: RaisedButton(
                    color: Colors.blue[600] ,
                    child: Text(
                      'Sign in',
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
                        setState(() => loading = true);
                        dynamic result = await _auth. signInwithemailandpassword(email, password);  
                        if(result == null)
                        {
                           setState((){error='Invalid Credentials';
                           loading = false;
                           }); 
                        }
                        print(result.email);
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