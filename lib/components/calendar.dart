import 'package:flutter/material.dart';
import 'package:flutter_calendar/const/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final OnDaySelected onDaySelected;

  const Calendar(
      {required this.selectedDay,
      required this.focusedDay,
      required this.onDaySelected,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration defaultBoxDecoration = BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(6.0),
    );
    TextStyle defaultTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey[600],
    );

    return TableCalendar(
      locale: 'ko_KR',
      focusedDay: this.focusedDay,
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
      onDaySelected: this.onDaySelected,
      selectedDayPredicate: (DateTime day) {
        if (this.selectedDay == null) return false;

        return day.year == this.selectedDay!.year &&
            day.month == this.selectedDay!.month &&
            day.day == this.selectedDay!.day;
      },
    );
  }
}
