import 'package:can_do_customer/Screens/login_screen.dart';
import 'package:can_do_customer/models/user.dart';
import 'package:can_do_customer/network/constant.dart';
import 'package:flutter/material.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({Key? key}) : super(key: key);

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  User? userData;
  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          // ignore: deprecated_member_use
          // FlatButton(
          //     onPressed: () {},
          //     child: TextButton(
          //       child: Text(
          //         'Logout',
          //         style: TextStyle(
          //             fontFamily: 'Futura', fontSize: 20, color: Colors.white),
          //       ),
          //       onPressed: () {
          //         Constants().logout();
          //         Navigator.pushAndRemoveUntil(
          //           context,
          //           MaterialPageRoute(builder: (context) => LoginScreen()),
          //           (Route<dynamic> route) => false,
          //         );
          //       },
          //     )),
        ],
      ),
      body: ListView(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  userData?.image??"",
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),



            /*CircleAvatar(
                    backgroundImage: NetworkImage(userData!.image!),
                    backgroundColor: Colors.transparent,
                  ),*/

          _firstName(context, "First Name", userData?.firstName ?? "John"),
          _firstName(context, "Last Name", userData?.lastName ?? "Smith"),
          _firstName(context, "Contact Number", userData?.mobile ?? "n/a"),
          _firstName(context, "Email", userData?.email ?? "n/a")
        ],
      ),
    );
  }

  Widget _firstName(BuildContext context, String title, String name) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  void getData() async {
    var user = await Constants().getUserData();
    if (user != null) {
      print(user);
      setState(() {
        userData = user;
      });
    }
  }
}
