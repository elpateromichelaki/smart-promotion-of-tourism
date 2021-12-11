import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/models/business_accommodation.dart';
import 'package:smart_promotion_of_tourism/models/business_attraction.dart';
import 'package:smart_promotion_of_tourism/shared/loading.dart';

class EditBusiness extends StatefulWidget {
  final DocumentReference businessId;
  EditBusiness({this.businessId});

  @override
  State<StatefulWidget> createState() => EditBusinessState();
}

class EditBusinessState extends State<EditBusiness> {
  var queryResultSet;
  String _name;


  @override
  Widget build(BuildContext context) {

    var docRef = widget.businessId;



    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your business!'),
      ),
      body: StreamBuilder(
          stream: docRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                    child: Loading()
                ),
              );
            }
            var doc = snapshot.data;

            checksSameName(String name) async{

              if(name.length != 0) {
                return queryResultSet = FirebaseFirestore.instance.collection("businesses").where('name', isEqualTo: name).snapshots().toList();
              }

              if(queryResultSet != []) {
                return 'Name already exists! Try again.';
              }else{
                return null;
              }
            }

            Widget _buildName() {
              return  Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextFormField(
                  initialValue: doc.data()['name'],
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.business_center_sharp),
                      labelText: 'Official Name',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          )
                      )
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String val) {

                    if (val.isEmpty) {
                      return 'Official name is required';
                    }else if(val.isNotEmpty){
                      checksSameName(val);
                    }

                    return null;
                  },
                  onChanged: (String value) {
                    _name = value;
                  },
                ),
              );
            }
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: Text("Type: ",
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: Text(
                              doc.data()['type'],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: Text("Name: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: _buildName(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: Text("Location Information",
                            style: TextStyle(
                                fontSize: 20.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: Text("Address: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                          child: TextFormField(
                              initialValue: doc.data()['address'] +", " +doc.data()['city'].toString() +", " +doc.data()['state'] +", " +doc.data()['country']),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Contact Information",
                            style: TextStyle(
                                fontSize: 20.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Phone: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              initialValue: doc.data()['phone'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Email: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              initialValue: doc.data()['email']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Website: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              initialValue: doc.data()['website']),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Contact Information",
                            style: TextStyle(
                                fontSize: 20.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Description: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              initialValue: doc.data()['description']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Image: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          height: 90.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: (doc.data()['imageUrl'] != null) ? NetworkImage(doc.data()['imageUrl']) : AssetImage("assets/business.png"),
                                  fit: BoxFit.cover)
                          ),
                        ),
                        (doc.data()['type'] == "Accommodation")?
                        Column(
                            children :[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Number of rooms: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['rooms'].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Average Price: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['price'].toString()),
                              ),
                            ])
                            :(doc.data()['type'] == "Food & Beverages")?
                        Column(
                            children :[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Category: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['category'].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Cuisine: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['cuisine'].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Average Price: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['price'].toString()),
                              ),
                            ])
                            :(doc.data()['type'] == "Travel & Tourism")?
                        Column(
                            children :[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Category: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['category'].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Average visit time: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['visitTime'].toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Average entry fee: ",
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    initialValue: doc.data()['entryFee'].toString()),
                              ),
                            ])
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );

  }
}
