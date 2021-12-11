import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:smart_promotion_of_tourism/models/business_accommodation.dart';
import 'package:smart_promotion_of_tourism/models/placePredictions.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/user_home.dart';
import 'package:smart_promotion_of_tourism/services/auth_services.dart';
import 'package:smart_promotion_of_tourism/services/request.dart';
import 'package:smart_promotion_of_tourism/shared/loading.dart';

import 'business_screen.dart';

class AccEdit extends StatefulWidget {
  final DocumentReference businessId;
  AccEdit({this.businessId});

  @override
  State<StatefulWidget> createState() => AccEditState();
}

class AccEditState extends State<AccEdit> {
  final AuthServices _authServices = AuthServices();
  GeoFlutterFire geofire = GeoFlutterFire();
  var queryResultSet;

  CollectionReference _business = FirebaseFirestore.instance.collection('businesses');
  String imageName = 'No selected image';
  String nameImg;

  UploadTask task;
  File file;



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];
  TextEditingController price = TextEditingController();
  TextEditingController rooms = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController bphone = TextEditingController();
  TextEditingController bemail = TextEditingController();
  TextEditingController bwebsite = TextEditingController();
  Country cdc;
  Country cdcur;
  String countryDialingCode = "";
  String _selectedCountryCurr = "";
  String countryValue = "";
  String stateValue = "";
  String city = " ";
  String cityValue = " ";
  String cscInfo = "";
  double lat;
  double long;
  String _name;
  String _address;
  int _bphone;
  String _bemail;
  String _bwebsite;
  String _tripAdvisor;
  int _rooms;
  int _price;
  String _desc;
  String _imageUri;

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


            Widget _buildAddress (){
              return  Column(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      child: TextFormField(
                        initialValue: doc.data()['address'] +", " +doc.data()['city'].toString() +", " +doc.data()['state'] +", " +doc.data()['country'],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.business_center_sharp),
                          labelText: 'Street Address',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300
                              )
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Street address is required';
                          }
                          return null;
                        },
                        onSaved: (String value) async{
                          _address = value;
                          List<Location> placemark = await locationFromAddress(_address);
                          print(placemark);
                          Location loc = placemark[0];
                          long = loc.longitude;
                          lat = loc.latitude;
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            Widget _buildWebsite() {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: TextFormField(
                  initialValue: doc.data()['website'],
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      labelText: 'Website',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          )
                      )
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (String value) {
                    _bwebsite = value;
                  },
                ),
              );
            }
            Widget _buildTripAdvisor() {
              return Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      labelText: 'TripAdvisor link',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          )
                      )
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (String value) {
                    _tripAdvisor = value;
                  },
                ),
              );
            }
            Widget _buildBEmail() {
              return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    initialValue: doc.data()['email'],
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            )
                        )
                    ),
                    onSaved: (String value) {
                      _bemail = value;
                    },
                  )
              );
            }

            Widget _buildPrice(){
              return Column(
                  children: <Widget> [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Text(
                        'Average Price',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            child: TextFormField(
                              initialValue: doc.data()['price'],
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      )
                                  )
                              ),
                              onChanged: (String value){
                                _price = int.parse(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Text(
                        'Currency',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Container(
                        width:250,
                        child: CountryPicker(
                          showFlag: true,
                          showName: false,
                          showCurrency: true,
                          showCurrencyISO: true,
                          showDialingCode: false,
                          selectedCountry: cdcur,
                          onChanged: (Country country) {
                            setState(() {
                              cdcur = country;
                              _selectedCountryCurr = country.currency;
                            });
                          },
                        ),
                      ),
                    ),
                  ]
              );
            }


            Widget _buildAccInfo(){
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0
                    ),
                    child: Text(
                      'Total number of rooms',
                    ),
                  ),
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black12,
                            )
                        )
                    ),
                    onChanged: (String value){
                      _rooms = int.parse(value);
                    },
                  ),
                ],
              );
            }
            Widget _buildDesc() {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: Text('Description'),
                  ),
                  Container(
                    height: 270,
                    child: TextFormField(
                      initialValue: doc.data()['description'],
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 400,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onSaved: (String value){
                        _desc = value;
                      },
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(
                              0.7, 0.7
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            showAlertDialogImageSelector(BuildContext context) {
              UploadTask uploadFile(String dest, File file){
                try {
                  final ref = FirebaseStorage.instance.ref(dest);
                  return ref.putFile(file);
                }on FirebaseException catch(e){
                  return null;
                }

              }
              Future uploadToStorage() async{
                if(file == null){
                  return;
                }
                final destination = 'files/$imageName';
                task = uploadFile(destination, file);

                Fluttertoast.showToast(msg: 'When the upload is completed, the dialog will close! Please wait...',
                    toastLength: Toast.LENGTH_LONG);
                if(task == null){
                  return;
                }
                final snap = await task.whenComplete(() {
                  //loading = false;
                  Navigator.of(context).pop();
                });
                final urlImg = await snap.ref.getDownloadURL();
                print(snap.bytesTransferred);
                print(urlImg);
                _imageUri = urlImg;
                print(_imageUri);

              }


              Widget userHomeButton = TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              );
              Widget myBusinessButton = TextButton(
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  uploadToStorage();
                },
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (context, setState) {
                        return  AlertDialog(
                          title: Text("Select images"),
                          content: file != null
                              ? Text( file !=null ? nameImg : 'No selected image.'
                          )
                              : Container(
                            child: Text("There are not selected images."),
                          ),
                          actions: [
                            TextButton(
                                child: Text(
                                  'Open gallery',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () async{
                                  final res = await FilePicker.platform.pickFiles(
                                      allowMultiple: false,
                                      type: FileType.image
                                  );
                                  if(res == null){
                                    return;
                                  }
                                  final path = res.files.single.path;
                                  nameImg = res.files.single.name;
                                  setState(() {
                                    file = File(path);
                                    imageName = file !=null ? res.files.single.name : 'No selected image.';
                                  });
                                }
                            ),
                            userHomeButton,
                            myBusinessButton
                          ],
                        );
                      }
                  );

                },
              );
            }
            saveBusiness(context) async{
              GeoFirePoint point = geofire.point(latitude: lat, longitude: long);
              BusinessAccommodation busAcc = BusinessAccommodation(
                  position: point.data,
                  longitude: long,
                  latitude: lat,
                  country: countryValue,
                  state: stateValue,
                  city: cityValue,
                  address: _address,
                  type: 'Accommodation',
                  name: _name,
                  phone: _bphone,
                  phoneDialingCode: countryDialingCode,
                  email: _bemail,
                  website: _bwebsite,
                  tripAdvisor: _tripAdvisor,
                  rooms: _rooms,
                  price: _price,
                  currency: _selectedCountryCurr,
                  description: _desc,
                  imageUrl: _imageUri,
                  uid: _authServices.currUser()
              );
              try {
                await _business.doc(docRef.toString()).set(busAcc.toMap());

              }catch(e){
                print(e.toString());
                return null;
              }
            }
            showAlertDialog(BuildContext context) {
              Widget userHomeButton = TextButton(
                child: Text("Back to home!"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserHome()));

                },
              );
              Widget myBusinessButton = TextButton(
                child: Text(
                  'My Business!',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusinessScreen()));
                },
              );

              AlertDialog alert = AlertDialog(
                title: Text("Success"),
                content: Text("Registered Successfully"),
                actions: [
                  userHomeButton,
                  myBusinessButton
                ],
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            }
            showAlertDialogVerification(BuildContext context) {
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
                onPressed: () {
                  saveBusiness(context);
                  showAlertDialog(context);
                },
              );

              AlertDialog alert = AlertDialog(
                title: Text("Business Information"),
                content: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Type: Accommodation"),
                        ),
                        Text("Name: "+_name),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Location Information"),
                        ),
                        Text("Address: "+_address +", " +city.toString() +", " +stateValue +", " +countryValue),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Contact Information"),
                        ),
                        Text("Phone: " +countryDialingCode +" " +_bphone.toString()),
                        Text("Email: " +_bemail),
                        Text("Website: " +_bwebsite),
                        Text("TripAdvisor link: " +_tripAdvisor),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("General Information"),
                        ),
                        Text("Number of rooms: " +_rooms.toString()),
                        Text("Average Price: " +_price.toString()),
                        Text("Currency: " +_selectedCountryCurr),
                        Text("Description: " +_desc),
                        Text("Image: "),// +_imageUri.toString()),
                        Container(
                          height: 90.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  topLeft: Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: (_imageUri != null) ? NetworkImage(_imageUri) : AssetImage("assets/blank.png"),
                                  fit: BoxFit.cover)
                          ),

                        )
                      ],
                    ),
                  ),
                ),
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
            Widget _buildImg() {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text('Upload images'),
                      ),
                      Expanded(
                        child: IconButton(
                            icon: Icon(Icons.add_a_photo_rounded),
                            onPressed: () {
                              showAlertDialogImageSelector(context);
                            }
                        ),
                      ),
                    ],
                  ),
                  Container(
                      child: Text(imageName)
                  )
                ],
              );
            }

            List<PlacePredictions> placePredictionList = [];
            TextEditingController locationController = TextEditingController();

            void findPlace(String placeName) async{
              if(placeName.length >1){
                String autocompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyBxVtuiCZCM2zavF-gIsH_buVVMJ-goO98&sessiontoken=1234567890&components=country:gr";
                var res = await Request.getRequest(Uri.parse(autocompleteUrl));

                if(res == "Failed"){
                  return;
                }
                if(res["status"] == "OK"){
                  var predictions = res["predictions"];

                  var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
                  setState(() {
                    var placePredictionList = placesList;
                  });
                }

              }
            }

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
            Widget _buildPhone() {
              return  Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Container(
                  width: 300,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CountryPicker(
                          selectedCountry: cdc,
                          showFlag: true,
                          showName: false,
                          showDialingCode: true,
                          onChanged: (country) {
                            setState(() {
                              cdc = country;
                              print(country.dialingCode);
                              countryDialingCode = country.dialingCode;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                              labelText: 'Phone',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  )
                              )
                          ),
                          onChanged: (String value) {
                            _bphone = int.parse(value);
                          },
                        ),
                      ),
                    ],
                  ),
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
                            child: _buildAddress()
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
                            child:  _buildPhone()
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
                            child: _buildBEmail()
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Trip Advisor Link: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildTripAdvisor()
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
                            child: _buildWebsite()
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("General Information",
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
                            child: _buildDesc()
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Change Image: ",
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _buildImg()
                        ),
                        (doc.data()['type'] == "Accommodation")?
                        Column(
                            children :[
                              //_buildAccInfo(),
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
                                  initialValue: doc.data()['rooms'].toString(),
                                  onChanged: (String value){
                                    _rooms = int.parse(value);
                                  },
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _buildPrice()
                              ),
                                                  Container(
                                                    child: ElevatedButton(
                                                      child: Text(
                                                        'Update'
                                                      ),
                                                      onPressed: () async{
                                                        showAlertDialogVerification(context);
                                                      }
                                                    )),
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
