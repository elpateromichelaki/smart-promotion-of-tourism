import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/screens/tourist_view/tourist_home.dart';
import 'package:smart_promotion_of_tourism/screens/wrapper.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Smart Promotion of Tourism'),
      ),
      body: Container(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(24),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                  child: Text(
                    'TouristView!',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MapView()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                  child: Text(
                    'BusinessView!',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Wrapper()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
