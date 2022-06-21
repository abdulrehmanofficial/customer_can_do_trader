import 'dart:async';

import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:can_do_customer/screens/changepass_page.dart';
import 'package:can_do_customer/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerifyEmailPage extends StatefulWidget {
  String code;
  String _email;
  bool isFromReg = false;
  VerifyEmailPage(this.code, this._email, this.isFromReg);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmailPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _code = "";
  bool isLoading = false;

  Timer? _timer;
  int _start = 90;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body: Center(
          child: Container(
              margin: const EdgeInsets.only(top: 100), child: _form(context))),
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _globalKey,
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification Code sent to: ",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                widget._email,
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            padding: const EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an code';
                }
              },
              onSaved: (input) => _code = input!,
              decoration: const InputDecoration(labelText: "Code"),
            ),
          ),
          isLoading == false
              ? Container(
                  width: 200,
                  height: 40,
                  margin: const EdgeInsetsDirectional.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      final _formState = _globalKey.currentState;

                      if (_formState!.validate()) {
                        _formState.save();

                        if (widget.isFromReg) {
                          fromRegistration();
                        } else {
                          fromForgotPass();
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
              : const CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              if (_start == 0) {
                setState(() {
                  isLoading = true;
                });
                apiCall();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _start == 0
                    ? Text(
                        "Resend Code in: ",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      )
                    : Text(
                        "Resend Code in: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                Text(
                  _start < 10 ? "00:0$_start" : "00:$_start",
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void fromRegistration() {
    if (_code == widget.code) {
      setState(() {
        isLoading = true;
      });
      ApiRequest()
          .emailVerifyCall(
        widget._email,
      )
          .then((user) {
        if (user!.status == "true") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
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
      Constants().showAlert("Invalid Code");
    }
  }

  void fromForgotPass() {
    if (_code == widget.code) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChangePassPage(widget._email)));
    } else {
      Constants().showAlert("Invalid Code");
    }
  }

  /// resend code
  void apiCall() {
    ApiRequest()
        .forgotPassCall(
      widget._email,
    )
        .then((user) {
      if (user!.status == "true") {
        Constants().showAlert("Please check your email for Verification code");
        print(user.code);
        widget.code = "${user.code}";
        _start = 90;
        startTimer();
      } else {
        Constants().showAlert(user.message);
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
