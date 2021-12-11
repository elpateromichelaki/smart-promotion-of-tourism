import 'package:flutter/material.dart';
class BusinessSimple{
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
  String tripAdvisor;
  String phoneDialingCode;
  int phone;
  String email;
  String website;
  String description;
  String imageUrl;


  BusinessSimple({
    @required this.position,
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.address,
    this.phoneDialingCode,
    this.phone,
    this.description,
    this.imageUrl,
    @required this.uid,
    @required this.type,
    @required this.name,
    this.email,
    this.website,
    this.tripAdvisor
  });
  BusinessSimple.withId({
    @required this.longitude,
    @required this.latitude,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.address,
    this.phoneDialingCode,
    this.phone,
    this.description,
    this.imageUrl,
    @required this.uid,
    @required this.type,
    @required this.name,
    this.entryId,
    this.email,
    this.website,

  });




  Map<String, dynamic> toMap(){
    return {
      'position': position,
      'uid': uid,
      'type': type,
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneDialingCode': phoneDialingCode,
      'phone': phone,
      'tripAdvisor': tripAdvisor,
      'email': email,
      'website': website,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  static BusinessSimple fromMap(Map<String, dynamic> map) {
    if(map == null) return null;

    return BusinessSimple(
        position: map['position'] ?? '',
        uid: map['uid'] ?? '',
        type: map['other'] ?? '',
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
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        tripAdvisor: map['tripAdvisor'] ?? '',
    );
  }

}