import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/accommodation_stepper_form.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/restaurant_stepper_form.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/attraction_stepper_form.dart';
import 'package:smart_promotion_of_tourism/screens/business_view/simple_stepper_form.dart';

import 'entert_stepper_form.dart';

class FirstStep extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FirstStepState();
  }
}

class FirstStepState extends State<FirstStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //controllers
  TextEditingController otherField = TextEditingController();


  String _selectedRadioTileText;
  int _selectedRadioTile = -1;
  String _otherField;


  validateAnswers() {
    if (_selectedRadioTile == -1) {
      Fluttertoast.showToast(msg: 'Please select one category',
          toastLength: Toast.LENGTH_SHORT);
    } else {
    }
  }


  setSelectedRadioTile(int value) {
    setState(() {
      _selectedRadioTile = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Business Form")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Text(
                          'Register your business!',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Choose category of business:',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0
                      ),
                        child:
                        RadioListTile(
                          value: 1,
                          groupValue: _selectedRadioTile,
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Accommodation",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  child: Icon(
                                    Icons.hotel_rounded,
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          onChanged: (value) {
                            print("Radio Tile pressed $value");
                            setSelectedRadioTile(value);
                          },
                          selected: true,
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0
                      ),
                        child: RadioListTile(
                            value: 2,
                            groupValue: _selectedRadioTile,
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Food & Beverage",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.restaurant,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onChanged: (value) {
                              print("Radio Tile pressed $value");
                              setSelectedRadioTile(value);
                            },
                            selected: true
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0
                      ),
                        child: RadioListTile(
                            value: 3,
                            groupValue: _selectedRadioTile,
                            title:  Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Travel & Tourism",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.attractions,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onChanged: (value) {
                              print("Radio Tile pressed $value");
                              setSelectedRadioTile(value);
                            },
                            selected: true
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0
                      ),
                        child: RadioListTile(
                            value: 4,
                            groupValue: _selectedRadioTile,
                            title:  Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Entertainment",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    child: Icon(
                                      Icons.celebration,
                                      color: Colors.black,
                                      size: 30.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onChanged: (value) {
                              print("Radio Tile pressed $value");
                              setSelectedRadioTile(value);
                            },
                            selected: true
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0
                      ),
                        child: RadioListTile(
                          value: 5,
                          groupValue: _selectedRadioTile,
                          title: Text("Other",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(color: Colors.black,
                                fontSize: 20),),
                          onChanged: (value) {
                            print("Radio Tile pressed $value");
                            setSelectedRadioTile(value);
                          },
                          selected: true,
                        ),
                      ),
                      _selectedRadioTile == 5 ?
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: Text("Please specify the category!",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.business_center_sharp),
                                  labelText: 'Category*',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      )
                                  )
                              ),
                              controller: otherField,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (String val) {

                                if (val.isEmpty) {
                                  return 'Category is required';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                _otherField = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                            child: Text("*The category should be checked first by the administrator.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      )
                          :Container(),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    validateAnswers();
                    if (!_formKey.currentState.validate()) {
                      return 'err';
                    }
                    _formKey.currentState.save();

                    print(_selectedRadioTile);
                    print(_otherField);

                    if(_selectedRadioTile == 1){
                      _selectedRadioTileText = "Accommodation";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccStepperForm()),
                      );
                      Fluttertoast.showToast(msg: 'Please complete the fields required.',
                          toastLength: Toast.LENGTH_LONG);
                    } else if(_selectedRadioTile == 2){
                      _selectedRadioTileText = "Food & Beverages";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResStepperForm()),
                      );
                      Fluttertoast.showToast(msg: 'Please complete the fields required.',
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_selectedRadioTile == 3){
                      _selectedRadioTileText = "Travel & Tourism";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AttrStepperForm()),
                      );
                      Fluttertoast.showToast(msg: 'Please complete the fields required.',
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_selectedRadioTile == 4) {
                      _selectedRadioTileText = "Entertainment";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            EntertStepperForm()),
                      );
                      Fluttertoast.showToast(msg: 'Please complete the fields required.',
                          toastLength: Toast.LENGTH_LONG);
                    }else if(_selectedRadioTile == 5) {
                      _selectedRadioTileText = "simple";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            SimpleStepperForm(otherField: _otherField)),
                      );
                      Fluttertoast.showToast(msg: 'Please complete the fields required.',
                          toastLength: Toast.LENGTH_LONG);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}