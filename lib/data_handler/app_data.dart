import 'package:flutter/cupertino.dart';
import 'package:smart_promotion_of_tourism/models/address.dart';

class AppData extends ChangeNotifier{
  Address userAddressLoc;


  void updateUserAddress(Address userAddress){
    userAddressLoc = userAddress;
    notifyListeners();
  }
}