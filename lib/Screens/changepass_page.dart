import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:can_do_customer/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ChangePassPage extends StatefulWidget {
  String _email;

  ChangePassPage(this._email);

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Future<User> _futureUser;
  bool isLoading = false;
  String _newPass = "";
  String _confirmPass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Change Password"),
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
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an password';
                }
              },
              onSaved: (input) => _newPass = input!,
              decoration: InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an confirm password';
                }
              },
              onSaved: (input) => _confirmPass = input!,
              decoration: InputDecoration(labelText: "Confirm Password"),
              obscureText: true,
            ),
          ),
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

                        if (isValid()) {
                          setState(() {
                            isLoading = true;
                          });
                          ApiRequest()
                              .changePassCall(widget._email, _newPass)
                              .then((user) {
                            if (user!.status == "true") {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             LoginScreen()));
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Constants().showAlert(user.message);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          });
                        } else {
                          Constants().showAlert("Password doesn't match");
                        }
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

  bool isValid() {
    if (_newPass == "" || _confirmPass == "") {
      Constants().showAlert("Please enter both password fields");
      return false;
    }
    if (_newPass != _confirmPass) {
      Constants().showAlert("Password doesn't match");
      return false;
    }
    if (_newPass.length < 8) {
      Constants().showAlert("Minimum password length is 8 characters ");
      return false;
    }
    return true;
  }
}
