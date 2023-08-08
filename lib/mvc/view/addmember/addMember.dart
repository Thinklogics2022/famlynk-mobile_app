import 'dart:io';
import 'package:famlynk_version1/constants/constVariables.dart';
import 'package:famlynk_version1/mvc/controller/dropDown.dart';
import 'package:famlynk_version1/mvc/model/addmember_model/addMember_model.dart';
import 'package:famlynk_version1/mvc/view/navigationBar/navBar.dart';
import 'package:famlynk_version1/services/familySevice/addMember_service.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddMember extends StatefulWidget {
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final firebase_storage.Reference storageRef =
      firebase_storage.FirebaseStorage.instance.ref();
  File? imageFile;
  MyProperties myProperties = new MyProperties();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _phNumber = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _dateinput = TextEditingController();

  String _selectedGender = '';
  String dropdownValue1 = 'Select Relation';
  String? profilBase64;

  String userId = "";

  bool validateEmail(String value) {
    const emailRegex = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]";
    final RegExp regex = RegExp(emailRegex);
    return !regex.hasMatch(value);
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
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
        backgroundColor: const Color.fromARGB(255, 223, 231, 237),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: HexColor('#0175C8'),
          title: Text(
            'Add Member',
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
                    imageprofile(),
                    SizedBox(
                      height: 20,
                    ),
                    buildNameField(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        buildGenderRow('Male'),
                        buildGenderRow('Female'),
                        buildGenderRow('Others'),
                      ],
                    ),
                    SizedBox(height: 15),
                    buildDateOfBirthField(),
                    SizedBox(height: 15),
                    buildPhoneNumberField(),
                    SizedBox(height: 15),
                    buildEmailField(),
                    SizedBox(height: 15),
                    buildRelationDropdown(),
                    SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
          backgroundColor: HexColor('#0175C8')),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
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

  Widget buildNameField() {
    return TextFormField(
      controller: _name,
      decoration: InputDecoration(
          icon: Icon(Icons.person),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: myProperties.fillColor,
          filled: true,
          hintText: 'Enter Name',
          hintStyle: TextStyle(color: Colors.grey[500])),
      validator: (value) {
        if (value!.isEmpty) {
          return '*name is required';
        } else {
          return null;
        }
      },
    );
  }

  Widget buildGenderRow(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value as String;
            });
          },
        ),
        SizedBox(width: 6),
        Text(value),
      ],
    );
  }

  Widget buildDateOfBirthField() {
    return TextFormField(
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
          hintText: 'Date Of Birth',
          hintStyle: TextStyle(color: Colors.grey[500])),
      onTap: _selectDateOfBirth,
      validator: (value) {
        if (value!.isEmpty) {
          return '*dob is required';
        } else {
          return null;
        }
      },
    );
  }

  void _selectDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2500),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dateinput.text = formattedDate;
      });
    }
  }

  Widget buildPhoneNumberField() {
    return TextFormField(
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
          hintText: 'Enter Mobile Number',
          hintStyle: TextStyle(color: Colors.grey[500])),
      validator: (value) {
        if (value!.isEmpty) {
          return "*mobile number is required";
        }
        if (value.length != 10) {
          return "Mobile number must be 10 digits";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
    );
  }

  Widget buildEmailField() {
    return TextFormField(
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
            hintText: 'Enter Email',
            hintStyle: TextStyle(color: Colors.grey[500])),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "*email is required";
          }
          if (validateEmail(value)) {
            return "*valid email is required";
          }
        });
  }

  Widget buildRelationDropdown() {
    return Container(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          icon: Icon(Icons.people),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        value: dropdownValue1,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue1 = newValue!;
          });
        },
        items: relation.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontSize: 15),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (imageFile != null) {
        final storageResult = await storageRef
            .child('profile_images/${_name.text}')
            .putFile(imageFile!);
        final imageUrl = await storageResult.ref.getDownloadURL();

        AddMemberService addMemberService = AddMemberService();
        AddMemberModel addMemberModel = AddMemberModel(
          name: _name.text,
          gender: _selectedGender,
          firstLevelRelation: dropdownValue1,
          relation: dropdownValue1,
          dob: _dateinput.text,
          userId: userId,
          email: _email.text,
          mobileNo: _phNumber.text,
          image: imageUrl,
          // uniqueUserID: ""
        );

        addMemberService.addMemberPost(addMemberModel);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavBar(),
          ),
        );
      }
    }
  }

  Widget imageprofile() {
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 20,
                    color: Colors.blue.withOpacity(0.2),
                    offset: Offset(0, 10),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: imageFile == null
                    ? Center(
                        child: Icon(
                        Icons.person,
                        color: const Color.fromARGB(255, 153, 179, 201),
                        size: 100,
                      ))
                    : Image.file(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
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
                  color: Colors.blue,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
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
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      imageFile = File(pickedImage.path);
                    });
                  }
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















