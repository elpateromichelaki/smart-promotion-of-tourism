import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_promotion_of_tourism/models/my_user.dart';

class DbService{

  bool isLoggedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      return true;
    }else{
      return false;
    }
  }
  final CollectionReference _usersCollectionReference =
  FirebaseFirestore.instance.collection('users');

  Future createUser(MyUser user) async {
    try {
      await _usersCollectionReference.doc(user.uid).set(user.toJson());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
