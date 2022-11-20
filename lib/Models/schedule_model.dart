import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weekly_scheduler/Database/Tables/schedule_table.dart';

class ScheduleModel {
  final int id;
  final Map events;
  final String day;
  final DateTime date;
  final bool isActive;

  ScheduleModel({
    required this.id,
    required this.events,
    required this.day,
    required this.date,
    this.isActive = false,
  });

  factory ScheduleModel.empty(index, day) {
    return ScheduleModel(
        id: index,
        events: {},
        day: day,
        date: DateTime.now().firstDayOfWeek.add(Duration(days: index)));
  }

  ScheduleModel copyWith({
    int? id,
    Map? events,
    String? day,
    dynamic date,
    bool? isActive,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      events: events ?? this.events,
      day: day ?? this.day,
      date: date ?? this.date,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'events': events,
      'day': day,
      'date': date,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toMapforDb() {
    return {
      ScheduleTable.events: jsonEncode(events),
      ScheduleTable.day: day,
      ScheduleTable.date: date.dateString,
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map[ScheduleTable.id]?.toInt() ?? 0,
      events: Map.from(json.decode(map[ScheduleTable.events]) ?? {}),
      day: map[ScheduleTable.day] ?? '',
      date: DateTime.parse("${map[ScheduleTable.date]}"),
      isActive:
          Map.from(json.decode(map[ScheduleTable.events]) ?? {}).isNotEmpty,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScheduleModel(id: $id, events: $events, day: $day, date: $date, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScheduleModel &&
        other.id == id &&
        mapEquals(other.events, events) &&
        other.day == day &&
        other.date == date &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        events.hashCode ^
        day.hashCode ^
        date.hashCode ^
        isActive.hashCode;
  }
}

extension DateTimeExtension on DateTime {
  DateTime get firstDayOfWeek =>
      subtract(Duration(days: weekday == 7 ? 0 : weekday));

  DateTime get lastDayOfWeek {
    return add(Duration(
        days: DateTime.daysPerWeek - ((weekday == 7 ? 0 : weekday) + 1)));
  }

  String get dateString => "$year-$month-$day";
}