// import 'dart:io';
// import 'package:famlynk_version1/constants/constVariables.dart';
// import 'package:famlynk_version1/mvc/controller/dropDown.dart';
// import 'package:famlynk_version1/mvc/model/addmember_model/addMember_model.dart';
// import 'package:famlynk_version1/mvc/view/navigationBar/navBar.dart';
// import 'package:famlynk_version1/services/familySevice/addMember_service.dart';
// import 'package:flutter/material.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';

// class AddMember extends StatefulWidget {
//   @override
//   _AddMemberState createState() => _AddMemberState();
// }

// class _AddMemberState extends State<AddMember> {
//   final firebase_storage.Reference storageRef =
//       firebase_storage.FirebaseStorage.instance.ref();
//   File? imageFile;
//   MyProperties myProperties = new MyProperties();
//   final _formKey = GlobalKey<FormState>();

//   TextEditingController _name = TextEditingController();
//   TextEditingController _phNumber = TextEditingController();
//   TextEditingController _email = TextEditingController();
//   TextEditingController _dateinput = TextEditingController();

//   String _selectedGender = '';
//   String dropdownValue1 = 'Select Relation';
//   String? profilBase64;

//   String userId = "";

//   bool validateEmail(String value) {
//     const emailRegex = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]";
//     final RegExp regex = RegExp(emailRegex);
//     return !regex.hasMatch(value);
//   }

