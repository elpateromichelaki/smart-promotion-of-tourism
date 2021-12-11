import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/services/auth_services.dart';
import 'package:smart_promotion_of_tourism/shared/loading.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/acc_edit.dart';

class MyBusinessList extends StatefulWidget {
  @override
  _MyBusinessListState createState() => _MyBusinessListState();
}

class _MyBusinessListState extends State<MyBusinessList> {
  DocumentReference busIdTemp;
  final AuthServices _authServices = AuthServices();

  Future<void> deleteBusiness(DocumentReference busIdTemp){
    return busIdTemp.delete();
  }

  showAlertDialog(BuildContext context) {
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);

      },
    );
    Widget yesButton = TextButton(
      child: Text(
        'Yes',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () async{
        deleteBusiness(busIdTemp);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete your business?"),
      actions: [
        yesButton,
        noButton
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  displayBusiness(BuildContext context, QueryDocumentSnapshot doc) {
    Widget okButton = TextButton(
      child: Text(
        'Ok',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () async{
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Your Business"),
      content: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Type: " +doc.data()['type']),
            ),
            Text("Name: " +doc.data()['name']),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Location Information"),
            ),
            Text("Address: "+doc.data()['address'] +", " +doc.data()['city'].toString() +", " +doc.data()['state'] +", " +doc.data()['country']),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Contact Information"),
            ),
            Text("Phone: " +doc.data()['phoneDialingCode'] +" " +doc.data()['phone'].toString()),
            Text("Email: " +doc.data()['email']),
            Text("Website: " +doc.data()['website']),
            Text("TripAdvisor link: " +doc.data()['tripAdvisor']),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("General Information"),
            ),
            Text("Description: " +doc.data()['description']),
            Text("Image: "),
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
                  Text("Number of rooms: " +doc.data()['rooms'].toString()),
                  Text("Average Price: " +doc.data()['price'].toString())
                ])
                :(doc.data()['type'] == "Food & Beverages")?
            Column(
                children :[
                  (doc.data()['category'].toString() != 'null') ? Text("Category: " +doc.data()['category']) : Text("Category: No selected category!"),
                  Text("Cuisine: " +doc.data()['cuisine'].toString()),
                  Text("Average Price: " +doc.data()['price'].toString())
                ])
                :(doc.data()['type'] == "Travel & Tourism")?
            Column(
                children :[
                  (doc.data()['category'].toString() != 'null') ? Text("Category: " +doc.data()['category']) : Text("Category: No selected category!"),
                  Text("Average visit time: " +doc.data()['visitTime'].toString()),
                  Text("Average entry fee: " +doc.data()['entryFee'].toString())
                ])
                :(doc.data()['type'] == "Entertainment")?
            Column(
                children :[
                  (doc.data()['category'].toString() != 'null') ? Text("Category: " +doc.data()['category']) : Text("Category: No selected category!"),
                ])
                : Container()
          ],
        ),
      ),
      actions: [
        okButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var userId = _authServices.currUser().toString();

    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("businesses").where('uid', isEqualTo: userId).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
          if(!snap.hasData){
            return Center(
              child: Container(
                  child: Loading()
              ),
            );
          }


          return ListView(
            children: snap.data.docs.map((doc) {
              return Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 20.0,
                      ),
                      height: 125.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(0.0, 4.0),
                              blurRadius: 10.0,
                            ),
                          ]),
                      child: InkWell(
                        onTap: () {
                          displayBusiness(context, doc);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white),
                            child: Row(
                                children: [
                                  Container(
                                    height: 90.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0)),
                                        image: DecorationImage(
                                            image: (doc['imageUrl'] != null) ? NetworkImage(doc['imageUrl']) : AssetImage("assets/business.png"),
                                            fit: BoxFit.cover)
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doc.data()['name'],
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          doc.data()['address'],
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          width: 150.0,
                                          child: Text(
                                            doc.data()['type'],
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      ]),
                                  SizedBox(width: 10.0),
                                  Column(
                                    children: [
                                      SizedBox(height: 10.0),
                                      IconButton(
                                          icon: Icon(Icons.edit_outlined),
                                          onPressed: () async {
                                            busIdTemp = doc.reference;
                                            print(busIdTemp);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => AccEdit(businessId: busIdTemp)));

                                            }

                                      ),
                                      SizedBox(height: 10.0),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            busIdTemp = doc.reference;
                                            print(busIdTemp);
                                            showAlertDialog(context);
                                          }
                                      )
                                    ],
                                  )
                                ])),
                      )));
            }).toList(),
          );
        },
      ),
    );
  }
}
