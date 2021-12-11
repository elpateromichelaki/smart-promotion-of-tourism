import 'package:flutter/material.dart';
class BusinessRestaurant{
  var position;
  String uid;
  String entryId;
  String type;
  String name;
  String country;
  String state;
  String city;
  String address;
  double latitude;
  double longitude;
  String phoneDialingCode;
  int phone;
  String tripAdvisor;
  String email;
  String website;
  String category;
  List<int> cuisine;
  int price;
  String currency;
  String description;
  String imageUrl;


  BusinessRestaurant({
    @required this.position,
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.address,
    this.phoneDialingCode,
    this.phone,
    this.category,
    this.cuisine,
    this.price,
    this.currency,
    this.description,
    this.imageUrl,
    @required this.uid,
    @required this.type,
    @required this.name,
    this.email,
    this.website,
    this.tripAdvisor
  });


  Map<String, dynamic> toMap(){
    return {
      'position': position,
      'uid': uid,
      'type': "Food & Beverages",
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneDialingCode': phoneDialingCode,
      'phone': phone,
      'email': email,
      'website': website,
      'tripAdvisor': tripAdvisor,
      'category': category,
      'cuisine': cuisine,
      'price': price,
      'currency': currency,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  static BusinessRestaurant fromMap(Map<String, dynamic> map) {
    if(map == null) return null;

    return BusinessRestaurant(
        position: map['position'] ?? '',
        uid: map['uid'] ?? '',
        type: map['Food & Beverages'] ?? '',
        name: map['name'] ?? '',
        country: map['country'] ?? '',
        state: map['state'] ?? '',
        tripAdvisor: map['tripAdvisor'] ?? '',
        city: map['city'] ?? '',
        address: map['address'] ?? '',
        latitude: map['latitude'] ?? '',
        longitude: map['longitude'] ?? '',
        phoneDialingCode: map['phoneDialingCode'] ?? '',
        phone: map['phone'] ?? '',
        email: map['email'] ?? '',
        website: map['website'] ?? '',
        category: map['category'] ?? '',
        cuisine: map['cuisine'] ?? '',
        price: map['price'] ?? '',
        currency: map['currency'] ?? '',
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? ''
    );
  }

}