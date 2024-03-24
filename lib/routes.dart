import 'pages/counter.dart';
import 'pages/historical.dart';
import 'pages/sign-in.dart';

final routes = {
  "/": (context) => const CounterPage(),
  "/historical": (context) => const HistoricalPage(),
  "/sign-in": (context) => const SignIn(),
};
