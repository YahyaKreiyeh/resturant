import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resturant/core/routing/app_router.dart';
import 'package:resturant/core/routing/routes.dart';
import 'package:resturant/core/utils/constants/colors.dart';

class RestaurantApp extends StatelessWidget {
  final AppRouter appRouter;

  const RestaurantApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    // var kColorScheme = ColorScheme.fromSeed(
    //   seedColor: const Color.fromARGB(255, 96, 59, 181),
    // );

    // var kDarkColorScheme = ColorScheme.fromSeed(
    //   brightness: Brightness.dark,
    //   seedColor: const Color.fromARGB(255, 5, 99, 125),
    // );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Measure Ap',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              color: ColorsManager.scaffoldBackground,
              centerTitle: true,
            ),
            primaryColor: ColorsManager.primary,
            scaffoldBackgroundColor: ColorsManager.scaffoldBackground,
            // colorScheme: ColorScheme.fromSeed(
            //   brightness: Brightness.light,
            //   seedColor: ColorsManager.primary,
            //   surface: ColorsManager.white,
            //   surfaceTint: ColorsManager.white,
            // ),
          ),
          // darkTheme: ThemeData.dark().copyWith(
          //   colorScheme: kDarkColorScheme,
          //   cardTheme: const CardTheme().copyWith(
          //     color: kDarkColorScheme.secondaryContainer,
          //     margin: const EdgeInsets.symmetric(
          //       horizontal: 16,
          //       vertical: 8,
          //     ),
          //   ),
          //   elevatedButtonTheme: ElevatedButtonThemeData(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: kDarkColorScheme.primaryContainer,
          //       foregroundColor: kDarkColorScheme.onPrimaryContainer,
          //     ),
          //   ),
          // ),
          // theme: ThemeData().copyWith(
          //   colorScheme: kColorScheme,
          //   appBarTheme: const AppBarTheme().copyWith(
          //     backgroundColor: kColorScheme.onPrimaryContainer,
          //     foregroundColor: kColorScheme.primaryContainer,
          //   ),
          //   cardTheme: const CardTheme().copyWith(
          //     color: kColorScheme.secondaryContainer,
          //     margin: const EdgeInsets.symmetric(
          //       horizontal: 16,
          //       vertical: 8,
          //     ),
          //   ),
          //   elevatedButtonTheme: ElevatedButtonThemeData(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: kColorScheme.primaryContainer,
          //     ),
          //   ),
          //   textTheme: ThemeData().textTheme.copyWith(
          //         titleLarge: TextStyle(
          //           fontWeight: FontWeight.normal,
          //           color: kColorScheme.onSecondaryContainer,
          //           fontSize: 14,
          //         ),
          //       ),
          // ),
          // themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.homeScreen,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
