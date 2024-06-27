import 'package:equatable/equatable.dart';
import 'package:resturant/features/table/data/models/food_category.dart';
import 'package:resturant/features/table/data/models/food_item.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<FoodCategory> categories;
  final bool showCategories;

  const CategoryLoaded(this.categories, {this.showCategories = true});

  @override
  List<Object> get props => [categories, showCategories];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class FoodItemsLoading extends CategoryState {}

class FoodItemsLoaded extends CategoryState {
  final List<FoodItem> foodItems;
  final bool showCategories;

  const FoodItemsLoaded(this.foodItems, {this.showCategories = false});

  @override
  List<Object> get props => [foodItems, showCategories];
}

class FoodItemsError extends CategoryState {
  final String message;

  const FoodItemsError(this.message);

  @override
  List<Object> get props => [message];
}

class OrderUpdated extends CategoryState {
  final List<Map<String, dynamic>> orderItems;

  const OrderUpdated(this.orderItems);

  @override
  List<Object> get props => [orderItems];
}
