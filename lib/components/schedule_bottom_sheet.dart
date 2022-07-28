import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_calendar/components/custom_text_field.dart';
import 'package:flutter_calendar/const/colors.dart';
import 'package:flutter_calendar/database/drift_database.dart';
import 'package:flutter_calendar/model/category_color.dart';
import 'package:flutter_calendar/model/schedule_with_color.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet(
      {required this.selectedDate, required this.scheduleId, Key? key})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => {
        FocusScope.of(context).requestFocus(FocusNode()),
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId != null
              ? GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!)
              : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData && startTime == null) {
              final schedule = snapshot.data!;
              startTime = schedule.startTime;
              endTime = schedule.endTime;
              content = schedule.content;
              selectedColorId = schedule.colorId;
            }

            return Container(
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                            onStartSaved: (String? value) {
                              startTime = int.parse(value!);
                            },
                            onEndSaved: (String? value) {
                              endTime = int.parse(value!);
                            },
                          ),
                          SizedBox(height: 16.0),
                          _Content(
                            contentInitialValue: content ?? '',
                            onSaved: (String? value) {
                              content = value!;
                            },
                          ),
                          SizedBox(height: 16.0),
                          FutureBuilder<List<CategoryColor>>(
                              future:
                                  GetIt.I<LocalDatabase>().getCategoryColors(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    selectedColorId == null &&
                                    snapshot.data!.isNotEmpty) {
                                  selectedColorId = snapshot.data![0].id;
                                }

                                return _ColorPicker(
                                  selectedColorId: selectedColorId,
                                  colors:
                                      snapshot.hasData ? snapshot.data! : [],
                                  colorIdSetter: (int id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                );
                              }),
                          _SaveButton(
                            onPressed: onSavePressed,
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          }),
    );
  }

  void onSavePressed() async {
    if (formKey.currentState == null) {
      return;
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleId != null) {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      } else {
        final key = await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      }

      Navigator.of(context).pop();
    } else {
      print("에러가 있습니다.");
    }
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String? startInitialValue;
  final String? endInitialValue;

  const _Time(
      {required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue,
      Key? key})
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
                initialValue: startInitialValue)),
        SizedBox(width: 16.0),
        Expanded(
            child: CustomTextField(
                initialValue: endInitialValue,
                onSaved: onEndSaved,
                isTime: true,
                lable: "종료시간")),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final String? contentInitialValue;

  const _Content(
      {required this.onSaved, required this.contentInitialValue, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
            initialValue: contentInitialValue,
            onSaved: onSaved,
            isTime: false,
            lable: "내용"));
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker(
      {required this.colorIdSetter,
      required this.selectedColorId,
      required this.colors,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors
          .map((e) => GestureDetector(
              onTap: () {
                colorIdSetter(e.id);
              },
              child: renderColor(e, selectedColorId == e.id)))
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(int.parse('FF${color.hexCode}', radix: 16)),
          border:
              isSelected ? Border.all(color: Colors.black, width: 4.0) : null),
      width: 32.0,
      height: 32.0,
    );
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
