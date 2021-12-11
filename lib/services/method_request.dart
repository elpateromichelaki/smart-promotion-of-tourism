import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:smart_promotion_of_tourism/data_handler/app_data.dart';
import 'package:smart_promotion_of_tourism/models/address.dart';
import 'package:smart_promotion_of_tourism/services/request.dart';

class MethodRequest{
  static Future<String> serchCoordsAddr(Position p, context) async{
    String placeAddress = "";

    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${p.latitude},${p.longitude}&key=AIzaSyBgoPoV6jsbxhsJAV1Pt0jkCNPjtYbOWKA";
    var response = await Request.getRequest(Uri.parse(url));

    if(response != "Failed"){
      placeAddress = response["results"][0]["formatted_address"];

      Address userAddress = new Address();
      userAddress.latitude = p.latitude;
      userAddress.longitude = p.longitude;
      userAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updateUserAddress(userAddress);

    }
    return placeAddress;
  }

}