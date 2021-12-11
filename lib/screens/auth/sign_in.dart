import 'package:flutter/material.dart';
import 'package:smart_promotion_of_tourism/services/auth_services.dart';
import 'package:smart_promotion_of_tourism/shared/loading.dart';
import '../wrapper.dart';


class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}
class SignInState extends State<SignIn> {
  final AuthServices _auth = AuthServices();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  bool loading = false;
  String error = '';


  Widget _buildEmail() {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 16.0),
        child: TextFormField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  )
              )
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return 'Email is required';
            }

            if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
              return 'Please enter a valid email address';
            }

            return null;
          },
          onChanged: (String value) {
            email = value;
          },
        )
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_rounded),
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                )
            )
        ),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        onChanged: (String value) {
          password = value;
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Text(
                    'Sign in to MyBusiness!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                _buildEmail(),
                _buildPassword(),
                SizedBox(height: 50),
                ElevatedButton(
                    child: Text(
                      'Login!',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signIn(email, password);
                        if(result == null) {
                          loading = false;
                          setState(() => error = "Please try again!");
                        }else{
                          loading = false;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Wrapper()),
                          );
                        }
                      }
                    }
                ),
                SizedBox(height: 15),
                Text(error,
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}

