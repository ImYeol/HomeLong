import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:homg_long/home/bloc/counterCubit.dart';
import 'package:homg_long/repository/db/timeDB.dart';
import 'package:homg_long/repository/timeRepository.dart';
import 'package:homg_long/screen/bloc/userActionEventObserver.dart';
import 'package:homg_long/screen/bloc/userActionManager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockUserActionManager extends Mock with UserActionManager {}

void main() {
  final repo = TimeRepository();
  final mockUserActionManager = MockUserActionManager();
  CounterCubit cubit = CounterCubit(mockUserActionManager);

  // called only once
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

    cubit = CounterCubit(mockUserActionManager);
  });

  tearDown(() async {
    print("tearDown");
    cubit.stopCounter();
  });

  tearDownAll(() {
    print("tearDownAll");
    Hive.close();
  });

  test('test for update last enterTime when day changed', () {
    // enter : 2021-10-20 20:00
    DateTime enter = DateTime(2021, 10, 20, 20, 00);
    TimeRepository().saveEnterTime(enter);
    cubit.onUserActionChanged(UserActionType.ENTER_HOME, enter);
    cubit.stopCounter();

    // current counter time : 2021-10-21-00:00
    DateTime now = DateTime(2021, 10, 21, 0, 0);
    cubit.updateLastEnterTimesIfdayChanged(now);

    // expected 20:00 ~ 00:00 updated for total time
    expect(TimeRepository().getTotalMinuteADay(enter), 4 * 60 * 60);
    // expected midnight as start time of next day
    expect(TimeRepository().getEnterTime().compareTo(now), 0);
  });
}
