import 'package:flutter/material.dart';
import 'package:resturant/core/routing/app_router.dart';
import 'package:resturant/restaurant_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await initiateGetIt();
  // await ScreenUtil.ensureScreenSize();
  // await EasyLocalization.ensureInitialized();
  // FlutterNativeSplash.remove();
  // EasyLocalization.logger.enableBuildModes = [];
  runApp(
    RestaurantApp(
      appRouter: AppRouter(),
    ),
  );
}
