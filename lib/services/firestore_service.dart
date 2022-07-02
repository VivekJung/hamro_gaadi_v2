import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

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

  // Stream<List<Entries>> streamAllEntries() {
  //   var ref = _db.collection('entries').snapshots();
  //   return ref;
  // }

  //getting user info according to the logged in user
  Future<UserModel> getUserInfo() async {
    var ref = _db.collection('users').doc();
    var snapshot = await ref.get(); //returns dynamic map
    return UserModel.fromJson(
        snapshot.data() ?? {}); // converting into our Users model.
  }

  //updating userid

  final String? uid;
  FirestoreService({this.uid});
  Future<void> updateUserInfo(String id, String name, String type, String email,
      String password) async {
    var ref = _db.collection('users').doc(uid);
    var data = {
      'id': uid,
      'log': DateFormat.yMd().format(DateTime.now()),
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
    var user = AuthService().user!;
    var ref = _db.collection('gaadi').doc(gaadiID);
    if (entryID == "" || entryID!.isEmpty) {
      Map<String, dynamic> data = {
        "addedBy": user.uid,
        "gaadiID": gaadiID,
        "log": DateTime.now().toString(),
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
        "log": DateTime.now().toString(),
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
      'entryLog': DateFormat.yMd().format(DateTime.now()),
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

  Future<void> updateEntries(Entries entries, Gaadi gaadi, Details details) {
    var user = AuthService().user!;
    var ref = _db.collection('entries').doc(entries.entryID);

    var data = {
      'addedBy': user.uid,
      'entryID': "${entries.entryID}",
      'entryLog': DateFormat.yMd().format(DateTime.now()),
      'details': {
        'amount': details.amount!.toInt(),
        'category': details.category!.toString(),
        'isIncome': details.isIncome,
        'remarks': details.remarks.toString(),
      }
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
    // final List<Gaadi> gaadiFromFirestore = <Gaadi>[];
    // try {
    //   return _db.collection("gaadi").snapshots().map((g) {
    //     for (final DocumentSnapshot<Map<String, dynamic>> doc in g.docs) {
    //       gaadiFromFirestore.add(Gaadi.fromDocumentSnapshot(doc: doc));
    //       log(doc.toString());
    //     }
    //     log(message)
    //     return gaadiFromFirestore;
    //   });
    // } catch (e) {
    //   log(e.toString());
    //   rethrow;
    // }
  }
}
