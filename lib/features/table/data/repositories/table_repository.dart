import 'package:resturant/core/helpers/database_helper.dart';
import 'package:resturant/features/home/data/models/table.dart';

class TableRepository {
  final DatabaseHelper databaseHelper;
  TableRepository(this.databaseHelper);

  Future<List<TableModel>> getTables(String roomType) async {
    final tables = await databaseHelper.getTables(roomType);
    return tables
        .map((e) => TableModel(
              id: e['id'],
              name: e['name'],
              roomType: e['room_type'],
              status: e['status'],
              numberOfGuests: e['number_of_guests'],
            ))
        .toList();
  }
}
