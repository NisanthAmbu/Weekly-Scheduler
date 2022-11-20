import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_scheduler/Database/local_database.dart';
import 'package:weekly_scheduler/Values/color.dart';
import 'package:weekly_scheduler/Values/const_values.dart';
import 'package:weekly_scheduler/ViewModels/scheduler_view_model.dart';
import 'package:weekly_scheduler/Views/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabase.init();
  runApp(ChangeNotifierProvider(
      create: (context) => SchedulerViewModel(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weekly Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kButtonColor),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kButtonRadius),
                )))),
      ),
      home: const LoadingPage(),
    );
  }
}
