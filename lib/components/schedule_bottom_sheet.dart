import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/custom_text_field.dart';
import 'package:flutter_calendar/const/colors.dart';

class ScheduleBottomSheet extends StatelessWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => {
        FocusScope.of(context).requestFocus(FocusNode()),
      },
      child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Time(),
                  SizedBox(height: 16.0),
                  _Content(),
                  SizedBox(height: 16.0),
                  _ColorPicker(),
                  _SaveButton()
                ],
              ),
            ),
          )),
    );
  }
}

class _Time extends StatelessWidget {
  const _Time({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          isTime: true,
          lable: "시작시간",
        )),
        SizedBox(width: 16.0),
        Expanded(child: CustomTextField(isTime: true, lable: "종료시간")),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: CustomTextField(isTime: false, lable: "내용"));
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: [
        renderColor(Colors.red),
        renderColor(Colors.orange),
        renderColor(Colors.yellow),
        renderColor(Colors.green),
        renderColor(Colors.blue),
        renderColor(Colors.indigo),
        renderColor(Colors.purple),
      ],
    );
  }

  Widget renderColor(Color color) {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        width: 32.0,
        height: 32.0);
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                onPressed: () {},
                child: Text("저장"))),
      ],
    );
  }
}
