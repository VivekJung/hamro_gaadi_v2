import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Entries {
  String? addedBy;
  Details? details;
  String? entryID;
  dynamic entryLog;
  String? gaadiID;

  Entries({
    this.addedBy = "",
    this.details,
    this.entryID = "",
    this.entryLog,
    this.gaadiID = "",
  });

  //making jsonserializable to work
  //1. add @jsonSerializable() on top of each class and now write below factory code
  factory Entries.fromJson(Map<String, dynamic> json) =>
      _$EntriesFromJson(json);
  Map<String, dynamic> toJson() => _$EntriesToJson(this);
  //
  factory Entries.fromDocumentSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> doc}) {
    return Entries(
      addedBy: doc.data()!['addedBy'],
      entryID: doc.data()!['entryID'],
      entryLog: doc.data()!['entryLog'],
      gaadiID: doc.data()!['gaadiID'],
    );
  }
}

@JsonSerializable()
class Details {
  int? amount;
  String? category;
  bool? isIncome;
  String? remarks;

  Details({
    this.amount = 0,
    this.category = "",
    this.isIncome = false,
    this.remarks = "",
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class Gaadi {
  final String addedBy;
  final List<Entries> entries;
  final String log;
  final int seats;
  final String gaadiID;

  Gaadi({
    this.addedBy = "",
    this.entries = const [],
    this.log = "",
    this.seats = 0,
    this.gaadiID = "",
  });
  factory Gaadi.fromJson(Map<String, dynamic> json) => _$GaadiFromJson(json);
  Map<String, dynamic> toJson() => _$GaadiToJson(this);
}

@JsonSerializable()
class UserModel {
  final List<Gaadi> gaadiList;
  final String log;
  final String name;
  final String type;

  UserModel({
    this.gaadiList = const [],
    this.log = "",
    this.name = "",
    this.type = "",
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UsersFromJson(json);
  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
