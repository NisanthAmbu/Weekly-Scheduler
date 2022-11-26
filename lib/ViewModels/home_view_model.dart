import 'package:weekly_scheduler/Models/schedule_model.dart';

class HomeViewModel
{
    String getScheduleDatesToString(List<ScheduleModel> scheduleList) {
    var defultMsg = "you are";
    var availableTimes = "available on";
    for (var element in scheduleList) {
      if (element.isActive) {
        availableTimes +=
            "${availableTimes != "available on" ? ", " : " "}${element.day} ";
        if (element.events.length == 3) {
          availableTimes += "whole day";
          continue;
        }
        var eventEntries = element.events.entries;
        int i = 0;
        for (var event in eventEntries) {
          i++;
          availableTimes += i == 1
              ? "${event.key}"
              : (i == eventEntries.length ? " and " : ", ") + event.key;
        }
      }
    }
    if (availableTimes == "available on") {
      return "$defultMsg not available this week";
    }

    return "$defultMsg $availableTimes";
  }
}