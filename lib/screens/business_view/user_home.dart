import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/screens/home.dart';
import 'package:smart_promotion_of_tourism/services/auth_services.dart';
import 'step1_form.dart';
import 'business_screen.dart';


class UserHome extends StatelessWidget {

  final AuthServices _auth = AuthServices();
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        await _auth.logOut();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()));
      },
    );
    Widget noButton = TextButton(
      child: Text(
        'No',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        noButton,
        yesButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Welcome!'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  showAlertDialog(context);
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
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                  child: Text(
                    'Register your business!',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstStep()),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: ElevatedButton(
                  child: Text(
                    'My Business!',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BusinessScreen()));
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
