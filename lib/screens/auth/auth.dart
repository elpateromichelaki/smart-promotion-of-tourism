import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/screens/auth/register_form.dart';
import 'package:smart_promotion_of_tourism/screens/auth/sign_in.dart';
import 'package:smart_promotion_of_tourism/screens/home.dart';


class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Business View"),
          actions: <Widget>[

            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }
            )
          ]
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Text("An account is required in order to register your business. Please choose one of the following options.")
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                    child: Text(
                      'Already registered. Login!',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => SignIn()
                      ));
                    }
                ),
              ),Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child:
                ElevatedButton(
                    child: Text(
                      'Create an account!',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
