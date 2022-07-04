import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/category_icon.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/dateTime_extractor.dart';
import 'package:hamro_gaadi/resources/test%20files/days_and_months.dart';
import 'package:hamro_gaadi/screens/transaction_details.dart';
import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';

import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class DailyReports extends StatefulWidget {
  const DailyReports({Key? key}) : super(key: key);

  @override
  State<DailyReports> createState() => _DailyReportsState();
}

class _DailyReportsState extends State<DailyReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getBody(),
    );
  }

  Widget getBody() {
    var entries = Provider.of<List<Entries>>(context);
    var size = MediaQuery.of(context).size;
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
                  children: [
                    //title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transactions",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Icon(Ionicons.search, color: ColorTheme().blackColor),
                      ],
                    ),

                    //day tabs

                    const SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: days.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var day = days[index];
                            return weekTabs(size, index, day);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //income/expense  card
          incomeExpenseStatus(entries),

          // transaction summary
          Expanded(child: transactionSection(entries)),
        ],
      ),
    );
  }

  // testbtn() {
  //   return IconButton(
  //       onPressed: () async {
  //         await FirestoreService().updateTransaction(100, true, false, "entry5");
  //         // await FirestoreService().getSpecificdata("entry8");
  //       },
  //       icon: const Icon(Icons.mail, color: Colors.white));
  // }

  Card incomeExpenseStatus(List<Entries> entries) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transaction Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Income",
                    style: TextStyle(),
                  ),
                  const Text(
                    "Rs. 60000",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.black,
                  ),
                  const Text(
                    "Expenses",
                  ),
                  const Text(
                    "Rs. 100000",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionSection(List<Entries> entries) {
    int? totalAmt;
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Text(
            "Transactions count : ${entries.length}",
            style: const TextStyle(fontSize: 10, color: Colors.red),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    var transaction = entries[index];
                    DateTime d =
                        DateTime.parse(transaction.entryLog.toString());

                    return Card(
                      child: ListTile(
                          //*?How icon color works

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => TransactionDetailScreen(
                                    index: transaction)),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            child: Center(
                              child: Icon(
                                getCategoryWiseIcon(
                                    transaction.details.category.toString()),
                              ),
                            ),
                          ),
                          title: Text(transaction.details.category.toString()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(transaction.details.remarks.toString()),
                              Text("$d"),
                            ],
                          ),
                          trailing: transaction.details.isIncome == true
                              ? Text("IN",
                                  style:
                                      TextStyle(color: ColorTheme().greenColor))
                              : Text("OUT",
                                  style: TextStyle(
                                      color: ColorTheme().primaryColor))),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  int activeDay = 1;
  @override
  void initState() {
    activeDay = DateTimeExtractor().getDayAsInteger(activeDay);
    super.initState();
  }

  Widget weekTabs(size, index, day) {
    log('Active month:$activeDay');
    return GestureDetector(
      onTap: () {
        setState(() {
          activeDay = index;
        });
      },
      child: Row(
        children: [
          Column(
            children: [
              Text(
                day['label'],
                style: TextStyle(
                    fontSize: 12,
                    color: activeDay == index
                        ? ColorTheme().primaryColor
                        : ColorTheme().blackColor.withOpacity(0.8),
                    fontWeight: activeDay == index
                        ? FontWeight.w500
                        : FontWeight.normal),
              ),
              const SizedBox(height: 5),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: activeDay == index
                      ? ColorTheme().primaryColor
                      : ColorTheme().whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorTheme().primaryColor),
                ),
                child: Center(
                  child: Text(
                    day['day'],
                    style: TextStyle(
                      fontSize: 12,
                      color: activeDay != index
                          ? ColorTheme().primaryColor
                          : ColorTheme().whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
