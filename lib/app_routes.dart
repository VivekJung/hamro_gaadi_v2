// map for rotues
import 'package:hamro_gaadi/screens/home_screen.dart';
import 'package:hamro_gaadi/screens/login.dart';
import 'package:hamro_gaadi/screens/route_checki_screen.dart';
import 'package:hamro_gaadi/screens/tabs/daily_reports.dart';
import 'package:hamro_gaadi/screens/tabs/stats_screen.dart';
import 'package:hamro_gaadi/screens/transaction_details.dart';

var appRoutes = {
  '/': (context) => const RouteCheckScreen(),
  '/home': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/transactionDetail': (context) =>
      const TransactionDetailScreen(index: 4), //yet to be implemented
  '/dailyReports': (context) => const DailyReports(),
  '/statistics': (context) => const StatsScreen(),
};
