import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:paymentgateway/screens/payment.dart';

class Editdetails extends StatefulWidget {
  @override
  _EditdetailsState createState() => _EditdetailsState();
}

class _EditdetailsState extends State<Editdetails> {

loadvalue() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    print(prefs.getString('tolllist'));
  });
}   

@override
  void initState(){
      loadvalue();
      super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  String dropdownValue=' ';
  String value;
  String error='';
  DateTime date;
  String vehicleno='';
  String s='';
  int total=0;
  int i=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Details'),
        backgroundColor: Colors.black,
        elevation: 10.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .50,
        padding: EdgeInsets.symmetric(vertical:10.0,horizontal:50.0),
        child: Form(
          key:_formkey,
          child: Column(
            children:<Widget>[
              //SizedBox(height: 30.0),
              Text(
                error,
                style: TextStyle(
                  color:Colors.red,
                  fontSize: 20.0,
                ),  
              ),
              SizedBox(height: 20.0), 
              DropdownButton<String>(
                isExpanded: true,
                value: value,
                hint: new Text('Vehicle Type'),
                icon:Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                 ),
                underline: Container(
                  height:2,
                  color: Colors.black,
                  ),
                onChanged: (String newvalue){
                    setState(() {
                      value=newvalue;
                    }); 
                },
                items: <String>['CAR / JEEP','BUS / 2 AXLE','TRUCK / 3 AXLE','LCV'].map<DropdownMenuItem<String>>((String value){
                     return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
               DateTimePickerFormField(
                    inputType: InputType.date,
                    format: DateFormat("yyyy-MM-dd"),
                    initialDate: DateTime(2019, 1, 1),
                    editable: true,
                    decoration: InputDecoration(
                    labelText: 'Date',
                    hasFloatingPlaceholder: false  
                  ),
                onChanged: (dt) {
                       setState(() => date = dt);
                       print('Selected date: $date');
                       savejourneydate();
                    },
                  style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                    hintText : 'Vehicle No.',
                    fillColor: Colors.white,
                ),
                validator: (value) => value.isEmpty ? "Enter Vehicle number." : null,
                style: TextStyle(
                  fontSize:20.0,                
                   ),
                onChanged: (val) {
                  setState(()=>vehicleno = val);
                }
                ),
                SizedBox(height: 20),
               
              RaisedButton(
                onPressed:(){
                   if (_formkey.currentState.validate()){
                     print(value);
                     print(date);
                     print(vehicleno);
                     showtollamount();
                     savecarno(vehicleno);
                     Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
                   }
                } ,
                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                color: Colors.blue ,
                        child: Text(
                          'Show Tollamout',
                           style :TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),)
            ]
          ),
        ),
      ),  
    );
  }

savecarno(value) async{
  SharedPreferences carno = await SharedPreferences.getInstance();
  setState(() {
    carno.remove('carnumber');
    carno.setString('carnumber', value);
  });
}

saveamount(amount) async{
  SharedPreferences tamount = await SharedPreferences.getInstance();
  setState(() {
   tamount.remove('tollamount');
   tamount.setInt('tollamount',amount);
  });
  
}
savejourneydate() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    prefs.remove('journey_date');
    prefs.setString('journey_date',date.toString());
    print(prefs.getString('journey_date'));
  });
}
   showtollamount() async{
    String s = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    s = prefs.getString('tolllist').substring(1,prefs.getString('tolllist').length-1);
    total = 0;
    i=0;
    for (var doc in s.split(', ')){
          Stream<QuerySnapshot> querysnapshot = Firestore.instance.collection('TollPrice').
              where('toll', isEqualTo: doc).where('vehicle_type',isEqualTo: value.toLowerCase()).snapshots();
          querysnapshot.forEach((field){
          field.documents.asMap().forEach((index,data){
          int p = field.documents[index]['price'];
          total = total+p;
        });
        i+=1;
        if (i==s.split(', ').length){
         print('Total amount: ' + total.toString());
         saveamount(total);
      }
    });
  }
}
}