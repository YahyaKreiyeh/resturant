import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/features/home/data/models/table.dart';
import 'package:resturant/features/table/logic/category_bloc.dart';
import 'package:resturant/features/table/logic/category_event.dart';
import 'package:resturant/features/table/logic/category_state.dart';

class TableScreen extends StatefulWidget {
  final TableModel table;

  const TableScreen({
    super.key,
    required this.table,
  });

  @override
  TableScreenState createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  double _calculateTotal(List<Map<String, dynamic>> orderItems) {
    return orderItems.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element['price'] * element['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            double total = 0.0;
            if (context.read<CategoryBloc>().orderItems.isNotEmpty) {
              total = _calculateTotal(context.read<CategoryBloc>().orderItems);
            }
            return Text('${widget.table.name} \$${total.toStringAsFixed(2)}');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is OrderUpdated && state.orderItems.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.orderItems.length,
                    itemBuilder: (context, index) {
                      final orderItem = state.orderItems[index];
                      return ListTile(
                        leading: Text(orderItem['quantity'].toString()),
                        title: Text(orderItem['name'] ?? ''),
                        trailing: Text(orderItem['price'].toStringAsFixed(2)),
                      );
                    },
                  );
                } else if (context.read<CategoryBloc>().orderItems.isNotEmpty) {
                  return ListView.builder(
                    itemCount: context.read<CategoryBloc>().orderItems.length,
                    itemBuilder: (context, index) {
                      final orderItem =
                          context.read<CategoryBloc>().orderItems[index];
                      return ListTile(
                        leading: Text(orderItem['quantity'].toString()),
                        title: Text(orderItem['name'] ?? ''),
                        trailing: Text(orderItem['price'].toStringAsFixed(2)),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Add item'),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<CategoryBloc>()
                  .add(const ToggleShowCategories(true));
              context.read<CategoryBloc>().add(LoadCategories());
            },
            child: const Icon(
              Icons.arrow_back,
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading || state is FoodItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryLoaded && state.showCategories) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: kToolbarHeight,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<CategoryBloc>()
                                .add(LoadFoodItems(category.id));
                            context
                                .read<CategoryBloc>()
                                .add(const ToggleShowCategories(false));
                          },
                          child: Text(category.name),
                        ),
                      );
                    },
                  );
                } else if (state is FoodItemsLoaded && !state.showCategories) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: kToolbarHeight,
                    ),
                    itemCount: state.foodItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = state.foodItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<CategoryBloc>().add(
                                  AddFoodItemToOrder(
                                    widget.table.id!,
                                    foodItem,
                                  ),
                                );
                          },
                          child: Text(foodItem.name),
                        ),
                      );
                    },
                  );
                } else if (state is CategoryError || state is FoodItemsError) {
                  return Center(child: Text((state as dynamic).message));
                } else {
                  context
                      .read<CategoryBloc>()
                      .add(const ToggleShowCategories(true));
                  context.read<CategoryBloc>().add(LoadCategories());
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
