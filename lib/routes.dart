import 'package:addictiontracker/pages/sign-in.dart';

import 'pages/counter.dart';
import 'pages/historical.dart';

final routes = {
  "/": (context) => const CounterPage(),
  "/historical": (context) => const HistoricalPage(),
  "/sign-in": (context) => const SignIn(),
};
