import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:weekly_scheduler/Components/day_schedule_viewer.dart';
import 'package:weekly_scheduler/Config/size_config.dart';
import 'package:weekly_scheduler/Values/color.dart';
import 'package:weekly_scheduler/ViewModels/scheduler_view_model.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizec = SizeConfig();
    sizec.init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                  width: sizec.screenWidth,
                  height: sizec.screenHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Text(
                          "Set your weekly hours",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Expanded(
                        child: Consumer<SchedulerViewModel>(
                            builder: (context, schedulerViewModel, _) {
                          return ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  bottom: 64, left: 8, right: 8),
                              itemBuilder: (context, index) =>
                                  DayScheduleViewer(
                                    onChange: (data) {
                                      schedulerViewModel
                                          .changableScheduleList[index] = data;
                                    },
                                    scheduleModel: schedulerViewModel
                                        .changableScheduleList[index],
                                  ),
                              separatorBuilder: (context, index) => Divider(
                                    color: index % 2 == 0
                                        ? kDividerDarkGreyColor
                                        : kDividerLightGreyColor,
                                  ),
                              itemCount: schedulerViewModel
                                  .changableScheduleList.length);
                        }),
                      ),
                    ],
                  )),
              Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                        style: Theme.of(context)
                            .elevatedButtonTheme
                            .style
                            ?.copyWith(
                              fixedSize: MaterialStateProperty.all(Size(
                                  min(350, sizec.blockSizeHorizontal! * 80),
                                  45)),
                            ),
                        onPressed: saveSchedules,
                        child: const Text("Save")),
                  ))
            ],
          ),
        ));
  }

  void saveSchedules() async {
    var result = await context.read<SchedulerViewModel>().updateSchedules();
    if (result) {
      Fluttertoast.showToast(msg: "Saved");
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
