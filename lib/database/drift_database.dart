import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_calendar/model/category_color.dart';
import 'package:flutter_calendar/model/schedule.dart';
import 'package:flutter_calendar/model/schedule_with_color.dart';
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

  Stream<List<ScheduleWithColor>> watchSchedule(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId)),
    ]);

    query.where(schedules.date.equals(date));
    query.orderBy([
      OrderingTerm.asc(schedules.startTime),
    ]);

    return query.watch().map((rows) => rows
        .map((row) => ScheduleWithColor(
            schedule: row.readTable(schedules),
            categoryColor: row.readTable(categoryColors)))
        .toList());
  }

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<int> deleteSchedule(int id) =>
      (delete(schedules)..where((t) => t.id.equals(id))).go();

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((t) => t.id.equals(id))).write(data);

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
