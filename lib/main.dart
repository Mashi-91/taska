import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/tokens.dart';
import 'package:taska/firebase_options.dart';
import 'package:taska/routes/appPages.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/service/networkCheckService.dart';

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
    // debugPaintSizeEnabled = true;
    Get.put(NetworkController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Taska',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black, size: 20)),
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: ColorsUtil.primaryColor),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: GoogleFonts.poppins().fontFamily,
        platform: TargetPlatform.android,
      ),
      initialRoute: isViewed == 0 || isViewed == null
          ? AppRoutes.onBoardingScreen
          : AppRoutes.authScreen,
      getPages: AppPages.routes,
    );
  }
}
