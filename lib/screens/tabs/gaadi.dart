import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';

import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:ionicons/ionicons.dart';

class GaadiScreen extends StatefulWidget {
  const GaadiScreen({Key? key}) : super(key: key);

  @override
  State<GaadiScreen> createState() => _GaadiScreenState();
}

class _GaadiScreenState extends State<GaadiScreen> {
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
            height: 180,
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
                          "Gaadi Details",
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
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: selectedGaadi == ""
                                  ? Colors.deepOrangeAccent
                                  : Colors.grey,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedGaadi = "";
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.car_repair,
                                    color: Colors.white,
                                    size: 28,
                                  )),
                            ),
                            const SizedBox(height: 5),
                            const Text("All entries",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: selectedGaadi == "gaadi1"
                                  ? Colors.purple
                                  : Colors.grey,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedGaadi = "gaadi1";
                                  });
                                },
                                icon: const Icon(
                                  Icons.car_repair,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text("Gaadi 2",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: selectedGaadi == "gaadi2"
                                  ? Colors.green
                                  : Colors.grey,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedGaadi = "gaadi2";
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.car_repair,
                                    color: Colors.white,
                                    size: 28,
                                  )),
                            ),
                            const SizedBox(height: 5),
                            const Text("Gaadi 2",
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          //details
          Expanded(
            child: gaadiEntries(),
          ),
        ],
      ),
    );
  }

  gaadiEntries() {
    return Card(
      child: FutureBuilder<List<Entries>>(
        future: FirestoreService().getAllEntries(),
        builder: (context, AsyncSnapshot<List<Entries>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error while loading gaadis \n${snapshot.error}"));
          } else if (snapshot.hasData) {
            var entries = snapshot.data;

            return ListView.builder(
                itemCount: entries!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var info = entries[index];
                  var filterParameter = info.gaadiID.toString();
                  if (selectedGaadi == "") {
                    return Card(
                      child: ListTile(
                        textColor: Colors.black,
                        leading: info.details!.isIncome == true
                            ? Icon(
                                Icons.arrow_circle_up,
                                color: ColorTheme().greenColor,
                              )
                            : Icon(
                                Icons.arrow_circle_down,
                                color: ColorTheme().primaryColor,
                              ),
                        title: Text(info.gaadiID.toString()),
                        subtitle: Text(info.entryLog.toString()),
                        trailing: Text(info.details!.amount.toString()),
                      ),
                    );
                  }

                  if (selectedGaadi == filterParameter) {
                    return Card(
                      child: ListTile(
                        textColor: Colors.black,
                        leading: info.details!.isIncome == true
                            ? Icon(
                                Icons.arrow_circle_up,
                                color: ColorTheme().greenColor,
                              )
                            : Icon(
                                Icons.arrow_circle_down,
                                color: ColorTheme().primaryColor,
                              ),
                        title: Text(info.gaadiID.toString()),
                        subtitle: Text(info.entryLog.toString()),
                        trailing: Text(info.details!.amount.toString()),
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
