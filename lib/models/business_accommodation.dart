import 'package:flutter/material.dart';
class BusinessAccommodation{
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
  String email;
  String website;
  String tripAdvisor;
  int rooms;
  int price;
  String currency;
  String description;
  String imageUrl;


  BusinessAccommodation({
    @required this.position,
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.address,
    this.phoneDialingCode,
    this.phone,
    this.rooms,
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
  BusinessAccommodation.withId({
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.address,
    this.phoneDialingCode,
    this.phone,
    this.rooms,
    this.price,
    this.currency,
    this.description,
    this.imageUrl,
    @required this.uid,
    @required this.type,
    @required this.name,
    this.entryId,
    this.email,
    this.website,
    this.tripAdvisor
  });




  Map<String, dynamic> toMap(){
    return {
      'position': position,
      'uid': uid,
      'type': "Accommodation",
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
      'rooms': rooms,
      'price': price,
      'currency': currency,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  static BusinessAccommodation fromMap(Map<String, dynamic> map) {
    if(map == null) return null;

    return BusinessAccommodation(
        position: map['position'] ?? '',
        uid: map['uid'] ?? '',
        type: map['Accommodation'] ?? '',
        name: map['name'] ?? '',
        country: map['country'] ?? '',
        state: map['state'] ?? '',
        city: map['city'] ?? '',
        address: map['address'] ?? '',
        latitude: map['latitude'] ?? '',
        longitude: map['longitude'] ?? '',
        phoneDialingCode: map['phoneDialingCode'] ?? '',
        phone: map['phone'] ?? '',
        email: map['email'] ?? '',
        website: map['website'] ?? '',
        tripAdvisor: map['tripAdvisor'] ?? '',
        rooms: map['rooms'] ?? '',
        price: map['price'] ?? '',
        currency: map['currency'] ?? '',
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? ''
    );
  }

}