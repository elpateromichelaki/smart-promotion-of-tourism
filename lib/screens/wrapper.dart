import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/models/my_user.dart';
import 'package:smart_promotion_of_tourism/screens/auth/auth.dart';
import 'package:provider/provider.dart';
import 'business_view/user_home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    if (user == null) {
      return Auth();
    } else {
      return UserHome();
    }
  }
}