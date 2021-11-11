import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homg_long/repository/db/timeDB.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:test/test.dart';

void main() {
  final db = TimeDB();

  // called only once
  setUpAll(() {
    print("seutUpAll");
    Hive.initFlutter();
    db.init();
  });

  setUp(() async {
    print("seutUp");
    // clear DB
    await Hive.deleteBoxFromDisk(TimeDB.TIME_DB_NAME);
    final isOpened = await db.openDatabase();
    expect(isOpened, true);
  });

  tearDown(() async {
    print("tearDown");
  });

  tearDownAll(() {
    print("tearDownAll");
    Hive.close();
  });

  test('test for clear enter and exit time', () {
    // enter: 2021-10-20 20:00
    DateTime enter1 = DateTime(2021, 10, 20, 20, 00);
    db.saveEnterTime(enter1);

    // exit: 2021-10-20 20:05
    DateTime exit1 = DateTime(2021, 10, 20, 20, 05);
    db.saveExitTime(exit1);

    db.clearEnterAndExitTime();

    expect(db.getEnterTime().toString(), TimeRepository.INVALID_DATE_TIME);
    expect(db.getExitTime().toString(), TimeRepository.INVALID_DATE_TIME);
  });
}
