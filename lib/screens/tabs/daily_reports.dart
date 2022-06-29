import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/dateTime_extractor.dart';
import 'package:hamro_gaadi/resources/test%20files/days_and_months.dart';
import 'package:hamro_gaadi/screens/transaction_details.dart';
import 'package:ionicons/ionicons.dart';

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
      body: getBody(context),
    );
  }

  Widget getBody(context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
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
          incomeExpenseStatus(),

          // transaction summary
          Expanded(child: transactionSection(context)),
        ],
      ),
    );
  }

  Card incomeExpenseStatus() {
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

  Widget transactionSection(context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Text(
            "Transactions count : ${dailyTransaction.length}",
            style: const TextStyle(fontSize: 8, color: Colors.red),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: dailyTransaction.length,
                  itemBuilder: (context, index) {
                    var transaction = dailyTransaction[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) =>
                                  TransactionDetailScreen(index: transaction)),
                            ),
                          );
                        },
                        leading: const CircleAvatar(
                          child: Center(child: Icon(FeatherIcons.home)),
                        ),
                        title: Text(transaction['name'].toString()),
                        subtitle: Text(transaction['remarks'].toString()),
                        trailing: Text(
                          transaction['type'].toString(),
                          style: TextStyle(
                              color: transaction['type'] == "IN"
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ),
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
