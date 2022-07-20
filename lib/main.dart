import 'package:flutter/material.dart';
import 'package:flutter_calendar/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'), home: HomeScreen()));
}
