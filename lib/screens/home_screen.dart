import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/calendar.dart';
import 'package:flutter_calendar/components/schedule_bottom_sheet.dart';
import 'package:flutter_calendar/components/schedule_card.dart';
import 'package:flutter_calendar/components/today_banner.dart';
import 'package:flutter_calendar/const/colors.dart';
import 'package:flutter_calendar/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: Column(
          children: [
            Calendar(
                selectedDay: selectedDate,
                focusedDay: focusedDay,
                onDaySelected: onDaySelected),
            SizedBox(height: 8.0),
            TodayBanner(selectedDay: selectedDate, scheduleCount: 5),
            SizedBox(height: 8.0),
            _ScheduleList(selectedDate: selectedDate)
          ],
        ),
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDate = selectedDay;
      this.focusedDay = selectedDay;
    });
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDate: selectedDate,
              );
            });
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const _ScheduleList({required this.selectedDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedule(),
              builder: (context, snapshot) {
                print(snapshot.data);

                List<Schedule> schedules = [];

                if (snapshot.hasData) {
                  schedules = snapshot.data!
                      .where((element) => element.date == selectedDate)
                      .toList();
                }

                print("filtered Data: $schedules");
                print("selectedDate: $selectedDate");

                return ListView.separated(
                  itemCount: 100,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    return ScheduleCard(
                        startTime: 8,
                        endTime: 14,
                        content: '프로그래밍 공부하기 ${index + 1}',
                        color: Colors.red);
                  },
                );
              })),
    );
  }
}
