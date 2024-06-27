import 'package:equatable/equatable.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();

  @override
  List<Object> get props => [];
}

class LoadTables extends TableEvent {
  final String roomType;

  const LoadTables(this.roomType);

  @override
  List<Object> get props => [roomType];
}
