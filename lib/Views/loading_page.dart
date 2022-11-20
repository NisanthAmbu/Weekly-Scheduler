import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_scheduler/Dialogs/set_username_dialog.dart';
import 'package:weekly_scheduler/Values/color.dart';
import 'package:weekly_scheduler/Values/string_values.dart';
import 'package:weekly_scheduler/ViewModels/scheduler_view_model.dart';
import 'package:weekly_scheduler/Views/home_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => checkUserNameAddedOrNot(),
    );
    super.initState();
  }

  void checkUserNameAddedOrNot() async {
    final navigator = Navigator.of(context);
    final setNameDialog = SetUsernameDialogBox(context: context);
    final scheduleProvider =
        Provider.of<SchedulerViewModel>(context, listen: false);
    final sharedPref = await SharedPreferences.getInstance();
    dynamic result = sharedPref.getString(sUserNameKey);
    dynamic isBlocked = sharedPref.getBool(sBlockKey) ?? false;
    if (!isBlocked) {
      dynamic result = await setNameDialog.show();

      if (result is String) {
        sharedPref.setString(sUserNameKey, result);
        sharedPref.setBool(sBlockKey, true);
        scheduleProvider.setUserName = result;
      }

      if (mounted) {
        navigator.pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      }
      return;
    }
    if (mounted) {
      scheduleProvider.setUserName = result;
      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => const HomePage(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            return const Center(
              child: CircularProgressIndicator(
                color: kButtonColor,
              ),
            );
          }),
    );
  }
}
