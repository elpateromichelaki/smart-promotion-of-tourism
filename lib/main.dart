import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:smart_promotion_of_tourism/models/my_user.dart';
import 'package:smart_promotion_of_tourism/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_promotion_of_tourism/services/auth_services.dart';
import 'data_handler/app_data.dart';

void main() async{
  //debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(value: AuthServices().user,
            initialData: null),
        ChangeNotifierProvider(create: (context) => AppData())
      ],
      child: MaterialApp(
        title: 'Smart Promotion of Tourism',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}
