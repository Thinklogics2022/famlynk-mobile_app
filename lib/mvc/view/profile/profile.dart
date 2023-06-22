// ignore_for_file: prefer_const_constructors

import 'package:famlynk_version1/mvc/view/addmember/addMember.dart';
import 'package:famlynk_version1/mvc/view/familyList/famList.dart';
import 'package:famlynk_version1/mvc/view/gallery/gallery.dart';
import 'package:famlynk_version1/mvc/view/profile/edit.dart';
import 'package:famlynk_version1/mvc/view/profile/logout.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            offset: Offset(0, 4.0),
                            color: Colors.black38,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/FL04.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 19),
                        Row(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 10.0),
                        Text(
                          "123456789",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        // SizedBox(height: 10.0),
                        Text(
                          email,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfilePage()));
                          },
                          child: Text("Edit Profile"),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        InkWell(
                          child: CustomListTile(
                            icon: Icons.add,
                            text: "Add Family Member",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMember()),
                            );
                          },
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        InkWell(
                          child: CustomListTile(
                            icon: Icons.photo,
                            text: "Gallery",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Gallery()),
                            );
                          },
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        InkWell(
                          child: CustomListTile(
                            icon: Icons.notification_add,
                            text: "Notification",
                          ),
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        InkWell(
                          child: CustomListTile(
                            icon: Icons.family_restroom,
                            text: "Family Members",
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FamilyList()));
                          },
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        InkWell(
                          child: CustomListTile(
                              icon: Icons.account_circle_rounded,
                              text: "User Details"),
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FamlynkLogout()));
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData? icon;
  final String? text;

  CustomListTile({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.green,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            "$text",
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}