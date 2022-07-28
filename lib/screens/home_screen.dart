import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/calendar.dart';
import 'package:flutter_calendar/components/schedule_bottom_sheet.dart';
import 'package:flutter_calendar/components/schedule_card.dart';
import 'package:flutter_calendar/components/today_banner.dart';
import 'package:flutter_calendar/const/colors.dart';
import 'package:flutter_calendar/database/drift_database.dart';
import 'package:flutter_calendar/model/schedule_with_color.dart';
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
            TodayBanner(selectedDay: selectedDate),
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
                scheduleId: null,
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
          child: StreamBuilder<List<ScheduleWithColor>>(
              stream: GetIt.I<LocalDatabase>().watchSchedule(selectedDate),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('스케쥴이 없습니다'));
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final scheduleWithColor = snapshot.data![index];

                    return Dismissible(
                      key: ObjectKey(scheduleWithColor.schedule.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) => {
                        GetIt.I<LocalDatabase>()
                            .deleteSchedule(scheduleWithColor.schedule.id),
                      },
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (_) {
                                return ScheduleBottomSheet(
                                  scheduleId: scheduleWithColor.schedule.id,
                                  selectedDate: selectedDate,
                                );
                              });
                        },
                        child: ScheduleCard(
                            startTime: scheduleWithColor.schedule.startTime,
                            endTime: scheduleWithColor.schedule.endTime,
                            content: scheduleWithColor.schedule.content,
                            color: Color(int.parse(
                                'FF${scheduleWithColor.categoryColor.hexCode}',
                                radix: 16))),
                      ),
                    );
                  },
                );
              })),
    );
  }
}
