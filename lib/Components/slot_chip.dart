import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:weekly_scheduler/Components/round_check_box.dart';
import 'package:weekly_scheduler/Values/color.dart';

class SlotChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final AutoSizeGroup? group;
  final OnChange onSelected;
  const SlotChip({
    Key? key,
    required this.text,
    required this.isSelected,
    this.group,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueNotifier = ValueNotifier<bool>(isSelected);
    return ValueListenableBuilder(
        valueListenable: valueNotifier,
        child: AutoSizeText(
          text,
          group: group,
        ),
        builder: (context, value, child) {
          return RawChip(
              pressElevation: 0,
              labelStyle:
                  TextStyle(color: value ? kButtonColor : kDisabledColor),
              label: child!,
              onPressed: () {
                valueNotifier.value = !valueNotifier.value;
                onSelected(valueNotifier.value);
              },
              backgroundColor: Colors.white,
              elevation: 0,
              side: BorderSide(
                  color: value ? kButtonColor : kDisabledColor, width: 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)));
        });
  }
}
