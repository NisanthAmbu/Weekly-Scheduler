import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_scheduler/Config/size_config.dart';
import 'package:weekly_scheduler/Values/color.dart';
import 'package:weekly_scheduler/ViewModels/home_view_model.dart';
import 'package:weekly_scheduler/ViewModels/scheduler_view_model.dart';
import 'package:weekly_scheduler/Views/scheduler_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeViewModel = HomeViewModel();
  @override
  void initState() {
    super.initState();
    Provider.of<SchedulerViewModel>(context, listen: false).getSchedules();
  }

  @override
  Widget build(BuildContext context) {
    final sizec = SizeConfig();
    sizec.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<SchedulerViewModel>(
          builder: (context, scheduleViewModel, child) => scheduleViewModel
                  .isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: kButtonColor,
                  ),
                )
              : TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 6,
                          top: 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          "Hi ${scheduleViewModel.userName} \n",
                                      children: [
                                        TextSpan(
                                          text: homeViewModel
                                              .getScheduleDatesToString(
                                                  scheduleViewModel
                                                      .scheduleList),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                  color: Colors.grey.shade500),
                                        )
                                      ],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                  style: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.copyWith(
                                        fixedSize: MaterialStateProperty.all(
                                            Size(
                                                min(
                                                    350,
                                                    sizec.blockSizeHorizontal! *
                                                        80),
                                                45)),
                                      ),
                                  onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const SchedulerPage(),
                                      )),
                                  child: Text(scheduleViewModel.isEmpty
                                      ? "Add Schedule"
                                      : "Edit Schedule")),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
