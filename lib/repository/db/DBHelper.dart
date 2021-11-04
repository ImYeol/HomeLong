import 'package:homg_long/log/logger.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static String userInfoTable = 'userinfo';
  static String timeInfoTable = 'timeinfo';
  static final String _DBPath = 'homebody.db';

  final logUtil = LogUtil();
  static final log = Logger("DBHelper");

  static final DBHelper _instance = DBHelper._internal();
  DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database?> get getDatabase async {
    if (_database != null && _database!.isOpen) {
      log.info("getDatabase opened");
      return _database;
    }
    log.info("getDatabase start init");
    initDB();
    return _database;
    // _database = await _initDB();
    // return _database;
  }

  static void initDB() async {
    log.info("initDB");

    String path = join(await getDatabasesPath(), _DBPath);
    log.info("database initialize(path=$path)");

    if (_database != null && _database!.isOpen) {
      log.info("database already opened");
      return;
    }
    log.info("database start to open");
    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      log.info("database created");
      await db.execute('''
        create table $userInfoTable(id TEXT PRIMARY KEY, name TEXT, image TEXT, ssid TEXT, bssid TEXT, street TEXT, initDate INTEGER, latitude REAL, longitude REAL)
        ''');
      await db.execute('''
          CREATE TABLE $timeInfoTable(date TEXT PRIMARY KEY, timeList TEXT, totalMinute INTEGER)
          ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
    if (_database!.isOpen) {
      log.info("database opened");
    }
    log.info("database open failed");
  }
}
