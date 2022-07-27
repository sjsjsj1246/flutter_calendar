import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/database/drift_database.dart';
import 'package:flutter_calendar/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // red
  'F44336',
  // orange
  'FF9800',
  //yellow
  'FFEB38',
  //green
  'FCAF50',
  //blue
  '2196F3',
  //indigo
  '3F51B5',
  //purple
  '9C27B0',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  final database = LocalDatabase();

  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for (final hexCode in DEFAULT_COLORS) {
      database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'), home: HomeScreen()));
}
