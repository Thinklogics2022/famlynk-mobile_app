import 'package:famlynk_version1/mvc/controller/dropDown.dart';
import 'package:famlynk_version1/services/familySevice/mutualService.dart';
import 'package:flutter/material.dart';

import '../../model/familyMembers/famlist_modelss.dart';

class MutualConnection extends StatefulWidget {
  const MutualConnection({super.key, required this.uniqueUserId});
  final String uniqueUserId;
  @override
  State<MutualConnection> createState() => _MutualConnectionState();
}

class _MutualConnectionState extends State<MutualConnection> {
  List<FamListModel> familyLists = [];
  MutualService mutualService = MutualService();

  var isLoaded = false;
  @override
  void initState() {
    super.initState();
    fetchFamilyMembers(widget.uniqueUserId.toString());
  }

  Future<void> fetchFamilyMembers(String uniqueUserId) async {
    if (familyLists.isEmpty) {
      try {
        familyLists = await mutualService.mutualService(uniqueUserId);

        setState(() {
          isLoaded = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }
String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? familyLists.isEmpty
              ? Center(child: Text("No more mutual connections"))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                  ),
                  itemCount: familyLists.length,
                  itemBuilder: (context, index) {
                    final famList = familyLists[index];
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: backgroundColors[
                                      index % backgroundColors.length],
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: famList.image != null
                                      ? CircleAvatar(
                                          radius: 45,
                                          backgroundImage: NetworkImage(
                                              famList.image.toString()),
                                        )
                                      : Center(
                                          child: Text(
                                            famList.name!.isNotEmpty
                                                ? famList.name![0]
                                                    .toUpperCase()
                                                : "?",
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Text(
                                    famList.name.toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        overflow: TextOverflow.ellipsis,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              Text(capitalizeFirstLetter(famList.relation.toString()))
                              
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
