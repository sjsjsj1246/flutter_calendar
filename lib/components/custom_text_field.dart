import 'package:flutter/material.dart';
import 'package:flutter_calendar/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String lable;
  const CustomTextField({required this.lable, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(this.lable,
            style:
                TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600)),
        TextField(
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300]),
        ),
      ],
    );
  }
}
