import 'package:flutter/material.dart';
import 'package:weekly_scheduler/Values/color.dart';

class RoundCheckBox extends StatelessWidget {
  final bool isCheck;
  final double size;
  final OnChange onChange;
  const RoundCheckBox({
    Key? key,
    required this.isCheck,
    this.size = 25,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkNotifier = ValueNotifier<bool>(isCheck);
    return AnimatedBuilder(
        animation: checkNotifier,
        builder: (context, child) {
          return InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              checkNotifier.value = !checkNotifier.value;
              onChange(checkNotifier.value);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: checkNotifier.value
                    ? kCheckBoxActiveColor
                    : kCheckBoxDisabledColor,
                border: Border.all(
                  color: checkNotifier.value
                      ? kCheckBoxActiveColor
                      : kDividerLightGreyColor,
                  width: 2,
                ),
              ),
              child: checkNotifier.value
                  ? Icon(
                      Icons.check,
                      size: size * .70,
                      color: Colors.white,
                    )
                  : const SizedBox(),
            ),
          );
        });
  }
}

typedef OnChange = Function(bool check);
