// map for rotues
import 'package:flutter/cupertino.dart';
import 'package:hamro_gaadi/screens/home_screen.dart';
import 'package:hamro_gaadi/screens/login.dart';
import 'package:hamro_gaadi/screens/route_checki_screen.dart';
import 'package:hamro_gaadi/screens/tabs/daily_reports.dart';
import 'package:hamro_gaadi/screens/tabs/stats_screen.dart';

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    '/': (context) => const RouteCheckScreen(),
    '/home': (context) => const HomeScreen(),
    '/login': (context) => const LoginScreen(),
    //yet to be implemented
    '/dailyReports': (context) => const DailyReports(),
    '/statistics': (context) => const StatsScreen(),
  };
}
