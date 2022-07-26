import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String lable;
  final bool isTime;
  const CustomTextField({required this.isTime, required this.lable, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lable,
            style:
                TextStyle(color: PRIMARY_COLOR, fontWeight: FontWeight.w600)),
        if (isTime) renderTextField(),
        if (!isTime) Expanded(child: renderTextField()),
      ],
    );
  }

  Widget renderTextField() {
    return TextField(
      expands: !isTime,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      maxLines: isTime ? 1 : null,
      inputFormatters: isTime ? [FilteringTextInputFormatter.digitsOnly] : [],
      cursorColor: Colors.grey,
      decoration: InputDecoration(
          border: InputBorder.none, filled: true, fillColor: Colors.grey[300]),
    );
  }
}
