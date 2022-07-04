import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/services/auth_service.dart';

import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';

import 'package:ionicons/ionicons.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({Key? key}) : super(key: key);

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  var selectedGaadi = "";

  final _formKey = GlobalKey<FormState>();

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
    String category = "Banking Transaction";
    String remarks = "Kista for gaadi ";
    int amt = 99999;
    bool isIncome = true;
    bool isFreshEntry = false;
    String entryID = "entry20";
    String gaadiID = "Na 7 kha 1448";

    Details details = Details(
      amount: amt,
      category: category,
      isIncome: isIncome,
      remarks: remarks,
    );

    Entries entry = Entries(
      addedBy: AuthService().user!.uid,
      entryID: entryID,
      entryLog: "${DateTime.now()}",
      gaadiID: gaadiID,
      details: details,
    );

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                buildEntryForm(isFreshEntry, entry);
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

  buildEntryForm(bool isFreshEntry, Entries entry) {
    return showDialog(
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.account_box),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            icon: Icon(Icons.message),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text("Save"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await FirestoreService().addEntry(entry);
                                await FirestoreService()
                                    .updateTransaction(isFreshEntry, entry);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
