import 'package:flutter/material.dart';
class RadiusSelect extends StatefulWidget {
  @override
  _RadiusSelectState createState() => _RadiusSelectState();
}

class _RadiusSelectState extends State<RadiusSelect> {
  final _formKey = GlobalKey<FormState>();
  double selectedRadius = 0.0;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 16.0, horizontal: 16.0
            ),
            child: Text('Please select the distance in Km!'),
          ),
          SizedBox(height: 40),
          Slider(
            value: selectedRadius,
            min: 0.0,
            max: 4000.0,
            divisions: 20,
            label: selectedRadius.round().toString(),
            onChanged: (double value){
              setState(() {
                selectedRadius = value;
              });
            },
          ),
          ElevatedButton(
            child: Text(
              'Apply',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: (){
              Navigator.of(context).pop(selectedRadius);
            },
          ),
        ],
      ),
    );
  }
}
