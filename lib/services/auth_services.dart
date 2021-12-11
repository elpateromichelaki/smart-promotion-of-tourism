import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/models/my_user.dart';
import 'db_services.dart';

class AuthServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DbService _dbService = DbService();
  MyUser _currentUser;
  MyUser get currentUser => _currentUser;

  currUser() {
    final User user = _auth.currentUser;
    final uid = user.uid.toString();
    return uid;
  }
  Future signIn(String email, String pwd) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      User user = result.user;
      return _firebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  Future<String> getCurrentUID() async{
    final User user = await _auth.currentUser;
    final String uid = user.uid;
    return uid;
  }

  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  MyUser _firebaseUser(User user){
    return user != null ? MyUser(uid: user.uid) : null;
  }


  Future register({
    @required String email,
    @required String pwd,
    @required String fname,
    @required String lname
  }) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
      _currentUser = MyUser(
        uid: result.user.uid,
        email: email,
        pwd: pwd,
        fname: fname,
        lname: lname,
      );

      await _dbService.createUser(_currentUser);
      return result.user != null;
    }catch(e){
      print(e.toString());
      return null;
    }
  }


  Future logOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}