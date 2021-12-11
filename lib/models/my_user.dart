class MyUser {
  final String uid;
  String fname;
  String lname;
  String email;
  String pwd;

  MyUser({this.uid, this.fname, this.lname, this.email, this.pwd});

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'fname': fname,
      'lname': lname,
      'email': email
    };
  }

  MyUser.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        fname = data['fname'],
        lname = data['lname'],
        email = data['email'];
}
