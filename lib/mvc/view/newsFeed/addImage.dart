import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:famlynk_version1/services/newsFeedService/newsFeed_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddImagePage extends StatefulWidget {
  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final TextEditingController _descriptionController = TextEditingController();
  String userId = '';
  String name = '';
  String uniqueUserID = '';
  bool uploading = false;
  late CollectionReference imgRef;
  List<File> _imagesFile = [];
  late Reference ref;
  final picker = ImagePicker();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      name = prefs.getString('name') ?? '';
      uniqueUserID = prefs.getString('uniqueUserID') ?? '';
    });
  }

  void _postNewsFeed() async {
    if (uploading) return;

    setState(() {
      uploading = true;
    });

    String photo = '';
    if (_imagesFile.isNotEmpty) {
      final imageFile = _imagesFile.first;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      photo = await taskSnapshot.ref.getDownloadURL();
    }

    String profilePicture = 'assets/images/FL03.png';
    String description = _descriptionController.text;

    Map<String, dynamic> postData = {
      'userId': userId,
      'name': name,
      'profilePicture': profilePicture,
      'uniqueUserID': uniqueUserID,
      'photo': photo,
      'description': description,
    };

    NewsFeedService newsFeedService = NewsFeedService();

    try {
      await newsFeedService.postNewsFeed(postData);
      Navigator.pop(context);
    } catch (error) {
      setState(() {
        uploading = false;
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Image'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                    ),
                    SizedBox(width: 10),
                    Text("${name}"),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(hintText: 'Description'),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: _postNewsFeed,
                      child: uploading
                          ? CircularProgressIndicator()
                          : Icon(Icons.send_sharp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.deepOrange,
                  child: _imagesFile.isNotEmpty
                      ? Image.file(
                          _imagesFile.first,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                label: Text('Camera'),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                label: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imagesFile.clear();
        _imagesFile.add(File(pickedFile.path));
      });
    }
  }
}
