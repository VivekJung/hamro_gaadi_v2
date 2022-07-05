import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/services/auth_service.dart';

import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';

import 'package:ionicons/ionicons.dart';

class ListEntriesAndGaadis extends StatefulWidget {
  const ListEntriesAndGaadis({Key? key}) : super(key: key);

  @override
  State<ListEntriesAndGaadis> createState() => _ListEntriesAndGaadisState();
}

class _ListEntriesAndGaadisState extends State<ListEntriesAndGaadis> {
  var selectedGaadi = "";

  int currentStep = 0;

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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) =>
                        AddEntry(entry: entry, isFreshEntry: isFreshEntry)),
                  ),
                );
                // buildEntryForm(isFreshEntry, entry);
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

// Padding(
//               padding: const EdgeInsets.all(8.0),
//               child:

class AddEntry extends StatefulWidget {
  final Entries entry;
  final bool isFreshEntry;
  const AddEntry({Key? key, required this.entry, required this.isFreshEntry})
      : super(key: key);

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  tapped(int step) {
    setState(() => currentStep = step);
  }

  continued() {
    currentStep < 5 ? setState(() => currentStep += 1) : null;
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          state: currentStep >= 0 ? StepState.complete : StepState.disabled,
          title: const Text(
            'Choose a category',
          ),
          content: Row(
            children: [],
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          title: const Text(
            'Is this an income?',
          ),
          content: Card(
            shape: const RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(
                color: Colors.deepOrangeAccent,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.done_rounded),
                    onPressed: () {},
                    label: const Text("Yes, it is"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey, // Background color
                    ),
                    icon: const Icon(Icons.cancel),
                    onPressed: () {},
                    label: const Text("No, it's not"),
                  ),
                ],
              ),
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          state: currentStep >= 2 ? StepState.complete : StepState.disabled,
          title: const Text(
            "Add 'amount'",
          ),
          content: TextFormField(
            autofocus: true,
          ),
        ),
        Step(
          isActive: currentStep >= 3,
          state: currentStep >= 3 ? StepState.complete : StepState.disabled,
          title: const Text(
            "Select your 'Gaadi'",
          ),
          content: SizedBox(
            // width: 200,
            height: 100,
            child: Card(
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.deepOrangeAccent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 60),
                  shrinkWrap: true,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {},
                      label: const Text(
                        "Na 4 Kha, 3232",
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {},
                      label: const Text("Ba 4 Kha, 1678"),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {},
                      label: const Text("Ko 8 Kha, 1347"),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {},
                      label: const Text("Ko 8 Kha, 1347"),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {},
                      label: const Text("Ko 8 Kha, 1347"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 4,
          state: currentStep >= 4 ? StepState.complete : StepState.disabled,
          title: const Text("Add more briefs here"),
          content: TextFormField(
            autofocus: true,
          ),
        ),
        Step(
            isActive: currentStep >= 5,
            state: currentStep >= 5 ? StepState.complete : StepState.disabled,
            title: const Text("Review"),
            content: saveEntrytoDataBase()),
      ];

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  saveEntrytoDataBase() {
    return ElevatedButton(
      child: const Text("Save"),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          //todo: check why it is still saying the entry is true.
          await FirestoreService().addEntry(widget.entry);
          await FirestoreService()
              .updateTransaction(widget.isFreshEntry, widget.entry);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: (() => Navigator.pop(context)),
        child: const Icon(Icons.cancel_sharp),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                const Center(
                  child: Text(
                    "Add a new entry!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    //<-- SEE HERE
                    side: BorderSide(
                      color: ColorTheme().primaryColor,
                    ),
                  ),
                  elevation: 4.0,
                  child: Stepper(
                    type: stepperType,
                    physics: const ClampingScrollPhysics(),
                    currentStep: currentStep,
                    onStepTapped: (step) => tapped(step),
                    onStepContinue: continued,
                    onStepCancel: cancel,
                    steps: getSteps(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
