import "package:cloud_firestore/cloud_firestore.dart";
import "package:dynamic_color/dynamic_color.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "routes.dart";
import "firebase_options.dart";

const ENABLE_EMULATORS = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode && ENABLE_EMULATORS) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8009);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(const MyApp());
}

const String title = "Addiction Tracker";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          const brandColour = Color.fromARGB(255, 8, 163, 104);

          lightColorScheme = ColorScheme.fromSeed(
            seedColor: brandColour,
          );

          darkColorScheme = ColorScheme.fromSeed(
            seedColor: brandColour,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: title,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          // routes: routes,
          initialRoute: "/",
          onGenerateRoute: (settings) {
            final page = routes[settings.name];
            if (page != null) {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    page(null),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        transitionBuilder(animation, child),
              );
            }

            return null;
          },
        );
      },
    );
  }
}

Widget transitionBuilder(Animation<double> animation, Widget child) {
  var curve = Curves.ease;

  var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

  return FadeTransition(
    opacity: animation.drive(tween),
    child: child,
  );
}
