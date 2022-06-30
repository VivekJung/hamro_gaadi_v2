import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //getting all list of gaadis
  Future<List<Gaadi>> getAllGaadis() async {
    var ref = _db.collection('entires');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((e) => e.data()); // iterable map
    var gaadis = data.map((json) => Gaadi.fromJson(json));
    return gaadis.toList();
  }

  //geting all list of entries
  Future<List<Entries>> getAllEntries() async {
    //getting all data at once and not as stream
    var ref = _db.collection('entires');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((e) => e.data()); // iterable map
    var entries = data.map((json) => Entries.fromJson(json));
    return entries.toList();
  }

  //getting user info according to the logged in user
  Future<User> getUserInfo() async {
    var ref = _db.collection('users').doc(AuthService().user!.uid);
    var snapshot = await ref.get(); //returns dynamic map
    return User.fromJson(
        snapshot.data() ?? {}); // converting into our Users model.
  }

  //updating userid
  //TODO: ADD GAADI AND ENTRIES
  final String uid;
  FirestoreService({required this.uid});
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

  //getting Stream of current user info ... listening real time!
  Stream<User> streamCurrentUserInfo() {
    // using rxdart function  to switch the streams... starting with userStream and swithching
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('users').doc(user.uid);
        return ref.snapshots().map((d) => User.fromJson(d.data()!));
      } else {
        //returning default user info. (we have defined the default values in models)
        return Stream.fromIterable([User()]);
      }
    });
  }

  //*getting Stream of entries
  Stream<List<Entries>> streamAllEntries() {
    var stream = _db.collection('entries').snapshots().map(
        (event) => event.docs.map((e) => Entries.fromJson(e.data())).toList());
    return stream;
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
}
