import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/core/helpers/database_helper.dart';

import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final DatabaseHelper databaseHelper;

  OrdersBloc(this.databaseHelper) : super(OrdersInitial()) {
    on<LoadOrders>((event, emit) async {
      emit(OrdersLoading());
      try {
        final ordersData = await databaseHelper.getAllOrders();
        final reversedOrders = ordersData.reversed.toList();
        emit(OrdersLoaded(reversedOrders));
      } catch (e) {
        emit(const OrdersError('Failed to load orders'));
      }
    });
  }
}
