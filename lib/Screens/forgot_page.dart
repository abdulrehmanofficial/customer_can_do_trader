import 'package:can_do_customer/Screens/verify_email.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/material.dart';

class ForgotPage extends StatefulWidget {
  // String code;
  // String _email;

  // ForgotPage(this.code, this._email);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotPage> {
  // String _email, _password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Future<User> _futureUser;
  bool isLoading = false;
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Forgot Password"),
        //leading: Text(""),
      ),
      body: Center(
          child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  "assets/images/aclogo.png",
                ),
              ),
              // _actionSheet(context),
              _form(context),
            ],
          ),
        ],
      )),
    );
  }

  /// Form

  Widget _form(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            padding: EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an email';
                }
                if (!input.isValidEmail()) {
                  return 'Email format is not correct';
                }
              },
              onSaved: (input) => _email = input!,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          //   child: TextFormField(
          //     validator: (input) {
          //       if (input!.isEmpty) {
          //         return ' Please enter an password';
          //       }
          //     },
          //     // onSaved: (input) => _password = input,
          //     decoration: InputDecoration(labelText: "Password "),
          //     obscureText: true,
          //   ),
          // ),
          isLoading == false
              ? Container(
                  width: 200,
                  height: 40,
                  margin: EdgeInsetsDirectional.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      final _formState = _globalKey.currentState;

                      if (_formState!.validate()) {
                        _formState.save();
                        // if (loginType == "kitchen") {
                        setState(() {
                          isLoading = true;
                        });
                        apiCall();
                      }
                    },
                     style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : CircularProgressIndicator()
        ],
      ),
    );
  }

  void apiCall() {
    ApiRequest()
        .forgotPassCall(
      _email,
    )
        .then((user) {
      if (user!.status == "true") {
        Constants().showAlert(user.message);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    VerifyEmailPage("${user.code}", _email, false)));
      } else {
        Constants().showAlert(user.message);
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
