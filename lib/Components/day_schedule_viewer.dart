import 'dart:math' hide log;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekly_scheduler/Components/round_check_box.dart';
import 'package:weekly_scheduler/Components/slot_chip.dart';
import 'package:weekly_scheduler/Config/size_config.dart';
import 'package:weekly_scheduler/Models/schedule_model.dart';
import 'package:weekly_scheduler/Values/color.dart';
import 'package:weekly_scheduler/Values/string_values.dart';

class DayScheduleViewer extends StatelessWidget {
  final ScheduleModel scheduleModel;
  final Function(ScheduleModel data) onChange;
  const DayScheduleViewer({
    Key? key,
    required this.scheduleModel,
    required this.onChange,
  }) : super(key: key);

  void onChipSelectionChange(bool check, String key) {
    if (check) {
      scheduleModel.events[key] = 1;
    } else {
      scheduleModel.events.remove(key);
    }
    onChange(scheduleModel);
  }

  double getLargeTextSize(context) {
    double value = 0;
    for (int i = 0; i < days.length; i++) {
      var txt = TextPainter(
        text: TextSpan(
          text: days[i].substring(0, 3).toUpperCase(),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
      )..layout(minWidth: 0, maxWidth: 100);
      value = value < txt.width ? txt.width : value;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final txtGroup = AutoSizeGroup();
    final valueNotifier = ValueNotifier<bool>(scheduleModel.isActive);

    final width = getLargeTextSize(context);
    SizeConfig sizeC = SizeConfig();
    sizeC.init(context);
    const spaceH8 = SizedBox(
      width: 8,
    );
    const spaceH16 = SizedBox(
      width: 16,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: double.infinity,
      constraints:
          BoxConstraints(minHeight: min(60, sizeC.blockSizeVertical! * 14)),
      child: Row(
        children: [
          RoundCheckBox(
            isCheck: scheduleModel.isActive,
            onChange: (bool check) {
              onChange(scheduleModel.copyWith(
                  isActive: check, events: check ? scheduleModel.events : {}));
              valueNotifier.value = check;
            },
          ),
          spaceH8,
          SizedBox(
            width: width,
            child: Text(
              scheduleModel.day.substring(0, 3).toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          spaceH16,
          Expanded(child: LayoutBuilder(builder: (context, constraint) {
            return ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, isChecked, child) {
                return AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  child: isChecked
                      ? child!
                      : Text(
                          "Unavailable",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: kDisabledColor),
                        ),
                  layoutBuilder: (currentChild, previousChildren) => SizedBox(
                    width: constraint.maxWidth,
                    child: Stack(
                      children: [if (currentChild != null) currentChild],
                    ),
                  ),
                );
              },
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Row(
                  children: [
                    Flexible(
                      child: SlotChip(
                        group: txtGroup,
                        onSelected: (check) =>
                            onChipSelectionChange(check, sMorning),
                        text: sMorning,
                        isSelected: scheduleModel.events[sMorning] == 1,
                      ),
                    ),
                    spaceH8,
                    Flexible(
                      child: SlotChip(
                        group: txtGroup,
                        text: sAfternoon,
                        isSelected: scheduleModel.events[sAfternoon] == 1,
                        onSelected: (check) =>
                            onChipSelectionChange(check, sAfternoon),
                      ),
                    ),
                    spaceH8,
                    Flexible(
                      child: SlotChip(
                        group: txtGroup,
                        text: sEvening,
                        isSelected: scheduleModel.events[sEvening] == 1,
                        onSelected: (check) =>
                            onChipSelectionChange(check, sEvening),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }))
        ],
      ),
    );
  }
}
