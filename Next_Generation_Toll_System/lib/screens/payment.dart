import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paymentgateway/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';



class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

 int tollamount=0;
 String car_no;
 Razorpay _razorpay;
 String mail;
 String source,dest,journey_date;
 

loadmail() async{
  SharedPreferences eid= await SharedPreferences.getInstance();
  setState(() {
    mail = eid.getString('email');
  });
}
  @override
  void initState() {
    super.initState();
    print('init');
    loadmail();
    loadsrc();
    loaddes();
    loadjourneydate();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalwallet);
  }

  @override
   void dispose() {
    super.dispose();
    print('dispose');
    _razorpay.clear();
  }

  void opencheckout() async{
     var options={
       'key':'rzp_test_RauF4jq6tdDCp8',
       'amount':tollamount*100,
       'name':'PAYMENTGATEWAY',
       'description':'TOLL PAYMENT',
       'prefill':{'contact' : '','email' :''},
       'external':{
            'wallets':['paytm']
            }
    };
      print('Above try block');
    try{
      print('Above open options');
      _razorpay.open(options);
      print('Under open options');
    }
    catch(e){
      debugPrint(e);
    }     
 }

 loadsrc() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     source = prefs.getString("src");
   });
 }

 loaddes() async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     dest = prefs.getString("des");
   });
 }

 loadjourneydate () async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     journey_date = prefs.getString('journey_date');
     print(journey_date);
   });
 }

  Future <void> addhistory() async{
    final db = Firestore.instance;
    await db.collection("User_History")
.add({
  'name':mail,
  'source':source,
  'destination':dest,
  'total_fair':tollamount,
  'journeydate': DateTime.parse(journey_date)
}).then((documentReference){
   print(documentReference.documentID);
}).catchError((e){
  print(e);
});  }

void _handlePaymentSuccess(PaymentSuccessResponse response){
  
  Fluttertoast.showToast(msg : 'Payment Success : ' + response.paymentId);
  addhistory();
  Navigator.push(context, MaterialPageRoute(builder: (context) => Home(text:mail)));
 
}

void _handlePaymentError(PaymentFailureResponse response){
  Fluttertoast.showToast(msg : 'Payment Error : ' + response.code.toString());
}

void _handleExternalwallet(ExternalWalletResponse response){
  Fluttertoast.showToast(msg : 'External Payment Success : ' + response.walletName);
}


  @override
  Widget build(BuildContext context) {
    loadtoll();
    loadcarno();
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding:  EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            Text(
              'Total Amount : ',
              style: TextStyle(
                fontSize : 20.0
              ),
            ),
            Text(
              tollamount.toString(),
              style: TextStyle(
               fontSize : 20.0,
               letterSpacing: 2.0,
               fontWeight: FontWeight.bold,
              ),
            )
            ],
          ),
          SizedBox(height:20.0),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            Text(
              'Vehicle Number : ',
              style: TextStyle(
                fontSize : 20.0
              ),
            ),
              Text(
              car_no,
              style: TextStyle(
               fontSize : 20.0,
               letterSpacing: 2.0,
               fontWeight: FontWeight.bold,
              ),
            )
            ],
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                RaisedButton(
                  onPressed: () {
                     opencheckout();
                  },
                  color: Colors.red,
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                )
            ],
          ),
          ],
          ),
      ),
    );
  }
  
   loadtoll() async {
   SharedPreferences tamount = await SharedPreferences.getInstance();
   setState(() {
      tollamount = tamount.getInt('tollamount');  
   });
 }

 loadcarno() async{
   SharedPreferences carno = await SharedPreferences.getInstance();
   setState(() {
      car_no = carno.getString('carnumber');
   });
 }

}
