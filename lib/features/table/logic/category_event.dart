import 'package:equatable/equatable.dart';
import 'package:resturant/features/table/data/models/food_item.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {}

class LoadFoodItems extends CategoryEvent {
  final int categoryId;

  const LoadFoodItems(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ToggleShowCategories extends CategoryEvent {
  final bool showCategories;

  const ToggleShowCategories(this.showCategories);

  @override
  List<Object> get props => [showCategories];
}

class AddFoodItemToOrder extends CategoryEvent {
  final int tableId;
  final FoodItem foodItem;

  const AddFoodItemToOrder(this.tableId, this.foodItem);

  @override
  List<Object> get props => [tableId, foodItem];
}
