import 'package:famlynk_version1/mvc/model/suggestion_model.dart';
import 'package:famlynk_version1/mvc/view/suggestion/personal_detials.dart';
import 'package:famlynk_version1/services/suggestion_services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  late List<Suggestion> suggestionlist = [];
  var isLoaded = false;
  String currentQuery = '';
  List<Suggestion> filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    fetchSuggestions();
  }

  Future<void> fetchSuggestions() async {
    SuggestionService suggestionService = SuggestionService();
    if (suggestionlist.isEmpty) {
      try {
        suggestionlist = await suggestionService.getSuggestions();
        setState(() {
          isLoaded = true;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 228, 237),
      appBar: AppBar(
        backgroundColor: HexColor('#0175C8'),
        title: Text(
          'Suggestions',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchSuggestions(),
        builder: (context, data) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (value) {
                        setState(() {
                          currentQuery = value;
                          filteredSuggestions = suggestionlist
                              .where((suggestion) => suggestion.name
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          hintText: "Search",
                          suffixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(),
                          ))),
                  suggestionsCallback: (pattern) async {
                    return suggestionlist
                        .where((suggestion) => suggestion.name
                            .toString()
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/apple.png"),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(suggestion.name.toString()),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailsPage(
                                  name: suggestion.name.toString(),
                                  gender: suggestion.gender.toString(),
                                  address: suggestion.address.toString(),
                                  dateOfBirth:
                                      suggestion.dateOfBirth.toString(),
                                  email: suggestion.email.toString(),
                                  hometown: suggestion.hometown.toString(),
                                  maritalStatus:
                                      suggestion.maritalStatus.toString(),
                                  // profileImage:
                                  //     suggestion.profileImage.toString(),
                                  uniqueUserID:
                                      suggestion.uniqueUserID.toString(),
                                  mobileNo: suggestion.mobileNo.toString(),
                                )));
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuery.isEmpty
                      ? suggestionlist.length
                      : filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = currentQuery.isEmpty
                        ? suggestionlist[index]
                        : filteredSuggestions[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserDetailsPage(
                                      name: suggestion.name.toString(),
                                      gender: suggestion.gender.toString(),
                                      address: suggestion.address.toString(),
                                      dateOfBirth:
                                          suggestion.dateOfBirth.toString(),
                                      email: suggestion.email.toString(),
                                      hometown: suggestion.hometown.toString(),
                                      maritalStatus:
                                          suggestion.maritalStatus.toString(),
                                      // profileImage:
                                      //     suggestion.profileImage.toString(),
                                      uniqueUserID:
                                          suggestion.uniqueUserID.toString(),
                                      mobileNo: suggestion.mobileNo.toString(),
                                    )));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/apple.png"),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(suggestion.name.toString()),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
