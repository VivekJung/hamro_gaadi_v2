import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hamro_gaadi/resources/category_icon.dart';
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

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: ((context) => const AddEntry()),
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
  const AddEntry({
    Key? key,
  }) : super(key: key);

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  final _formKey = GlobalKey<FormState>();

  var amtController = TextEditingController();
  var remarksController = TextEditingController();

  String category = "No category";
  String remarks = "no remarks";
  int amount = 0;
  bool isIncome = true;
  bool isFreshEntry = true;
  String entryID = "";
  String gaadiID = "";
  Entries? entry;
  Details? details;

  int currentStep = 0;
  bool switchValue = true;

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

  String selectedCategory = "";
  bool isCategorySelected = true;
  int _choiceIndex = 0;

  Widget _buildChoiceChips() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: categoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ChoiceChip(
            shape: StadiumBorder(
                side: BorderSide(
                    width: 1, color: Colors.deepOrangeAccent.shade200)),
            label: FittedBox(
              fit: BoxFit.contain,
              child: Row(
                children: [
                  Icon(
                    getCategoryWiseIcon(categoriesList[index]),
                    size: 12,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    categoriesList[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            selected: _choiceIndex == index,
            selectedColor: Colors.deepOrangeAccent.shade100,
            onSelected: (bool selected) {
              setState(() {
                _choiceIndex = selected ? index : 0;
                category = categoriesList[index];
              });
              log("Cateogry selected : " + category);
            },
            backgroundColor: Colors.white,
            labelStyle: const TextStyle(color: Colors.black),
          );
        },
      ),
    );
  }

  bool isGaadiSelected = false;
  List<Step> getSteps() => [
        //1 Category
        Step(
          isActive: currentStep >= 0,
          state: currentStep >= 0 ? StepState.complete : StepState.disabled,
          title: const Text(
            'Choose a category',
          ),
          content: _buildChoiceChips(),
        ),

        //2 Income
        Step(
          isActive: currentStep >= 1,
          state: currentStep >= 1 ? StepState.complete : StepState.disabled,
          title: const Text(
            'Is this an income?',
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Switch(
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.deepOrangeAccent,
                    inactiveTrackColor: Colors.deepOrangeAccent.shade100,
                    value: switchValue,
                    onChanged: (value) {
                      setState(() {
                        isIncome = switchValue = value;
                      });
                      log("VALUE : $value, $switchValue, $isIncome");
                    },
                  ),
                ),
                const SizedBox(height: 20),
                switchValue == true
                    ? const Text("Yes, it is",
                        style: TextStyle(color: Colors.green, fontSize: 22))
                    : const Text("No, it is not ",
                        style: TextStyle(
                            color: Colors.deepOrangeAccent, fontSize: 22)),
              ],
            ),
          ),
        ),
        //3
        Step(
          isActive: currentStep >= 2,
          state: currentStep >= 2 ? StepState.complete : StepState.disabled,
          title: const Text(
            "Add 'amount'",
          ),
          content: Form(
            key: _formKey,
            child: Row(
              children: [
                const Text('NRs '),
                Expanded(
                  child: TextFormField(
                    controller: amtController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autovalidateMode: AutovalidateMode.always,
                    autofocus: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'No amount has been added';
                      }
                      if (val.length < 3) {
                        return 'Amount cannot be less than 3 digits';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(labelText: ''),
                  ),
                ),
              ],
            ),
          ),
        ),
        //4
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
                      onPressed: () {
                        gaadiID = "Na 4 Kha, 3232";
                        showGaadiSnackbarMessage(gaadiID);
                      },
                      label: const Text(
                        "Na 4 Kha, 3232",
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {
                        // setState(() {
                        //   gaadiID = "Ba 4 Kha, 1678";
                        // });
                        gaadiID = "Ba 4 Kha, 1678";
                        showGaadiSnackbarMessage(gaadiID);
                      },
                      label: const Text("Ba 4 Kha, 1678"),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.car_repair),
                      onPressed: () {
                        gaadiID = "Ko 8 Kha, 1347";
                        showGaadiSnackbarMessage(gaadiID);
                      },
                      label: const Text("Ko 8 Kha, 1347"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        //5
        Step(
          isActive: currentStep >= 4,
          state: currentStep >= 4 ? StepState.complete : StepState.disabled,
          title: const Text("Add more briefs here"),
          content: TextFormField(
            autofocus: true,
            controller: remarksController,
            validator: (val) {
              if (val!.isEmpty) {
                return 'No remarks given';
              }
              if (val.length < 3) {
                return 'Please provide more information';
              }

              return null;
            },
            maxLines: 5,
            minLines: 2,
            decoration: const InputDecoration(labelText: 'Briefs and remarks'),
          ),
        ),
        //6
        Step(
            isActive: currentStep >= 5,
            state: currentStep >= 5 ? StepState.complete : StepState.disabled,
            title: const Text("Review"),
            content: saveEntrytoDataBase()),
      ];

  saveEntrytoDataBase() {
    int? a = int.tryParse(amtController.text);
    // log(a.toString());
    entryID = "test2";
    remarks = remarksController.text;
    details = Details(
        amount: a ?? 0,
        category: category,
        isIncome: isIncome,
        remarks: remarks);

    entry = Entries(
      addedBy: AuthService().user!.uid,
      entryID: entryID,
      entryLog: "${DateTime.now()}",
      gaadiID: gaadiID,
      details: details!,
    );
    log("Final Entry Data \n $category, $isIncome, ${amtController.text}, \n $entryID ${remarksController.text}, $gaadiID, $isFreshEntry");
    return ElevatedButton(
      child: const Text("Save"),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          //todo: check why it is still saying the entry is true.
          log(entry!.details.toString());
          await FirestoreService().addEntry(entry!);
          await FirestoreService().updateTransaction(isFreshEntry, entry!);
        } else {
          const snackbar = SnackBar(
            content: Text('Data form is incomplete, please re-check'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
    );
  }

  showGaadiSnackbarMessage(gaadiID) {
    final snackbar = SnackBar(
        content: Text(gaadiID),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                    "Add a new entry",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: ColorTheme().primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0.0,
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

//  final snackbar = SnackBar(
//             content: Row(
//           children: [Icon(icon), const SizedBox(width: 10.0), Text(label)],
//         ));
//         ScaffoldMessenger.of(context).showSnackBar(snackbar);

// Widget _buildChip(String label, IconData icon) {
  //   return ChoiceChip(
  //     selected: isCategorySelected,
  //     onSelected: (bool selected) {
  //       setState(() {
  //         isCategorySelected = selected;
  //       });
  //     },
  //     avatar: CircleAvatar(
  //         radius: 8,
  //         backgroundColor: Colors.white70,
  //         child: Icon(icon, size: 16)),
  //     label: Text(label,
  //         style: TextStyle(color: ColorTheme().blackColor, fontSize: 12)),
  //     selectedColor: Colors.deepOrange.shade100,
  //     backgroundColor: Colors.white,
  //     shape: const StadiumBorder(
  //         side: BorderSide(width: 1, color: Colors.deepOrangeAccent)),
  //     elevation: 2.0,
  //     shadowColor: Colors.grey[60],
  //     padding: const EdgeInsets.only(right: 8),
  //   );
  // }

    // List<Widget> getAllCategories() {
  //   List<Widget> newList = [];
  //   for (int i = 0; i < categoriesList.length; i++) {
  //     log(categoriesList[i]);
  //     newList.add(_buildChip(
  //         categoriesList[i], getCategoryWiseIcon(categoriesList[i])));
  //   }
  //   return newList;
  // }