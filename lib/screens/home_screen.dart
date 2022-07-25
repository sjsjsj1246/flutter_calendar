import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/calendar.dart';
import 'package:flutter_calendar/components/schedule_bottom_sheet.dart';
import 'package:flutter_calendar/components/schedule_card.dart';
import 'package:flutter_calendar/components/today_banner.dart';
import 'package:flutter_calendar/const/colors.dart';
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
        floatingActionButton: renderFloatingActionButton(),
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
              _ScheduleList()
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

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return ScheduleBottomSheet();
            });
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(Icons.add),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.separated(
            itemCount: 100,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              print(index);
              return ScheduleCard(
                  startTime: 8,
                  endTime: 14,
                  content: '프로그래밍 공부하기 ${index + 1}',
                  color: Colors.red);
            },
          )),
    );
  }
}
