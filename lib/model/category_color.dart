import 'package:drift/drift.dart';

class CategoryColors extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get hexCode => integer()();
}
