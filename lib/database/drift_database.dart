import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_calendar/model/category_color.dart';
import 'package:flutter_calendar/model/schedule.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<Schedule>> getSchedules() => select(schedules).get();

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<bool> updateSchedule(SchedulesCompanion data) =>
      update(schedules).replace(data);

  Future<bool> updateCategoryColor(CategoryColorsCompanion data) =>
      update(categoryColors).replace(data);

  Future<int> deleteSchedule(SchedulesCompanion data) =>
      delete(schedules).delete(data);

  Future<int> deleteCategoryColor(CategoryColorsCompanion data) =>
      delete(categoryColors).delete(data);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(join(dbFolder.path, 'drift.db'));
      return NativeDatabase(file);
    },
  );
}
