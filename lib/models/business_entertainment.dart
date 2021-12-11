import 'package:flutter/material.dart';
class BusinessEntertainment{
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
  String description;
  String imageUrl;


  BusinessEntertainment({
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
    this.category,
    this.imageUrl,
    @required this.uid,
    @required this.type,
    @required this.name,
    this.email,
    this.website,
    this.tripAdvisor

  });
  BusinessEntertainment.withId({
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
      'type': "Entertainment",
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
      'tripAdvisor': tripAdvisor,
      'category': category,
      'website': website,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  static BusinessEntertainment fromMap(Map<String, dynamic> map) {
    if(map == null) return null;

    return BusinessEntertainment(
        position: map['position'] ?? '',
        uid: map['uid'] ?? '',
        type: map['Entertainment'] ?? '',
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
        category: map['category'] ?? '',
        tripAdvisor: map['tripAdvisor'] ?? '',
        description: map['description'] ?? '',
        imageUrl: map['imageUrl'] ?? ''
    );
  }

}