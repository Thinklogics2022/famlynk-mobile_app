import 'package:cached_network_image/cached_network_image.dart';
import 'package:famlynk_version1/mvc/model/profile_model/profile_model.dart';
import 'package:famlynk_version1/services/profileService/profile_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileUserDetails extends StatefulWidget {
  @override
  _ProfileUserDetailsState createState() => _ProfileUserDetailsState();
}

class _ProfileUserDetailsState extends State<ProfileUserDetails>
    with SingleTickerProviderStateMixin {
  ProfileUserModel profileUserModel = ProfileUserModel();
  ProfileUserService profileUserService = ProfileUserService();
  bool isLoading = true;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _fetchMembers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ImageProvider<Object>? _getProfileImage(ProfileUserModel profileUserModel) {
    if (profileUserModel.profileImage == null ||
        profileUserModel.profileImage!.isEmpty) {
      return AssetImage('assets/images/FL01.png');
    } else {
      return CachedNetworkImageProvider(
          profileUserModel.profileImage.toString());
    }
  }

  _fetchMembers() async {
    try {
      profileUserModel = await profileUserService.fetchMembersByUserId();
      print("img :  ${profileUserModel.profileImage}");
      setState(() {
        isLoading = false;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 233, 240),
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Profile User Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 2,
                        color: const Color.fromARGB(255, 218, 224, 230),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: CircleAvatar(
                                              radius: 55,
                                              backgroundImage: _getProfileImage(
                                                  profileUserModel)),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                                child: Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Colors.deepOrange,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  profileUserModel.name
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              size: 20,
                                              color: Colors.deepOrange,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              profileUserModel.dateOfBirth
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              size: 20,
                                              color: Colors.deepOrange,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              profileUserModel.email.toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.people,
                                              size: 20,
                                              color: Colors.deepOrange,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              profileUserModel.gender
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              size: 20,
                                              color: Colors.deepOrange,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              profileUserModel.mobileNo
                                                  .toString(),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Visibility(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: (profileUserModel
                                                                .maritalStatus !=
                                                            null &&
                                                        profileUserModel
                                                            .maritalStatus!
                                                            .isNotEmpty)
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                            Icons.child_care,
                                                            size: 20,
                                                            color: Colors
                                                                .deepOrange,
                                                          ),
                                                          SizedBox(width: 12),
                                                          Text(
                                                            profileUserModel
                                                                .maritalStatus
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                child: (profileUserModel
                                                                .hometown !=
                                                            null &&
                                                        profileUserModel
                                                            .hometown!
                                                            .isNotEmpty)
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                            Icons.home,
                                                            size: 20,
                                                            color: Colors
                                                                .deepOrange,
                                                          ),
                                                          SizedBox(width: 12),
                                                          Text(
                                                            profileUserModel
                                                                .hometown
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                              SizedBox(height: 12),
                                              Container(
                                                child: (profileUserModel
                                                                .address !=
                                                            null &&
                                                        profileUserModel
                                                            .address!
                                                            .isNotEmpty)
                                                    ? Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_city,
                                                            size: 20,
                                                            color: Colors
                                                                .deepOrange,
                                                          ),
                                                          SizedBox(width: 12),
                                                          Text(
                                                            profileUserModel
                                                                .address
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
