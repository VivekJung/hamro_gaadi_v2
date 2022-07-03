import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/dateTime_extractor.dart';

import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:intl/intl.dart';

import 'package:ionicons/ionicons.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({Key? key}) : super(key: key);

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  var selectedGaadi = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(child: getBody()),
    );
  }

  getBody() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          //header card
          SizedBox(
            height: 140,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 10, left: 10),
                child:

                    //header row
                    Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Entries and Gaadis",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Icon(Ionicons.search, color: ColorTheme().blackColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        addEntryBtn(),
                        addGaadibtn(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: streamOfAllGaadis(),
          ),
          Expanded(
            child: streamOfAllEntries(),
          ),
        ],
      ),
    );
  }

  addGaadibtn() {
    var gaadiID = "Na 7 kha 1448";
    int seats = 16;
    String entryID = "";
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                FirestoreService().addGaadi(gaadiID, seats, entryID);
              },
              icon: const Icon(
                Icons.car_rental_rounded,
                size: 24,
              ),
            ),
          ),
          const Text('Add new Gaadi'),
        ],
      ),
    );
  }

  addEntryBtn() {
    //TODO: MAKE ADD FORM! and when an entry is added update it into gaadi as well
    String gaadiID = "Ba 4 kha 4747";
    var amount = 200;
    String entryID = "entry9",
        remarks = "Route permit settlement",
        category = "Miscellaneous";
    bool isIncome = false;
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                FirestoreService().addEntries(
                    entryID, amount, category, isIncome, remarks, gaadiID);
              },
              icon: const Icon(
                Icons.add_task,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Text('Add new Entry'),
        ],
      ),
    );
  }

  streamOfAllEntries() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 10),
            child: Text(
              'Recent Entries',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('entries').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return ListView(children: const [
                    ListTile(
                      title: Text(" "),
                      subtitle: Text(" "),
                      trailing: Text(" "),
                    ),
                    Center(child: CircularProgressIndicator()),
                  ]);
                }
                return ListView(
                  children: snapshot.data!.docs.map((e) {
                    return Card(
                      child: ListTile(
                        title: Text(e['details']['category']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e['details']['remarks']),
                            Text((e['entryLog']).toString()),
                          ],
                        ),
                        trailing: Text(e['details']['amount'].toString()),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  streamOfAllGaadis() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 10),
            child: Text(
              'Recent Gaadis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('gaadi').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return ListView(children: const [
                    ListTile(
                      title: Text(" "),
                      subtitle: Text(" "),
                      trailing: Text(" "),
                    ),
                    Center(child: CircularProgressIndicator()),
                  ]);
                }
                return ListView(
                  children: snapshot.data!.docs.map((e) {
                    return Card(
                      child: ListTile(
                        title: Text(e['gaadiID']),
                        subtitle: Text(e['log']),
                        trailing: Text(e['seats'].toString()),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
