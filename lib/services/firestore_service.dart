import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Entries>> getAllEntries() async {
    var ref = _db.collection('entries');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((e) => e.data()); // iterable map
    var entries = data.map((json) => Entries.fromJson(json));
    log("Let's see :::: ${entries.toList().length}");
    return entries.toList();
  }

  //getting user info according to the logged in user
  Future<UserModel> getUserInfo() async {
    var ref = _db.collection('users').doc();
    var snapshot = await ref.get(); //returns dynamic map
    return UserModel.fromJson(
        snapshot.data() ?? {}); // converting into our Users model.
  }

  final String? uid;
  FirestoreService({this.uid});

  Future<void> updateUserInfo(String id, String name, String type, String email,
      String password) async {
    var ref = _db.collection('users').doc(uid);
    var data = {
      'id': uid,
      'log': "${DateTime.now()}",
      'name': name,
      'type': type,
      'email': email,
      'password': password,
    };
    return ref
        .set(data, SetOptions(merge: true))
        .then((value) => log('Updated'))
        .catchError((error) => log("Failed to add entry: $error"));
  }

  Future<void> addGaadi(String gaadiID, int seats, String? entryID) {
    //gaadiId is gaadi platenumber
    var user = AuthService().user!;
    var ref = _db.collection('gaadi').doc(gaadiID);
    if (entryID == "" || entryID!.isEmpty) {
      Map<String, dynamic> data = {
        "addedBy": user.uid,
        "gaadiID": gaadiID,
        "log": DateTime.now().toIso8601String(),
        "seats": seats,
      };
      return ref
          .set(data, SetOptions(merge: true))
          .then((value) => log('Updated Gaadi!!'))
          .catchError((error) => log("Failed to add entry: $error"));
    } else {
      Map<String, dynamic> data = {
        "addedBy": user.uid,
        "entries": [
          {"entryID": entryID},
        ],
        "gaadiID": gaadiID,
        "log": DateTime.now().toIso8601String(),
        "seats": seats,
      };

      return ref
          .set(data, SetOptions(merge: true))
          .then((value) => log('Updated Gaadi with new entry!!'))
          .catchError((error) => log("Failed to add entry: $error"));
    }
  }

  Future<void> addEntries(String entryID, int amount, String category,
      bool isIncome, String remarks, String gaadiID) {
    var user = AuthService().user!;
    var ref = _db.collection('entries').doc(entryID);

    var data = {
      'addedBy': user.uid,
      'entryID': entryID,
      // 'entryLog': DateFormat.yMd().format(DateTime.now()),
      'entryLog': DateTime.now().toString(),
      'details': {
        'amount': amount,
        'category': category,
        'isIncome': isIncome,
        'remarks': remarks,
      },
      'gaadiID': gaadiID,
    };
    return ref
        .set(data, SetOptions(merge: true))
        .then((value) => log('Updated'))
        .catchError((error) => log("Failed to add entry: $error"));
  }

  //*getting Stream of gaadi according to user
  Stream<List<Gaadi>> streamAllGaadi() {
    var stream = _db
        .collection('gaadi')
        .where("addedBy", isEqualTo: uid.toString())
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Gaadi.fromJson(e.data()),
            )
            .toList());
    log(stream.toString());
    return stream;
  }

  Stream<List<Entries>> streamAllEntries() {
    var stream = _db
        .collection('entries')
        .where("addedBy", isEqualTo: uid)
        .orderBy('entryLog', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Entries.fromJson(e.data())).toList());
    log(stream.toString());
    return stream;
  }
}
