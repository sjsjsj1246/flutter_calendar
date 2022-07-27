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
