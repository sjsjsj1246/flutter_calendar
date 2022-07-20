import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [Calendar()],
          ),
        ),
      ),
    );
  }
}
