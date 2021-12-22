import 'package:hive_flutter/hive_flutter.dart';
part 'dailys.g.dart';

// after changes run: flutter packages pub run build_runner build

const dailyBoxName = 'DailyBox';
const dailyHistoryBoxName = 'HistoryBox';

@HiveType(typeId: 0)
class DailyData extends HiveObject {

  @HiveField(0)
  int id;

  @HiveField(1)
  String task;

  DailyData(this.id, this.task);

  @override
  String toString() {
    return task;
  }
}


@HiveType(typeId: 1)
class DailyHistory extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  late HiveList dailys;

  DailyHistory(this.date, this.dailys);

  @override
  String toString() {
    return '$date';
  }
}