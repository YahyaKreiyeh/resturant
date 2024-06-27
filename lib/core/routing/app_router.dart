import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/core/helpers/database_helper.dart';
import 'package:resturant/core/routing/routes.dart';
import 'package:resturant/features/home/data/models/table.dart';
import 'package:resturant/features/home/ui/screens/home_screen.dart';
import 'package:resturant/features/orders/logic/orders_bloc.dart';
import 'package:resturant/features/orders/logic/orders_event.dart';
import 'package:resturant/features/orders/ui/screens/orders_screen.dart';
import 'package:resturant/features/table/logic/category_bloc.dart';
import 'package:resturant/features/table/logic/category_event.dart';
import 'package:resturant/features/table/ui/screens/table_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case Routes.tableScreen:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                CategoryBloc(DatabaseHelper())..add(LoadCategories()),
            child: TableScreen(
              table: args as TableModel,
            ),
          ),
        );
      case Routes.ordersScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                OrdersBloc(DatabaseHelper())..add(LoadOrders()),
            child: const OrdersScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
