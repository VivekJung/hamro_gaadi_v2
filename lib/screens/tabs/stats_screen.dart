// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hamro_gaadi/resources/category_icon.dart';

import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/custom_loading_indicator.dart';
import 'package:hamro_gaadi/resources/dateTime_extractor.dart';
import 'package:hamro_gaadi/resources/test%20files/days_and_months.dart';
import 'package:hamro_gaadi/screens/transaction_details.dart';
import 'package:hamro_gaadi/services/firestore_service.dart';
import 'package:hamro_gaadi/services/models.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatefulWidget {
  final int? income;
  final int? expense;
  const StatsScreen({Key? key, this.income, this.expense}) : super(key: key);

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

  int activeMonth = DateTimeExtractor().getThisMonthAsInteger();
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
          height: 140,
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
        // incomeExpenseStatus(widget.income, widget.expense),

        Expanded(child: MonthlyBasisTransactions(activeMonth: activeMonth))
      ],
    );
  }

  monthTabs(month, index) {
    log('Active month:$activeMonth');
    // log('getting  month:$month');
    log('index:$index');

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
  int totalIncome = 0;
  int totalExpense = 0;

  @override
  Widget build(BuildContext context) {
    var active = widget.activeMonth + 1;
    // var getMonth = months[active];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 5),
        child: Column(
          children: [
            incomeExpenseStatus(totalIncome, totalExpense),
            Expanded(child: retrieveThisMonthData(active)),
          ],
        ),
      ),
    );
  }

  retrieveThisMonthData(active) {
    log("Active data $active");

    return Card(
      child: StreamBuilder(
          stream: FirestoreService().streamSelectedMonthEntries(active),
          builder:
              (BuildContext context, AsyncSnapshot<List<Entries>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (!snapshot.hasData) {
              return Center(child: circularLoading(20));
            }
            var testData = snapshot.data;
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (testData![i].details.isIncome == true) {
                totalIncome += testData[i].details.amount;
              } else {
                totalExpense += testData[i].details.amount;
              }
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data![index];

                  return Card(
                    child: ListTile(
                      title: Text(data.details.category),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.details.remarks),
                          Text(data.entryID!),
                        ],
                      ),
                      trailing: Text(
                        data.details.amount.toString(),
                        style: TextStyle(
                            color: data.details.isIncome == true
                                ? ColorTheme().primaryColor
                                : ColorTheme().greenColor),
                      ),
                      leading: CircleAvatar(
                        child: Center(
                          child: Icon(
                            getCategoryWiseIcon(
                                data.details.category.toString()),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  incomeExpenseStatus(totalIncome, totalExpense) {
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
                  Text(
                    "$totalIncome",
                    style: const TextStyle(
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
                  Text(
                    "$totalExpense",
                    style: const TextStyle(
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
