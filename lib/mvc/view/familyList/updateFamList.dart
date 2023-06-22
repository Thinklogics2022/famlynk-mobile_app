import 'dart:convert';
import 'dart:io';
import 'package:famlynk_version1/constants/constVariables.dart';
import 'package:famlynk_version1/mvc/controller/dropDown.dart';
import 'package:famlynk_version1/mvc/model/famlist_modelss.dart';

import 'package:famlynk_version1/mvc/model/updateFamMember_model.dart';
import 'package:famlynk_version1/mvc/view/familyList/famList.dart';

import 'package:famlynk_version1/services/updateFamList_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateFamList extends StatefulWidget {
  UpdateFamList({super.key, required this.updateMember});

  FamListModel? updateMember;

  @override
  _UpdateFamListState createState() => _UpdateFamListState();
}

class _UpdateFamListState extends State<UpdateFamList> {
  MyProperties myProperties = new MyProperties();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _phNumber = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dateinput = TextEditingController();

  String _selectedGender = '';
  String dropdownValue1 = 'Select Relation';
  String? profilBase64;
  File? _imageFile;
  String userId = "";

  bool validateEmail(String value) {
    const emailRegex = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]";
    final RegExp regex = RegExp(emailRegex);
    return !regex.hasMatch(value);
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
  }

  void _pickImageBase64() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    List<int> imagebyte = await image.readAsBytes();

    profilBase64 = base64.encode(imagebyte);

    final imagetemppath = File(image.path);
    setState(() {
      this._imageFile = imagetemppath;
    });
  }

  @override
  void initState() {
    super.initState();
    _name.text = widget.updateMember!.name.toString();
    _phNumber.text = widget.updateMember!.mobileNo.toString();
    _email.text = widget.updateMember!.email.toString();
    _dateinput.text = widget.updateMember!.dob.toString();
    profilBase64 = widget.updateMember!.image.toString();
    _selectedGender = widget.updateMember!.gender.toString();
    dropdownValue1 = widget.updateMember!.relation.toString();
    UpdateFamListService();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Update Family Member',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    imageprofile(_imageFile),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: '${widget.updateMember!.name.toString()}',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                    ),
                    SizedBox(height: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_add,
                                color: Colors.grey, size: 25),
                            SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'Male',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 6),
                                Text("Male"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'female',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 6),
                                Text("Female"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 'others',
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value!;
                                    });
                                  },
                                ),
                                SizedBox(height: 6),
                                Text("Others"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _dateinput,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          icon: Icon(Icons.calendar_month),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: myProperties.fillColor,
                          filled: true,
                          hintText: '${widget.updateMember!.dob.toString()}',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2500));
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dateinput.text = formattedDate;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _phNumber,
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText:
                              '${widget.updateMember!.mobileNo.toString()}',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: '${widget.updateMember!.email.toString()}',
                          hintStyle: TextStyle(color: Colors.grey[500])),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.people),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText:
                                '${widget.updateMember!.relation.toString()}',
                            hintStyle: TextStyle(color: Colors.grey[500])),
                        dropdownColor: Color.fromARGB(255, 255, 255, 255),
                        value: dropdownValue1,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                        },
                        items: relation
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      child: ElevatedButton(
                          onPressed: () {
                            UpdateFamListService updateFamListService =
                                UpdateFamListService();
                            UpdateFamMemberModel updateFamMemberModel =
                                UpdateFamMemberModel(
                                    name: _name.text,
                                    dob: _dateinput.text,
                                    gender: _selectedGender,
                                    mobileNo: _phNumber.text,
                                    famid: widget.updateMember!.famid,
                                    email: _email.text,
                                    relation: dropdownValue1,
                                    image: profilBase64 ?? "");

                            updateFamListService
                                .putMethod(updateFamMemberModel);
                            print(updateFamMemberModel.name);
                            print(updateFamMemberModel.famid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FamilyList()));
                          },
                          child: Text("Update")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageprofile(File? imageFile) {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: ClipOval(
                  child: _imageFile == null
                      ? Center(
                          child: Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255, 124, 124, 124),
                          size: 140,
                        ))
                      : Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                )),
          ),
        ],
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
            "Choose profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  _pickImageBase64();
                },
                icon: Icon(Icons.image),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
