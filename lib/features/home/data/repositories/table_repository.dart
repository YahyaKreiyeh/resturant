import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/core/routing/routes.dart';
import 'package:resturant/features/home/data/models/table.dart';
import 'package:resturant/features/home/logic/table_bloc.dart';
import 'package:resturant/features/home/logic/table_event.dart';
import 'package:resturant/features/home/ui/screens/home_screen.dart';
import 'package:resturant/features/orders/ui/screens/orders_screen.dart';
import 'package:resturant/features/table/data/repositories/table_repository.dart';
import 'package:resturant/features/table/ui/screens/table_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => TableBloc(context.read<TableRepository>())
              ..add(const LoadTables('inner')),
            child: const HomeScreen(),
          ),
        );
      case Routes.tableScreen:
        final args = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => TableScreen(
            table: args as TableModel,
          ),
        );
      case Routes.ordersScreen:
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
        );
      default:
        return null;
    }
  }
}
