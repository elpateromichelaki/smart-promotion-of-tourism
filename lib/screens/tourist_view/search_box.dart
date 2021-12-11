import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/models/placePredictions.dart';
import 'package:smart_promotion_of_tourism/screens/tourist_view/prediction_tile.dart';
import 'package:smart_promotion_of_tourism/services/request.dart';



class SearchBox extends StatefulWidget {
  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController locationController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];


  void findPlace(String placeName) async{
    if(placeName.length >1){
      String autocompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyBgoPoV6jsbxhsJAV1Pt0jkCNPjtYbOWKA&sessiontoken=1234567890&components=country:gr";
      var res = await Request.getRequest(Uri.parse(autocompleteUrl));

      if(res == "Failed"){
        return;
      }
      if(res["status"] == "OK"){
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }

    }
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Set your location'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 215,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                          0.7, 0.7
                      ),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20.0),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(
                                  0.7, 0.7
                              ),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0
                              ),
                              child: TextFormField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  prefix: Icon(Icons.pin_drop_outlined),
                                  labelText: "Enter an address!",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onChanged: (val){
                                  findPlace(val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (placePredictionList.length > 0)
                  ? Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0
                ),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index){
                    return PredictionTile(placePredictions: placePredictionList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                          height: 1.0,
                          color: Colors.black54,
                          thickness: 1.0
                      ),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
