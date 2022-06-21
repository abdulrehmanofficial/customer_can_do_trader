import 'dart:convert';
import 'dart:io';

import 'package:can_do_customer/Screens/login_screen.dart';
import 'package:can_do_customer/Screens/verify_email.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegistrationScreen> {
  String _email = "",
      _password = "",
      _confirm_password = "",
      first_name = "",
      last_name = "",
      _address = "",
      _moobile = "";

  String? lat, lng;
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  String img64 = "";
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Future<User> _futureUser;
  bool isLoading = false;
  String loginType = "";

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sign Up"),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Center(
          child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      //color: Colors.red,
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: _profileImage == null
                        ? Image.asset(
                            "assets/images/aclogo.png",
                          )
                        : CircleAvatar(
                            backgroundImage:
                                FileImage(File(_profileImage!.path)),
                            //child: Image.file(File(_profileImage!.path)),
                            radius: 60.0)),
              ),

              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: const Text(
                  "Upload Photo",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
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
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an first name';
                }
              },
              onSaved: (input) => first_name = input!,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an last name';
                }
              },
              onSaved: (input) => last_name = input!,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
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
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            //padding: EdgeInsetsDirectional.only(top: 10),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an password';
                }
              },
              onSaved: (input) => _password = input!,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an confirm password';
                }
              },
              onSaved: (input) => _confirm_password = input!,
              decoration: const InputDecoration(labelText: "Confirm Password "),
              obscureText: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: phoneNumberView(context),

            // TextFormField(
            //   validator: (input) {
            //     if (input!.isEmpty) {
            //       return ' Please enter an mobile phone';
            //     }
            //   },
            //   onSaved: (input) => _moobile = input!,
            //   decoration: const InputDecoration(labelText: "Mobile Phone"),
            //   keyboardType: TextInputType.phone,
            //   // obscureText: true,
            // ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: TextFormField(
              validator: (input) {
                if (input!.isEmpty) {
                  return ' Please enter an address';
                }
              },
              onSaved: (input) => _address = input!,
              decoration: const InputDecoration(labelText: "Address"),
              //obscureText: true,
            ),
          ),
          isLoading == false
              ? Container(
                  width: MediaQuery.of(context).size.width - 70,
                  height: 40,
            color:Theme.of(context).primaryColor ,
                  margin: const EdgeInsetsDirectional.only(top: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      final _formState = _globalKey.currentState;

                      if (_formState!.validate()) {
                        _formState.save();
                        // if (loginType == "kitchen") {
                        setState(() {
                          isLoading = true;
                        });
                        callApi();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,),
                    child: Text(
                      "SIGN UP NOW",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : CircularProgressIndicator()
        ],
      ),
    );
  }

  /// signup

  Widget _signUp(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        // color: Colors.red,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        // margin: EdgeInsets.symmetric(horizontal: 60, vertical: 0),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Already Registerd?"),
            TextButton(
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
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
      child: Text(
        '',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void callApi() {
    String latitude = lat ?? "0";
    String lngitude = lng ?? "0";
    if (isValid()) {
      ApiRequest()
          .rgisterCall(first_name, last_name, _email, _password,
              "$latitude,$lngitude", _address, _moobile, img64)
          .then((reg) {
        if (reg.status == "true") {
          Constants()
              .showAlert("Please check your email for verification code");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      VerifyEmailPage("${reg.code}", _email, true)));
        } else {
          Constants().showAlert(reg.message);
        }
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isValid() {
    if (first_name == "" ||
        last_name == "" ||
        _email == "" ||
        _password == "" ||
        _confirm_password == "" ||
        _moobile == "" ||
        _address == "") {
      Constants().showAlert("Please enter all fields");

      return false;
    }

    if (_password.length < 8) {
      Constants().showAlert("Minimum password length is 8 characters ");
      return false;
    }

    if (_password != _confirm_password) {
      Constants().showAlert("Password doesn't match");
      return false;
    }
    if (_profileImage == null) {
      Constants().showAlert("Please pick your image");
      return false;
    }

    return true;
  }

  void getCurrentLocation() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    lat = sharedUser.getString('lat');
    lng = sharedUser.getString('lng');
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = image;
    });
  }

// pick Image
  _imgFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = image;
    });
  }

  set _imageFile(XFile? value) {
    _profileImage = value == null ? null : [value].first;
    if (_profileImage != null) {
      final bytes = File(_profileImage!.path).readAsBytesSync();
      img64 = base64Encode(bytes);
      // print(img64);
    }
  }

  // phone number
  Widget phoneNumberView(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        print(number.phoneNumber);
        _moobile = number.phoneNumber!;
      },
      // onInputValidated: (bool value) {
      //   print(value);
      // },
      selectorConfig: SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      ignoreBlank: false,
      // autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: TextStyle(color: Colors.black),
      initialValue: number,
      textFieldController: controller,
      formatInput: false,
      keyboardType:
          TextInputType.numberWithOptions(signed: true, decimal: true),
      //inputBorder: OutlineInputBorder(),
      onSaved: (PhoneNumber number) {
        print('On Saved: $number');
      },
    );
    // ElevatedButton(
    //   onPressed: () {
    //     _globalKey.currentState!.validate();
    //   },
    //   child: Text('Validate'),
    // );
    // ElevatedButton(
    //   onPressed: () {
    //     getPhoneNumber('+15417543010');
    //   },
    //   child: Text('Update'),
    // ),
    // ElevatedButton(
    //   onPressed: () {
    //     formKey.currentState.save();
    //   },
    //   child: Text('Save'),
    // ),
  }
}
