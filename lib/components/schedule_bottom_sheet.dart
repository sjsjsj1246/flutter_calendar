import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/custom_text_field.dart';
import 'package:flutter_calendar/const/colors.dart';
import 'package:flutter_calendar/database/drift_database.dart';
import 'package:flutter_calendar/model/category_color.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int? startTime;
  int? endTime;
  String? content;

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
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Time(
                      onStartSaved: (String? value) {
                        startTime = int.parse(value!);
                      },
                      onEndSaved: (String? value) {
                        endTime = int.parse(value!);
                      },
                    ),
                    SizedBox(height: 16.0),
                    _Content(
                      onSaved: (String? value) {
                        content = value!;
                      },
                    ),
                    SizedBox(height: 16.0),
                    FutureBuilder<List<CategoryColor>>(
                        future: GetIt.I<LocalDatabase>().getCategoryColors(),
                        builder: (context, snapshot) {
                          return _ColorPicker(
                              colors: snapshot.hasData
                                  ? snapshot.data!
                                      .map((e) => Color(int.parse(
                                          'FF${e.hexCode}',
                                          radix: 16)))
                                      .toList()
                                  : []);
                        }),
                    _SaveButton(
                      onPressed: onSavePressed,
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void onSavePressed() {
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      print("에러가 없습니다.");
      formKey.currentState!.save();

      print("startTime: $startTime");
      print("endTime: $endTime");
      print("content: $content");
    } else {
      print("에러가 있습니다.");
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({required this.onStartSaved, required this.onEndSaved, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          onSaved: onStartSaved,
          isTime: true,
          lable: "시작시간",
        )),
        SizedBox(width: 16.0),
        Expanded(
            child: CustomTextField(
                onSaved: onEndSaved, isTime: true, lable: "종료시간")),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;

  const _Content({required this.onSaved, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(onSaved: onSaved, isTime: false, lable: "내용"));
  }
}

class _ColorPicker extends StatelessWidget {
  final List<Color> colors;

  const _ColorPicker({required this.colors, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors.map((color) => renderColor(color)).toList(),
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
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                onPressed: onPressed,
                child: Text("저장"))),
      ],
    );
  }
}
