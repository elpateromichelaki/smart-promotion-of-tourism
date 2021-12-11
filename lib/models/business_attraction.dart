import 'package:flutter/material.dart';
class BusinessAttraction{
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
  String category;
  int entryFee;
  int visitTime;

  String currency;
  String description;
  String imageUrl;


  BusinessAttraction({
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
    this.entryFee,
    this.visitTime,
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
      'type': "Travel & Tourism",
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
      'category': category,
      'entryFee': entryFee,
      'tripAdvisor': tripAdvisor,
      'visitTime': visitTime,
      'currency': currency,
      'description': description,
      'imageUrl': imageUrl
    };
  }

  static BusinessAttraction fromMap(Map<String, dynamic> map) {
    if(map == null) return null;

    return BusinessAttraction(
        position: map['position'] ?? '',
        uid: map['uid'] ?? '',
        type: map['Travel & Tourism'] ?? '',
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
        entryFee: map['entryFee'] ?? '',
        visitTime: map['visitTime'] ?? '',
        currency: map['currency'] ?? '',
        description: map['description'] ?? '',
        tripAdvisor: map['tripAdvisor'] ?? '',
        imageUrl: map['imageUrl'] ?? ''
    );
  }

}