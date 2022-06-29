import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hamro_gaadi/resources/color_theme.dart';
import 'package:hamro_gaadi/screens/tabs/daily_reports.dart';
import 'package:hamro_gaadi/screens/tabs/profile.dart';
import 'package:hamro_gaadi/screens/tabs/stats_screen.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme().bgColor1,
      body: getBody(),
      bottomNavigationBar: getBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        elevation: 2,
        backgroundColor: ColorTheme().whiteColor,
        onPressed: () {
          setTabs(4);
        },
        child: floatingButtonDesign(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  CircleAvatar floatingButtonDesign() {
    return CircleAvatar(
      radius: 26,
      child: Icon(
        Icons.add,
        color: ColorTheme().whiteColor,
      ),
    );
  }

  Widget getBody() {
    return SafeArea(
      child: IndexedStack(
        index: pageIndex,
        children: const [
          DailyReports(),
          StatsScreen(),
          Center(
            child: Text("Vehicle info"),
          ),
          ProfileScreen(),
          Center(
            child: Text("add new "),
          ),
        ],
      ),
    );
  }

  //* start of bottom navigation functions and widgets

  int pageIndex = 0;
  Widget getBottomNavigation() {
    List<IconData> iconItems = [
      Ionicons.calendar,
      Ionicons.stats_chart,
      Ionicons.car,
      Ionicons.person,
    ];
    return AnimatedBottomNavigationBar(
        icons: iconItems,
        activeColor: ColorTheme().primaryColor,
        inactiveColor: ColorTheme().inactiveColor.withOpacity(0.5),
        splashColor: ColorTheme().primaryColor,
        activeIndex: pageIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        rightCornerRadius: 10,
        backgroundColor: ColorTheme().whiteColor,
        iconSize: 18,
        onTap: (index) {
          setTabs(index);
        });
  }

  setTabs(index) {
    setState(() {
      pageIndex = index;
    });
  }

  //*end bottom navigation
}
