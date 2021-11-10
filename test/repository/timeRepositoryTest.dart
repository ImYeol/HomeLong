import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homg_long/repository/db/timeDB.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:test/test.dart';

void main() {
  final repo = TimeRepository();

  setUpAll(() {
    print("seutUpAll");
    Hive.initFlutter();
    repo.init();
  });

  setUp(() async {
    print("seutUp");
    // clear DB
    await Hive.deleteBoxFromDisk(TimeDB.TIME_DB_NAME);
    final isOpened = await repo.openDatabase();
    expect(isOpened, true);
  });

  tearDown(() async {
    print("tearDown");
  });

  tearDownAll(() {
    print("tearDownAll");
    Hive.close();
  });

  test('test for a day after at home', () async {
    // enter : 2021-10-20 20:00
    DateTime enter = DateTime(2021, 10, 20, 20, 00);
    repo.saveEnterTime(enter);
    // exit : 2021-10-21 01:00
    DateTime exit = DateTime(2021, 10, 21, 1, 0);
    repo.saveExitTime(exit);

    // expected : 4 hours - 2021-10-20 20:00 ~ 24:00
    expect(repo.getTotalMinuteADay(enter), 4 * 60 * 60); // seconds
    // expected : 1 hours - 20201-10-21 00:00 ~ 01:00
    expect(repo.getTotalMinuteADay(exit), 1 * 60 * 60);
  });

  test('test for two days after at home', () async {
    // enter : 2021-10-20 20:00
    DateTime enter = DateTime(2021, 10, 20, 20, 00);
    repo.saveEnterTime(enter);
    // exit : 2021-10-22 01:00
    DateTime exit = DateTime(2021, 10, 22, 1, 0);
    repo.saveExitTime(exit);

    // expected : 4 hours - 2021-10-20 20:00 ~ 24:00
    expect(repo.getTotalMinuteADay(enter), 4 * 60 * 60); // seconds

    // expected : 24 hours - 2021-10-21 00:00 ~ 24:00
    expect(repo.getTotalMinuteADay(enter.add(Duration(days: 1))), 24 * 60 * 60);

    // expected : 1 hours - 20201-10-22 00:00 ~ 01:00
    expect(repo.getTotalMinuteADay(exit), 1 * 60 * 60);
  });

  test('test for multiple update homeTime', () {
    // enter: 2021-10-20 20:00
    DateTime enter1 = DateTime(2021, 10, 20, 20, 00);
    TimeRepository().saveEnterTime(enter1);

    // exit: 2021-10-20 20:05
    DateTime exit1 = DateTime(2021, 10, 20, 20, 05);
    TimeRepository().saveExitTime(exit1);

    expect(TimeRepository().getTotalMinuteADay(enter1), 5 * 60);

    // enter: 2021-10-20 20:05
    DateTime enter2 = DateTime(2021, 10, 20, 20, 05);
    TimeRepository().saveEnterTime(enter2);

    // exit: 2021-10-20 20:10
    DateTime exit2 = DateTime(2021, 10, 20, 20, 10);
    TimeRepository().saveExitTime(exit2);

    expect(TimeRepository().getTotalMinuteADay(enter1), 10 * 60);

    // enter: 2021-10-20 20:10
    DateTime enter3 = DateTime(2021, 10, 20, 20, 10);
    TimeRepository().saveEnterTime(enter3);

    // exit: 2021-10-20 20:15
    DateTime exit3 = DateTime(2021, 10, 20, 20, 15);
    TimeRepository().saveExitTime(exit3);

    expect(TimeRepository().getTotalMinuteADay(enter1), 15 * 60);
  });
}
