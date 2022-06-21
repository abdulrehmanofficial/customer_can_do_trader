import 'package:can_do_customer/Screens/forgot_page.dart';
import 'package:can_do_customer/Screens/home_screen.dart';
import 'package:can_do_customer/Screens/registrantion_screen.dart';
import 'package:can_do_customer/Screens/subscription_screen.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:can_do_customer/presentation/tabs/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // String _email, _password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Future<User> _futureUser;
  bool isLoading = false;
  String loginType = "";
  String _email = "";
  String _password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(""),
        leading: Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              _signUp(context),
              _forgetPass(context),
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
              onEditingComplete: () {},
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an password';
                }
              },
              onSaved: (input) => _password = input!,
              decoration: InputDecoration(labelText: "Password "),
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
                        setState(() {
                          isLoading = true;
                        });
                        apiCall();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,),
                    //  style: ElevatedButton.styleFrom(
                    child: Text(
                      "Signin",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : const CircularProgressIndicator()
        ],
      ),
    );
  }

  /// signup

  Widget _signUp(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 0),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Don't have acount?"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RegistrationScreen()));
              },
              child: Text(
                'Create Account',
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///

  // forgot password

  Widget _forgetPass(BuildContext context) {
    return Container(
      height: 70,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ForgotPage()));
        },
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void apiCall(){
    if (_email != "" && _password != "") {
      ApiRequest().signInCall(_email, _password).then((user){
        if (user!.status == "true") {
          if (user.approvedStatus == "1") {
            getSubscritpitonState();
          } else {
            Constants().showAlert("Profile is under review");
          }
        } else {
          Constants().showAlert(user.message ?? "Invalid email or password");
        }
        setState(() {
          isLoading = false;
        });
      }).catchError((onError){
        Constants().showAlert(onError.toString());
      });
      setState(() {
        isLoading = false;
      });
    }
  }

  getSubscritpitonState() async{
    var user = await Constants().getUserData();
    ApiRequest().getSubscription(user?.id??"0").then((status) {
      if (status!) {
        Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => TabsPage()),
              (Route<dynamic> route) => false,);
      } else {
        Navigator.pushAndRemoveUntil(context,   MaterialPageRoute(builder: (context) => SubscriptionScreen()),
              (Route<dynamic> route) => false,);
      }
    }).catchError((onError){
      Constants().showAlert(onError.toString());
    });
  }
}
