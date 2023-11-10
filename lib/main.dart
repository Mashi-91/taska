import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/routes.dart';
import 'package:taska/constant/tokens.dart';
import 'package:taska/firebase_options.dart';

int? isViewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt(ONBOARDINGTOKEN);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taska',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black,size: 20)
          ),
          scaffoldBackgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: primaryColor),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: GoogleFonts.poppins().fontFamily),
      initialRoute:
          isViewed == 0 || isViewed == null ? '/OnBoardingScreen' : '/',
      getPages: Routes.routes,
    );
  }
}
