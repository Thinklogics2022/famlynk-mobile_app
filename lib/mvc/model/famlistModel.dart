import 'dart:convert';

FamListModel famListModelFromJson(String str) => FamListModel.fromJson(json.decode(str));

String famListModelToJson(FamListModel data) => json.encode(data.toJson());

class FamListModel {
    String? famid;
    String? userId;
    String? name;
    String? dob;
    String? image;
    String? relation;
    String? gender;
    String? mobileNo;
    String? email;
    String? uniqueUserId;

    FamListModel({
        this.famid,
        this.userId,
        this.name,
        this.dob,
        this.image,
        this.relation,
        this.gender,
        this.mobileNo,
        this.email,
        this.uniqueUserId,
    });

    factory FamListModel.fromJson(Map<String, dynamic> json) => FamListModel(
        famid: json["famid"],
        userId: json["userId"],
        name: json["name"],
        dob: json["dob"],
        image: json["image"],
        relation: json["relation"],
        gender: json["gender"],
        mobileNo: json["mobileNo"],
        email: json["email"],
        uniqueUserId: json["uniqueUserID"],
    );

    Map<String, dynamic> toJson() => {
        "famid": famid,
        "userId": userId,
        "name": name,
        "dob": dob,
        "image": image,
        "relation": relation,
        "gender": gender,
        "mobileNo": mobileNo,
        "email": email,
        "uniqueUserID": uniqueUserId,
    };
}