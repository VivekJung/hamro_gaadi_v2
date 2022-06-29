import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/dateTime_extractor.dart';
import 'package:hamro_gaadi/resources/test%20files/days_and_months.dart';
import 'package:hamro_gaadi/screens/transaction_details.dart';
import 'package:ionicons/ionicons.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: getBody(context),
    );
  }

  int activeMonth = 1;
  @override
  void initState() {
    activeMonth = DateTimeExtractor().getMonthAsInteger(activeMonth);
    super.initState();
  }

  Widget getBody(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header card
        SizedBox(
          height: 130,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 10, left: 10),
              child:
                  //header row
                  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "MONTHLY REPORT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Icon(Ionicons.search, color: ColorTheme().blackColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: months.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var month = months[index];
                          return monthTabs(month, index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        incomeExpenseStatus(),

        Expanded(child: MonthlyBasisTransactions(activeMonth: activeMonth))
      ],
    );
  }

  monthTabs(month, index) {
    log('Active month:$activeMonth');

    return GestureDetector(
      onTap: () {
        setState(() {
          activeMonth = index;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                month["label"],
                style: TextStyle(
                    fontSize: 12,
                    color: activeMonth == index
                        ? ColorTheme().primaryColor
                        : ColorTheme().blackColor.withOpacity(0.8),
                    fontWeight: activeMonth == index
                        ? FontWeight.w500
                        : FontWeight.normal),
              ),
              const SizedBox(height: 5),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: activeMonth == index
                      ? ColorTheme().primaryColor
                      : ColorTheme().whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorTheme().primaryColor),
                ),
                child: Center(
                  child: Text(
                    month["month"],
                    style: TextStyle(
                      fontSize: 12,
                      color: activeMonth != index
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

  incomeExpenseStatus() {
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
}
//title
//
//
//

class MonthlyBasisTransactions extends StatefulWidget {
  final dynamic activeMonth;
  const MonthlyBasisTransactions({Key? key, required this.activeMonth})
      : super(key: key);

  @override
  State<MonthlyBasisTransactions> createState() =>
      _MonthlyBasisTransactionsState();
}

class _MonthlyBasisTransactionsState extends State<MonthlyBasisTransactions> {
  @override
  Widget build(BuildContext context) {
    var active = widget.activeMonth! ?? "0";
    var getMonth = months[active];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 5),
        child: Card(
          child: Column(
            children: [
              Expanded(child: retrieveThisMonthData(getMonth)),
            ],
          ),
        ),
      ),
    );
  }

  retrieveThisMonthData(var month) {
    var thisList = dailyTransaction
        .where((element) => element['date'] == month!["month"])
        .toList();
    // log(thisList.toString());

    if (thisList.isEmpty) {
      return Center(
        child: Text("Oops! No entries recorded for ${month["month"]}"),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 5),
          Text(
            "Transactions count : ${thisList.length}",
            style: TextStyle(fontSize: 8, color: ColorTheme().primaryColor),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: thisList.length,
              itemBuilder: ((context, index) {
                var data = thisList[index]!;
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) =>
                              TransactionDetailScreen(index: data)),
                        ),
                      );
                    },
                    leading: const CircleAvatar(
                      child: Center(child: Icon(FeatherIcons.home)),
                    ),
                    title: Text(data['name'].toString()),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['remarks'].toString()),
                        Text(data['date'].toString()),
                      ],
                    ),
                    trailing: Text(
                      data['type'].toString(),
                      style: TextStyle(
                          color:
                              data['type'] == "IN" ? Colors.green : Colors.red),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    }
  }
}
