import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/calendar.dart';
import 'package:flutter_calendar/components/schedule_card.dart';
import 'package:flutter_calendar/components/today_banner.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Calendar(
                  selectedDay: selectedDay,
                  focusedDay: focusedDay,
                  onDaySelected: onDaySelected),
              SizedBox(height: 8.0),
              TodayBanner(selectedDay: selectedDay, scheduleCount: 5),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ScheduleCard(
                    startTime: 8,
                    endTime: 14,
                    content: '프로그래밍 공부하기',
                    color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}
