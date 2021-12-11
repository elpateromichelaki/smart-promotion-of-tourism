import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/mybusiness_list.dart';
import 'step1_form.dart';



class BusinessScreen extends StatefulWidget {
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('MyBusiness'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_business_outlined),
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => FirstStep()));
                }
            )
          ]
      ),
      body: MyBusinessList(),
      floatingActionButton:  FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FirstStep()));
        },
      ),
    );
  }
}
