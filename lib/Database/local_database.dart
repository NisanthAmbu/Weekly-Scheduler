import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:weekly_scheduler/Database/Tables/schedule_table.dart';
import 'package:weekly_scheduler/Models/schedule_model.dart';

class LocalDatabase {
  static bool opened = false;

  static late Database _sqliteDb;
  static String sqliteDbName = 'schedule.db';

  static Future<void> init() async {
    String databasesPath = await getDatabasesPath();
    String userDBPath = join(databasesPath, sqliteDbName);
    _sqliteDb = await openDatabase(
      userDBPath,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute(
            "CREATE TABLE IF NOT EXISTS '${ScheduleTable.tableName}' ('${ScheduleTable.id}'	INTEGER,'${ScheduleTable.events}'	TEXT NOT NULL,'${ScheduleTable.day}'	TEXT NOT NULL,'${ScheduleTable.date}'	DATE NOT NULL,PRIMARY KEY('id' AUTOINCREMENT))");
      },
    );
    opened = true;
  }

  static Future<bool> insertIntoTable(ScheduleModel data) async {
    var result = await _sqliteDb.insert(
      ScheduleTable.tableName,
      data.toMapforDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result != 0;
  }

  static dynamic getDataFromTable(startDate, endDate) async {
    try {
      return await _sqliteDb.query(ScheduleTable.tableName,
          where:
              "DATE(${ScheduleTable.date})>=DATE(?) AND DATE(${ScheduleTable.date})<=DATE(?)",
          whereArgs: [startDate, endDate]);
    } catch (e) {
      return false;
    }
  }

  static dynamic deleteFromTable(startDate, endDate) async {
    return await _sqliteDb.delete(ScheduleTable.tableName,
        where:
            "DATE(${ScheduleTable.date}) >= DATE(?) AND DATE(${ScheduleTable.date}) <= DATE(?)",
        whereArgs: [startDate, endDate]);
  }

  static dynamic insertIntoTableTransation(
      List<ScheduleModel> newScheduleList) async {
    await _sqliteDb.transaction((txn) async {
      await Future.wait(newScheduleList
          .map((e) => txn.insert(ScheduleTable.tableName, e.toMapforDb()))
          .toList());
    });
  }
}
