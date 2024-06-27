import 'package:bloc/bloc.dart';
import 'package:resturant/core/helpers/database_helper.dart';
import 'package:resturant/features/table/data/models/food_category.dart';
import 'package:resturant/features/table/data/models/food_item.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final DatabaseHelper databaseHelper;
  int? currentOrderId;
  List<Map<String, dynamic>> orderItems = [];
  int? currentCategoryId;

  CategoryBloc(this.databaseHelper) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categoriesData = await databaseHelper.getFoodCategories();
        final categories =
            categoriesData.map((e) => FoodCategory.fromMap(e)).toList();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(const CategoryError('Failed to load categories'));
      }
    });

    on<LoadFoodItems>((event, emit) async {
      emit(FoodItemsLoading());
      try {
        currentCategoryId = event.categoryId;
        final foodItemsData =
            await databaseHelper.getFoodItems(event.categoryId);
        final foodItems =
            foodItemsData.map((e) => FoodItem.fromMap(e)).toList();
        emit(FoodItemsLoaded(foodItems));
      } catch (e) {
        emit(const FoodItemsError('Failed to load food items'));
      }
    });

    on<ToggleShowCategories>((event, emit) {
      final currentState = state;
      if (currentState is CategoryLoaded) {
        emit(CategoryLoaded(currentState.categories,
            showCategories: event.showCategories));
      } else if (currentState is FoodItemsLoaded) {
        emit(FoodItemsLoaded(currentState.foodItems,
            showCategories: event.showCategories));
      }
    });

    on<AddFoodItemToOrder>((event, emit) async {
      try {
        currentOrderId ??= await databaseHelper.createOrder(event.tableId,
            'Order_${event.tableId}_${DateTime.now().millisecondsSinceEpoch}');

        final existingOrderItem = await databaseHelper.getOrderItem(
            currentOrderId!, event.foodItem.id);
        if (existingOrderItem != null) {
          final updatedQuantity = existingOrderItem['quantity'] + 1;
          await databaseHelper.updateOrderItem(
              existingOrderItem['id'], updatedQuantity);
        } else {
          await databaseHelper.addOrderItem(
              currentOrderId!, event.foodItem.id, 1);
        }

        orderItems = await databaseHelper.getOrderItems(currentOrderId!);
        if (currentCategoryId != null) {
          add(LoadFoodItems(currentCategoryId!));
        }
        emit(OrderUpdated(orderItems));
      } catch (e) {
        emit(const CategoryError('Failed to add item to order'));
      }
    });
  }
}
