import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/resources/dateTime_extractor.dart';
import 'package:hamro_gaadi/resources/test%20files/days_and_months.dart';
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

  Widget getBody(context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header card
        SizedBox(
          height: 128,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, right: 10, left: 10),
              child:
                  //header row
                  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Statistics",
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
      ],
    );
  }

  monthTabs(month, index) {
    log('Active month:$activeMonth');

    return Column(
      children: [
        GestureDetector(
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
        ),
      ],
    );
  }

  int? activeMonth = 1;
  @override
  void initState() {
    activeMonth = DateTimeExtractor().getMonthAsInteger(activeMonth!);
    super.initState();
  }
}
 //title
        //         Expanded(
        //   child: Card(
        //     child: Column(
        //       children: [
        //         Text(month["label"]),
        //         const SizedBox(height: 20),
        //         ListTile(leading: Text('$index'), title: Text(month["month"])),
        //       ],
        //     ),
        //   ),
        // ),