import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/core/helpers/database_helper.dart';
import 'package:resturant/core/helpers/extensions.dart';
import 'package:resturant/core/helpers/spacing.dart';
import 'package:resturant/core/routing/routes.dart';
import 'package:resturant/core/utils/constants/colors.dart';
import 'package:resturant/features/home/logic/table_bloc.dart';
import 'package:resturant/features/home/logic/table_event.dart';
import 'package:resturant/features/home/logic/table_state.dart';
import 'package:resturant/features/table/data/repositories/table_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pushNamed(Routes.ordersScreen),
            icon: const Icon(
              Icons.list,
            ),
          ),
          title: const Text('Table Service'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Inner Room'),
              Tab(text: 'Outer Room'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RoomGrid(roomType: 'inner'),
            RoomGrid(roomType: 'outer'),
          ],
        ),
      ),
    );
  }
}

class RoomGrid extends StatelessWidget {
  final String roomType;

  const RoomGrid({super.key, required this.roomType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableBloc(TableRepository(DatabaseHelper()))
        ..add(LoadTables(roomType)),
      child: BlocBuilder<TableBloc, TableState>(
        builder: (context, state) {
          if (state is TableLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TableLoaded) {
            return GridView.builder(
              itemCount: state.tables.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                final table = state.tables[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => context.pushNamed(
                      Routes.tableScreen,
                      arguments: table,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorsManager.black,
                        ),
                      ),
                      child: GridTile(
                        footer: ColoredBox(
                          color: ColorsManager.red,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${table.numberOfGuests} guests'),
                                horizontalSpace(3),
                                Expanded(
                                  child: Text(
                                    table.status ?? '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                table.name ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              verticalSpace(10),
                              const Text('waiter name'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is TableError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
