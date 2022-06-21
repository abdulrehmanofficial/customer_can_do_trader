import 'dart:io';

import 'package:can_do_customer/Screens/login_screen.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:can_do_customer/network/api_request.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final User? userDate;
   const EditProfile(this.userDate,{Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  File? file;
  bool isLoading = false;
  String loginType = "";
  String _firstName = "";
  String _lastName = "";
  String _address = "";
  String _mobile = "";
  String _user_id = "";

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  User? userDate;

  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  void getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      print(user);
      setState(() {
        userDate = user;
        // _firstName = userDate!.firstName.toString();
        // _lastName = userDate!.lastName.toString();
        // _address = userDate!.address.toString();
        // _mobile = userDate!.mobile.toString();
        fnameController = TextEditingController(text:  userDate!.firstName.toString());
        lnameController = TextEditingController(text: userDate!.lastName.toString());
        addressController = TextEditingController(text: userDate!.address.toString());
        mobileController = TextEditingController(text:  userDate!.mobile.toString());
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Profile"),
        // leading: Text(""),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(children: [
            Stack(
              children: [
                Center(
                  child: file != null ?
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: MediaQuery.of(context).size.height/7,width: MediaQuery.of(context).size.height/7,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54,width: 5),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height),
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: FileImage(file!)
                        )
                    ),
                  ):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.network(
                          widget.userDate?.image??"",
                          width: 100,
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: (MediaQuery.of(context).size.width/2)-(MediaQuery.of(context).size.height/11),
                  top: MediaQuery.of(context).size.height/50,
                  child: InkWell(
                    onTap: ()=> pickImage(),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width),
                      ),
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsetsDirectional.only(top: 10),
              child: TextFormField(
                controller: fnameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (input) {
                  if (input!.isEmpty) {
                    return ' Please enter first name';
                  }
                },
                onSaved: (input) => _firstName = input!,
                onEditingComplete: () {},
                decoration: InputDecoration(labelText: "First Name"),
              ),
            ),Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsetsDirectional.only(top: 10),
              child: TextFormField(
                controller: lnameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (input) {
                  if (input!.isEmpty) {
                    return ' Please enter last name';
                  }
                },
                onSaved: (input) => _lastName = input!,
                onEditingComplete: () {},
                decoration: InputDecoration(labelText: "Last Name"),
              ),
            ),Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsetsDirectional.only(top: 10),
              child: TextFormField(
                controller: addressController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (input) {
                  if (input!.isEmpty) {
                    return ' Please enter address';
                  }
                },
                onSaved: (input) => _address = input!,
                onEditingComplete: () {},
                decoration: InputDecoration(labelText: "Address"),
              ),
            ),Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              padding: EdgeInsetsDirectional.only(top: 10),
              child: TextFormField(
                controller: mobileController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (input) {
                  if (input!.isEmpty) {
                    return ' Please enter mobile number';
                  }

                },
                keyboardType: TextInputType.phone,
                onSaved: (input) => _mobile = input!,
                onEditingComplete: () {},
                decoration: InputDecoration(labelText: "Mobile Number"),
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
                    doUpdate();
                  }
                },
                 style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,),
                child: Text(
                  "Update Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : const CircularProgressIndicator()
          ],),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    ImagePicker _imagePicker = ImagePicker();
    try {
      XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
      setState(() {

      });
    } catch (e) {
      debugPrint('EditProfile.pickImage: $e');
      file = null;
    }
  }

  doUpdate(){
    ApiRequest().editProfile(_firstName, _lastName,_address,_mobile,file,userDate?.id??"0").then((user) {
      if (user!.status == "true") {
        if (user.approvedStatus == "1") {
          /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabsPage()),
                (Route<dynamic> route) => false,
          );*/
          Constants().showAlert("Profile Updates successfully");
        } else {
          Constants().showAlert("Profile is under review");
          Constants().logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
          );
        }
      } else {
        Constants().showAlert(user.message ?? "Invalid email or password");
      }
      setState(() {
        isLoading = false;
      });
    });
  }

}
