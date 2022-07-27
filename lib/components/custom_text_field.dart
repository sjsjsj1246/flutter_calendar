import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar/const/colors.dart';

class CustomTextField extends StatelessWidget {
  final String lable;
  final bool isTime;
  final FormFieldSetter<String>? onSaved;

  const CustomTextField(
      {required this.onSaved,
      required this.isTime,
      required this.lable,
      Key? key})
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
    return TextFormField(
      onSaved: onSaved,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return '값을 입력해주세요';
        }

        if (isTime) {
          int time = int.parse(value);

          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요';
          }

          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {
          if (value.length > 500) {
            return "500자 이하의 글자를 입력해주세요";
          }
        }

        return null;
      },
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
