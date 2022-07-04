import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamro_gaadi/services/auth_service.dart';
import 'package:hamro_gaadi/services/models.dart';

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

  addEntry(Entries entry) async {
    return await _db
        .collection('entries')
        .doc(entry.entryID)
        .set(entry.toJson(), SetOptions(merge: true))
        .then((value) => log('Updated Gaadi with new entry!!'))
        .catchError((error) => log("Failed to add entry: $error"));
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
    return ref.set(data, SetOptions(merge: true)).then((value) {
      log('Updated');
      // updateTransaction(isFreshEntry, entry);
    }).catchError((error) => log("Failed to add entry: $error"));
  }

  Future addToAmountCollection(int amt, bool isIncome, String entryID) async {
    List<Map<String, dynamic>> newAmt = [
      {"amt": amt, "entryID": entryID}
    ];
    Map<String, dynamic> newAmtStatus = {'info': FieldValue.arrayUnion(newAmt)};

    if (isIncome == true) {
      var ref = _db.collection('income').doc("incomeData");
      var snap = await ref.get();
      List getAllData = snap.get('info');

      if (getAllData.contains({"entryID": entryID})) {
        return ref.update({
          "info": FieldValue.arrayRemove(newAmt),
        });
      } else {
        return ref.set(newAmtStatus, SetOptions(merge: true))
          ..then((value) => log('Updated Income with $newAmt'))
              .catchError((error) => log("Failed to add entry: $error"));
      }
    } else {
      var ref = _db.collection('expenses').doc("expenseData");
      return ref.set(newAmtStatus, SetOptions(merge: true))
        ..then((value) => log('Updated Expense with $newAmt'))
            .catchError((error) => log("Failed to add entry: $error"));
    }
  }

  Future updateTransaction(bool isFreshEntry, Entries entry) {
    //this function adds the transaction amount as income or expense and substracts if transaction is not freshentry
    Map<String, dynamic> data = {};
    if (entry.details.isIncome == true) {
      var ref = _db.collection('transaction').doc('income');

      if (isFreshEntry == true) {
        data = {
          'total': FieldValue.increment(entry.details.amount!.toInt()),
        };
      }
      //substracting the amount
      else {
        data = {
          'total': FieldValue.increment(-entry.details.amount!.toInt()),
        };
      }
      return ref.set(data, SetOptions(merge: true)).then((value) => (log(
          'Updated with ${entry.details.amount} fershEntry: $isFreshEntry isIncome: ${entry.details.isIncome}')));
    } else {
      var ref = _db.collection('transaction').doc('expense');
      if (isFreshEntry == true) {
        data = {
          'total': FieldValue.increment(entry.details.amount!.toInt()),
          'entries': FieldValue.arrayUnion([entry.entryID]),
        };
      }
      //substracting the amount
      else {
        data = {
          'total': FieldValue.increment(-entry.details.amount!.toInt()),
        };
      }
      return ref.set(data, SetOptions(merge: true)).then((value) => (log(
          'Updated with ${entry.details.amount!.toInt()} fershEntry: $isFreshEntry isIncome: ${entry.details.isIncome}')));
    }
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

  getSpecificdata(entryID) {
    var col = _db.collection('income');
    var ref = col.where('info', arrayContains: {"entryID": entryID});

    var result = ref
        .get()
        .then((value) => log('Items found: $value '))
        .catchError((error) => log("Failed to add entry: $error"));
    log(result.toString());
    return result;
  }
}
