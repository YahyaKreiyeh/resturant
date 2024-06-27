import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturant/features/table/data/repositories/table_repository.dart';

import 'table_event.dart';
import 'table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  final TableRepository tableRepository;

  TableBloc(this.tableRepository) : super(TableInitial()) {
    on<LoadTables>((event, emit) async {
      emit(TableLoading());
      try {
        final tables = await tableRepository.getTables(event.roomType);
        emit(TableLoaded(tables));
      } catch (e) {
        emit(const TableError('Failed to load tables'));
      }
    });
  }
}
