import 'package:paymentgateway/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null?User(uid: user.uid,email: user.email):null;
  }


Stream<User> get user{
  return _auth.onAuthStateChanged
    .map((FirebaseUser user) => _userFromFirebaseUser(user));
}

  Future signInAnon() async{
    try{
      AuthResult result=await _auth.signInAnonymously();
      FirebaseUser   user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInwithemailandpassword(String email,String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email:email,password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
      }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  Future registerwithemailandpassword(String email,String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email:email,password: password);
      FirebaseUser user = result.user;
      //await DatabaseService(uid : user.uid).updateUserData('Raj Panchal','raj_5126'); 
      return _userFromFirebaseUser(user);
      }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

Future signOut() async{
  try{
    return await _auth.signOut();
  }
  catch(e){
    print(e.toString());
    return null;
  }
}
}