import 'package:flutter/material.dart';
import 'package:flutter_calendar/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  BoxDecoration defaultBoxDecoration = BoxDecoration(
    color: Colors.grey[200],
    borderRadius: BorderRadius.circular(6.0),
  );
  TextStyle defaultTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.grey[600],
  );

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: focusedDay,
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0)),
      calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          defaultDecoration: defaultBoxDecoration,
          weekendDecoration: defaultBoxDecoration,
          selectedDecoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: PRIMARY_COLOR, width: 1),
              borderRadius: BorderRadius.circular(6.0)),
          defaultTextStyle: defaultTextStyle,
          weekendTextStyle: defaultTextStyle,
          selectedTextStyle: defaultTextStyle.copyWith(color: PRIMARY_COLOR),
          outsideDecoration: BoxDecoration(shape: BoxShape.rectangle)),
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          this.selectedDay = selectedDay;
          this.focusedDay = selectedDay;
        });
      },
      selectedDayPredicate: (DateTime day) {
        if (selectedDay == null) return false;

        return day.year == selectedDay!.year &&
            day.month == selectedDay!.month &&
            day.day == selectedDay!.day;
      },
    );
  }
}
