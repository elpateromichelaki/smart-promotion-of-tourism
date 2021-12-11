import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smart_promotion_of_tourism/data_handler/app_data.dart';
import 'package:smart_promotion_of_tourism/screens/tourist_view/search_box.dart';
import 'package:smart_promotion_of_tourism/services/method_request.dart';

import '../../data_handler/app_data.dart';
import '../home.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  var removePoi = [
    {
      "featureType": "poi",
      "elementType": "labels",
      "stylers": [
        { "visibility": "off" }
      ]
    }
  ];

  final Completer<GoogleMapController> _controllerGM = Completer<GoogleMapController>();
  static final CameraPosition _initialcameraposition = CameraPosition(target: LatLng(0, 0));
  GoogleMapController newGMController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};


  Position currentPosition;
  LatLng latlangPosUser;
  var geolocator = Geolocator();

  GeoFirePoint center;

  double _selectedRadius = 0.0;
  GeoFlutterFire geofire = GeoFlutterFire();
  Stream<dynamic> query;
  // ignore: cancel_subscriptions
  StreamSubscription subscription;

  bool _isAccommodation = true;
  bool _isRestaurant = true;
  bool _isAttraction = true;
  bool _isEntert = true;


  List<DocumentSnapshot> businessList;
  bool areCardsToggled = false;

  PageController _pageContr = PageController(initialPage: 0, viewportFraction: 0.8);


  void _onScroll() {
    int prevPage;
    if (_pageContr.page.toInt() != prevPage) {
      prevPage = _pageContr.page.toInt();
      moveCamera();
    }
  }

  void getCurrPos() async{
    areCardsToggled = false;
    Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = p;

    LatLng latlangPos = LatLng(p.latitude, p.longitude);

    CameraPosition camPos = new CameraPosition(target: latlangPos, zoom: 13);
    newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));

    String address = await MethodRequest.serchCoordsAddr(p, context);
    center = geofire.point(latitude: p.latitude, longitude: p.longitude);

    Marker currentLoc = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: address, snippet: "You are here!" ),
        position: latlangPos,
        markerId: MarkerId(latlangPos.toString())

    );
    setState(() {
      markers = {};
      markers.add(currentLoc);
    });

  }
  Future<void> getAddressPos() async {
    areCardsToggled = false;
    var posName = Provider.of<AppData>(context, listen: false).userAddressLoc.placeName;
    var lat = Provider.of<AppData>(context, listen: false).userAddressLoc.latitude;
    var long = Provider.of<AppData>(context, listen: false).userAddressLoc.longitude;
    final GoogleMapController controller = await _controllerGM.future;
    LatLng latlangPos = LatLng(lat, long);

    CameraPosition camPos = new CameraPosition(target: latlangPos, zoom: 13);
    controller.animateCamera(CameraUpdate.newCameraPosition(camPos));
    center = geofire.point(latitude: lat, longitude: long);
    Marker currentLoc = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: posName , snippet: "You are here!" ),
        position: latlangPos,
        markerId: MarkerId(latlangPos.toString())
    );
    setState(() {
      markers = {};
      markers.add(currentLoc);
    });
  }


  void _saveMarkers(List<DocumentSnapshot> doclist) async{
    print(doclist);
    var addr = Provider.of<AppData>(context, listen: false).userAddressLoc.placeName;
    var centerlat = center.latitude;
    var centerlng = center.longitude;
    LatLng centerLatlong = LatLng(centerlat, centerlng);

    Marker currentLoc = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(title: addr, snippet: "You are here!" ),
        position: centerLatlong,
        markerId: MarkerId(centerLatlong.toString())

    );
    setState(() {
      markers = {};
      markers.add(currentLoc);
    });

    doclist.forEach((DocumentSnapshot document) {
      GeoPoint pos = document.data()['position']['geopoint'];

      final Marker markerQuery = Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: document.data()['name'], snippet: document.data()['address']),
          position: LatLng(pos.latitude,pos.longitude),
          markerId: MarkerId(document.data()['name'])
      );

      print(markerQuery);
      if (mounted) {
        setState(() {
          markers.add(markerQuery);
        });
      }

      print(markers);
      @override
      void dispose() {
        subscription.cancel();
        super.dispose();
      }
    });
    businessList = doclist;
    if(doclist.isNotEmpty){
      setState(() {
        areCardsToggled = true;
      });
    }
  }

  moveCamera() {
    LatLng target = LatLng(businessList[_pageContr.page.toInt()].data()['latitude'], businessList[_pageContr.page.toInt()].data()['longitude']);
    newGMController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: target, zoom: 15.0)));
  }
  _startQuery() async{
    var ref;
    // ignore: close_sinks
    BehaviorSubject<double> _radiusQueried = BehaviorSubject.seeded(_selectedRadius);
    print(_selectedRadius);

    if(_isAccommodation && _isAttraction && _isRestaurant && _isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses');
    }else if(!_isAccommodation && _isRestaurant && _isAttraction && _isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , whereIn: ["Food & Beverages", "Travel & Tourism", "Entertainment"]);
    }else if(!_isRestaurant && _isAttraction && _isAccommodation && _isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , whereIn: ["Accommodation", "Travel & Tourism", "Entertainment"]);
    }else if(_isRestaurant && !_isAttraction && _isAccommodation && _isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type', whereIn: ["Food & Beverages", "Accommodation", "Entertainment"]);
    }else if(_isRestaurant && _isAttraction && _isAccommodation && !_isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type', whereIn: ["Food & Beverages", "Accommodation", "Travel & Tourism"]);
    }else if(_isAccommodation && _isRestaurant && !_isAttraction && !_isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type', whereIn: ["Food & Beverages", "Accommodation"]);
    }else if(_isAccommodation && !_isRestaurant && !_isAttraction && _isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , whereIn: ["Entertainment", "Accommodation"]);
    }else if(_isAccommodation && !_isRestaurant && _isAttraction && !_isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type', whereIn: ["Travel & Tourism", "Accommodation"]);
    }else if(!_isAccommodation && _isRestaurant && _isAttraction && !_isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type', whereIn: ["Food & Beverages", "Travel & Tourism"]);
    }else if(!_isAccommodation && !_isRestaurant && _isAttraction && _isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , whereIn: ["Entertainment", "Travel & Tourism"]);
    }else if(!_isAccommodation && _isRestaurant && !_isAttraction && _isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type', whereIn: ["Food & Beverages", "Entertainment"]);
    }else if(!_isAccommodation && _isRestaurant && !_isAttraction && !_isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , isEqualTo: 'Food & Beverages');
    }else if(!_isRestaurant && !_isAttraction && _isAccommodation && !_isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , isEqualTo: 'Accommodation');
    }else if(!_isRestaurant && _isAttraction && !_isAccommodation && !_isEntert) {
      ref = FirebaseFirestore.instance.collection('businesses').where('type', isEqualTo: 'Travel & Tourism');
    }else if(!_isRestaurant && !_isAttraction && !_isAccommodation && _isEntert){
      ref = FirebaseFirestore.instance.collection('businesses').where('type' , isEqualTo: 'Entertainment');
    }else{
      Fluttertoast.showToast(msg: 'No selected category', toastLength: Toast.LENGTH_LONG);
    }

    subscription = _radiusQueried.switchMap((rad) {
      return geofire.collection(collectionRef: ref).within(
          center: center,
          radius: rad,
          field: 'position',
          strictMode: true);
    }).listen(_saveMarkers);


    LatLng centerLatLong = LatLng(center.latitude, center.longitude);
    if(_selectedRadius < 1){
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 14.5);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }else if(_selectedRadius < 1.5){
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 14);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }else if(_selectedRadius < 2){
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 13.5);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }else if(_selectedRadius < 2.5){
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 13);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }else if(_selectedRadius < 3){
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 13);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }else if(_selectedRadius < 3.5){
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 12.5);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }else{
      CameraPosition camPos = new CameraPosition(
          target: centerLatLong, zoom: 12.5);
      newGMController.animateCamera(CameraUpdate.newCameraPosition(camPos));
    }

    @override
    dispose() {
      subscription.cancel();
      super.dispose();
    }
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
      title: Text("Details Page"),
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
                  (doc.data()['category'].toString() == null) ? Text("Category: " +doc.data()['category']) : Text("Category: No selected category!"),
                  Text("Cuisine: " +doc.data()['cuisine'].toString()),
                  Text("Average Price: " +doc.data()['price'].toString())
                ])
                :(doc.data()['type'] == "Travel & Tourism")?
            Column(
                children :[
                  (doc.data()['category'].toString() == null) ? Text("Category: " +doc.data()['category']) : Text("Category: No selected category!"),
                  Text("Average visit time: " +doc.data()['visitTime']),
                  Text("Average entry fee: " +doc.data()['entryFee'].toString())
                ])
                :(doc.data()['type'] == "Entertainment")?
            Column(
                children :[
                  (doc.data()['category'].toString() == null) ? Text("Category: " +doc.data()['category']) : Text("Category: No selected category!"),
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


  _businessList(index){
    return AnimatedBuilder(
      animation: _pageContr,
      builder: (BuildContext context, Widget widget){
        double value = 1;
        if(_pageContr.position.haveDimensions){
          value = _pageContr.page - index;
          value = (1 - (value.abs() * 0.3)+ 0.6).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: (){
            moveCamera();
          },
          onDoubleTap: (){
            displayBusiness(context, businessList[index]);
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    height: 125.0,
                    width: 275.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                            height: 90.0,
                            width: 80.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    topLeft: Radius.circular(10.0)),
                                image: DecorationImage(
                                    image: (businessList[index]['imageUrl'] != null) ? NetworkImage(businessList[index]['imageUrl']) : AssetImage("assets/business.png"),
                                    fit: BoxFit.cover)
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  businessList[index].data()['name'],
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  businessList[index].data()['address'],
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  width: 150.0,
                                  child: Text(
                                    businessList[index].data()['type'],
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              ])
                        ]))))
          ])
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _showRadiusSlider()  {
      showModalBottomSheet(context: context,
          isDismissible: false,
          enableDrag: false,
          builder: (BuildContext c) {
            return StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  double meters = _selectedRadius*1000;
                  var _radiusLabel = meters.toInt().toString();
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0
                          ),
                          child: Text('Please select the distance in meters!'),
                        ),
                        SizedBox(height: 40),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.blueAccent,
                            inactiveTrackColor: Color(0xFF8D8E98),
                            thumbColor: Color(0xFF2196F3),
                            thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 15),
                            overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 30.0),
                            overlayColor: Color(0x29EB1555),
                            showValueIndicator: ShowValueIndicator.always,
                          ),
                          child: Slider(
                              value: _selectedRadius,
                              min: 0,
                              max: 4,
                              divisions: 20,
                              label: 'Radius ${_radiusLabel}m',
                              onChanged:
                                  (val) {
                                setState(() {
                                  _selectedRadius = val;
                                });
                              }
                          ),
                        ),
                        Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                  label: Text("Accommodation"),
                                  clipBehavior: Clip.hardEdge,
                                  selected: _isAccommodation,
                                  selectedColor: Colors.lightBlue,
                                  showCheckmark: true,
                                  onSelected: (value) {
                                    setState(() {
                                      _isAccommodation = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                  label: Text("Food & Beverages"),
                                  clipBehavior: Clip.hardEdge,
                                  selected: _isRestaurant,
                                  selectedColor: Colors.lightBlue,
                                  showCheckmark: true,
                                  onSelected: (value) {
                                    setState(() {
                                      _isRestaurant = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                  label: Text("Travel & Tourism"),
                                  clipBehavior: Clip.hardEdge,
                                  selected: _isAttraction,
                                  selectedColor: Colors.lightBlue,
                                  showCheckmark: true,
                                  onSelected: (value) {
                                    setState(() {
                                      _isAttraction = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FilterChip(
                                  label: Text("Entertainment"),
                                  clipBehavior: Clip.hardEdge,
                                  selected: _isEntert,
                                  selectedColor: Colors.lightBlue,
                                  showCheckmark: true,
                                  onSelected: (value) {
                                    setState(() {
                                      _isEntert = value;
                                    });
                                  },
                                ),
                              ),
                            ]
                        ),
                        ElevatedButton(
                          child: Text(
                            'Apply',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _startQuery();
                          },
                        ),
                      ],
                    ),
                  );
                });
          }
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Map View"),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  }
              )
            ]
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialcameraposition,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controllerGM.complete(controller);
                controller.setMapStyle('[{"featureType": "poi", "stylers": [{"visibility": "off"}]}]');
                newGMController = controller;
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              markers: markers,
              circles: circles,
            ),
            Positioned(
              top: 10,
              right: 60,
              left: 15,
              child: Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchBox()),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          child: Text(
                              Provider.of<AppData>(context).userAddressLoc != null
                                  ? Provider.of<AppData>(context).userAddressLoc.placeName
                                  : "Set your location..."
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: getAddressPos,
                          iconSize: 30.0),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 5,
              child: Container(
                height: 50,
                width: 50,
                child:  CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: TextButton(
                      child: Text('RD'),
                      onPressed: (){ Provider.of<AppData>(context, listen: false).userAddressLoc == null
                          ? Fluttertoast.showToast(msg: 'Please set your position first!', toastLength: Toast.LENGTH_SHORT)
                          : _showRadiusSlider();
                      }
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              right: 5,
              child: Container(
                child: FloatingActionButton(
                  child: Icon(Icons.location_searching),
                  onPressed: () {
                    getCurrPos();
                  },
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height - 250,
              left: 10.0,
              right: 55.0,
              child:
              Container(
                height: 125.0,
                width: MediaQuery.of(context).size.width,
                child: areCardsToggled ?
                PageView.builder(
                  itemCount: businessList.length,
                  controller: _pageContr,
                  itemBuilder: (BuildContext context, int index){
                    return _businessList(index);
                  },
                ): Container(
                  height: 1.0,
                  width: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}