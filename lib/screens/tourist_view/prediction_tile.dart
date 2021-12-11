import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smart_promotion_of_tourism/data_handler/app_data.dart';
import 'package:smart_promotion_of_tourism/models/address.dart';
import 'package:smart_promotion_of_tourism/models/placePredictions.dart';
import 'package:smart_promotion_of_tourism/services/request.dart';



class PredictionTile extends StatelessWidget {

  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}): super(key: key);
  void getPlaceAddressInfo(String placeId, context) async{

    String placeAddressUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyBgoPoV6jsbxhsJAV1Pt0jkCNPjtYbOWKA";
    var res =  await Request.getRequest(Uri.parse(placeAddressUrl));


    if(res == "Failed"){
      return;
    }
    if(res["status"] == "OK"){
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];


      Provider.of<AppData>(context, listen: false).updateUserAddress(address);
      print(address.placeName);
      print(address.longitude);
      print(address.latitude);
      Navigator.pop(context, address);
      Fluttertoast.showToast(msg: 'Please tap the search icon', toastLength: Toast.LENGTH_LONG);


    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        getPlaceAddressInfo(placePredictions.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(placePredictions.main_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 3.0,),
                      Text(placePredictions.secondary_text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0,
                            color: Colors.grey),),

                    ],
                  ),
                )
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }
}
