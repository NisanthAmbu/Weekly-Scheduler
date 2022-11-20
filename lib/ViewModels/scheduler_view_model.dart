import 'package:flutter/cupertino.dart';
import 'package:weekly_scheduler/Database/Tables/schedule_table.dart';
import 'package:weekly_scheduler/Database/local_database.dart';
import 'package:weekly_scheduler/Models/schedule_model.dart';
import 'package:weekly_scheduler/Values/string_values.dart';

class SchedulerViewModel extends ChangeNotifier {
  bool isloading = true;
  bool isEmpty = true;
  String userName = "User";
  List<ScheduleModel> scheduleList = [];
  List<ScheduleModel> changableScheduleList = [];
  void getSchedules() async {
    changableScheduleList.clear();
    scheduleList.clear();
    var currentDate = DateTime.now();
    dynamic result = await LocalDatabase.getDataFromTable(
        currentDate.firstDayOfWeek.dateString,
        currentDate.lastDayOfWeek.dateString);

    if (result is! List<Map<String, Object?>>) {
      return;
    }

    for (int i = 0; i < days.length; i++) {
      bool isSet = false;
      for (int j = 0; j < result.length; j++) {
        if (days[i] == result[j][ScheduleTable.day]) {
          isSet = true;
          var scheduleData = ScheduleModel.fromMap(result[j]);
          if (scheduleData.isActive) {
            isEmpty = false;
          }
          scheduleList.add(scheduleData);
          break;
        }
      }
      if (!isSet) {
        scheduleList.add(ScheduleModel.empty(i, days[i]));
      }
    }
    changableScheduleList = List.from(scheduleList);
    setIsLoading = false;
  }

  set setIsLoading(bool loading) {
    isloading = loading;
    notifyListeners();
  }

  set setUserName(name) => userName = name ?? "User";

  Future<bool> updateSchedules() async {
    var currentDate = DateTime.now();
    await LocalDatabase.deleteFromTable(currentDate.firstDayOfWeek.dateString,
        currentDate.lastDayOfWeek.dateString);
    await LocalDatabase.insertIntoTableTransation(changableScheduleList);
    setIsLoading = true;
    Future.delayed(
      const Duration(milliseconds: 200),
      () => getSchedules(),
    );
    return true;
  }
}