//   Future<void> fetchData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('userId') ?? '';
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 223, 231, 237),
//         appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.white),
//           backgroundColor: HexColor('#0175C8'),
//           title: Text(
//             'Add Member',
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Container(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     imageprofile(),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     TextFormField(
//                       controller: _name,
//                       decoration: InputDecoration(
//                           icon: Icon(
//                             Icons.person,
//                           ),
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           fillColor: Colors.grey.shade200,
//                           filled: true,
//                           hintText: 'Enter Name',
//                           hintStyle: TextStyle(color: Colors.grey[500])),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return '*name is required';
//                         } else {
//                           return null;
//                         }
//                       },
//                     ),
//                     SizedBox(height: 15),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.person_add,
//                                 color: Colors.grey, size: 25),
//                             SizedBox(
//                               width: 8,
//                             ),
//                             Row(
//                               children: [
//                                 Radio(
//                                   value: 'Male',
//                                   groupValue: _selectedGender,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedGender = value!;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 6),
//                                 Text("Male"),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Radio(
//                                   value: 'female',
//                                   groupValue: _selectedGender,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedGender = value!;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 6),
//                                 Text("Female"),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Radio(
//                                   value: 'others',
//                                   groupValue: _selectedGender,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _selectedGender = value!;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 6),
//                                 Text("Others"),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 15),
//                     TextFormField(
//                       controller: _dateinput,
//                       keyboardType: TextInputType.datetime,
//                       decoration: InputDecoration(
//                           icon: Icon(Icons.calendar_month),
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           fillColor: myProperties.fillColor,
//                           filled: true,
//                           hintText: 'Date Of Birth',
//                           hintStyle: TextStyle(color: Colors.grey[500])),
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(2500));
//                         if (pickedDate != null) {
//                           String formattedDate =
//                               DateFormat('yyyy-MM-dd').format(pickedDate);
//                           setState(() {
//                             _dateinput.text = formattedDate;
//                           });
//                         }
//                       },
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return '*dob is required';
//                         } else {
//                           return null;
//                         }
//                       },
//                     ),
//                     SizedBox(height: 15),
//                     TextFormField(
//                       controller: _phNumber,
//                       decoration: InputDecoration(
//                           icon: Icon(Icons.phone),
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           fillColor: Colors.grey.shade200,
//                           filled: true,
//                           hintText: 'Enter Mobile Number',
//                           hintStyle: TextStyle(color: Colors.grey[500])),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "*mobile number is required";
//                         }
//                         if (value.length != 10) {
//                           return "Mobile number must be 10 digits";
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.phone,
//                     ),
//                     SizedBox(height: 15),
//                     TextFormField(
//                       controller: _email,
//                       decoration: InputDecoration(
//                           icon: Icon(Icons.email),
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade400),
//                           ),
//                           fillColor: Colors.grey.shade200,
//                           filled: true,
//                           hintText: 'Enter Email',
//                           hintStyle: TextStyle(color: Colors.grey[500])),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return "*email is required";
//                         }
//                         if (validateEmail(value)) {
//                           return "*valid email is required";
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       child: DropdownButtonFormField(
//                         decoration: InputDecoration(
//                             icon: Icon(Icons.people),
//                             enabledBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(color: Colors.grey.shade400),
//                             ),
//                             fillColor: Colors.grey.shade200,
//                             filled: true,
//                             hintStyle: TextStyle(color: Colors.grey[500])),
//                         dropdownColor: Color.fromARGB(255, 255, 255, 255),
//                         value: dropdownValue1,
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             dropdownValue1 = newValue!;
//                           });
//                         },
//                         items: relation
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(fontSize: 15),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     SizedBox(height: 35),
//                     Container(
//                       child: ElevatedButton(
//                         onPressed: _submitForm,
//                         child: Text(
//                           'Submit',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (imageFile != null) {
//         final storageResult = await storageRef
//             .child('profile_images/${_name.text}')
//             .putFile(imageFile!);
//         final imageUrl = await storageResult.ref.getDownloadURL();

//         AddMemberService addMemberService = AddMemberService();
//         AddMemberModel addMemberModel = AddMemberModel(
//           name: _name.text,
//           gender: _selectedGender,
//           relation: dropdownValue1,
//           dob: _dateinput.text,
//           userId: userId,
//           email: _email.text,
//           mobileNo: _phNumber.text,
//           image: imageUrl,
//           // uniqueUserID: ""
//         );

//         addMemberService.addMemberPost(addMemberModel);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => NavBar(),
//           ),
//         );
//       }
//     }
//   }

//   Widget imageprofile() {
//     return Center(
//       child: Stack(
//         children: <Widget>[
//           Container(
//               width: 130,
//               height: 130,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 4,
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     spreadRadius: 2,
//                     blurRadius: 20,
//                     color: Colors.blue.withOpacity(0.2),
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//                 shape: BoxShape.circle,
//               ),
//               child: ClipOval(
//                 child: imageFile == null
//                     ? Center(
//                         child: Icon(
//                         Icons.person,
//                         color: const Color.fromARGB(255, 153, 179, 201),
//                         size: 100,
//                       ))
//                     : Image.file(
//                         imageFile!,
//                         fit: BoxFit.cover,
//                       ),
//               )),
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: InkWell(
//               onTap: () {
//                 showModalBottomSheet(
//                   context: context,
//                   builder: ((builder) => bottomSheet()),
//                 );
//               },
//               child: Container(
//                 height: 40,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     width: 4,
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                   ),
//                   color: Colors.blue,
//                 ),
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bottomSheet() {
//     return Container(
//       height: 100,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 20,
//       ),
//       child: Column(
//         children: <Widget>[
//           Text(
//             "Choose profile photo",
//             style: TextStyle(
//               fontSize: 20.0,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               IconButton(
//                 onPressed: () async {
//                   final picker = ImagePicker();
//                   final pickedImage =
//                       await picker.pickImage(source: ImageSource.gallery);
//                   if (pickedImage != null) {
//                     setState(() {
//                       imageFile = File(pickedImage.path);
//                     });
//                   }
//                 },
//                 icon: Icon(Icons.image),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
