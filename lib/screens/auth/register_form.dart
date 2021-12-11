import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_promotion_of_tourism/services/auth_services.dart';
import 'package:smart_promotion_of_tourism/shared/loading.dart';
import '../wrapper.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthServices _auth = AuthServices();

  TextEditingController fnameC = TextEditingController();
  TextEditingController lnameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  String fname;
  String lname;
  String email;
  String password;
  String error = '';
  bool loading = false;


  Widget _buildfName() {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'First Name',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                )
            )
        ),
        controller: fnameC,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String value) {
          if (value.isEmpty) {
            return 'First name is required';
          }

          return null;
        },
        onSaved: (String value) {
          fname = value;
        },
      ),
    );
  }
  Widget _buildlName() {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            labelText: 'Last Name',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                )
            )
        ),
        controller: lnameC,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Last name is required';
          }

          return null;
        },
        onSaved: (String value) {
          lname = value;
        },
      ),
    );
  }


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
          controller: emailC,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
          onSaved: (String value) {
            email = value.trim();
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
        controller: passwordC,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is required';
          } else if (value.length < 8 && !RegExp(r'(?=.*[A-Z])').hasMatch(value) ) {
            return "Password must be at least 8 characters long\n"
                "Password must have at least 1 uppercase letter";
          }
          else if(!RegExp(r'(?=.*[A-Z])').hasMatch(value)){
            return "Password must have at least 1 uppercase letter";
          }
          else if (value.length < 8) {
            return "Password must be at least 8 characters long";
          }
          return null;
        },
        onSaved: (String value) {
          password = value;
        },
      ),
    );
  }

  Widget _buildConfirmPassword(){
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_rounded),
            labelText: 'Confirm your password',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                )
            )
        ),
        controller: confirmpassword,
        keyboardType: TextInputType.text,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String value) {
          if (value.isEmpty) {
            return "Please re-enter new password";
          } else if (value != passwordC.text) {
            return 'Passwords do not match. Please retype them!';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Future signUp({
    @required String email,
    @required String password,
    @required String fname,
    @required String lname
  }) async {


    var result = await _auth.register(
        email: email,
        pwd: password,
        fname: fname,
        lname: lname);


    if(result == null) {
      loading = false;
      setState(() => error = "Invalid email");

    }else {
      loading = false;
      Fluttertoast.showToast(msg: 'Success! Account created.',
          toastLength: Toast.LENGTH_LONG);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );
    }

  }
  @override
  Widget build(BuildContext context) {
    return  loading ? Loading() : Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Sign Up Form")),
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
                    'Create an account!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),
                _buildfName(),
                _buildlName(),
                _buildEmail(),
                _buildPassword(),
                _buildConfirmPassword(),
                SizedBox(height: 50),
                ElevatedButton(
                  child: Text(
                    'Sign Up!',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      setState(() {
                        loading = true;
                      });
                      signUp(email: email, password: password, fname: fname, lname: lname);
                      loading = true;
                    }
                  },
                ),
                SizedBox(height: 15),
                Text(error,
                  style: TextStyle(color: Colors.red),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
