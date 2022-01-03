import 'package:hive/hive.dart';
import 'package:homg_long/repository/model/knockFeed.dart';
import 'package:logging/logging.dart';

class KnockDB {
  static const String KNOCK_DB_NAME = "KnockDB";

  final log = Logger("KnockDB");

  void init() {
    Hive.registerAdapter(KnockFeedAdapter());
  }

  Future<bool> openDatabase() async {
    final userDbBox = Hive.isBoxOpen(KNOCK_DB_NAME)
        ? Hive.box(KNOCK_DB_NAME)
        : await Hive.openBox(KNOCK_DB_NAME);
    return userDbBox.isOpen;
  }

  Future<int> saveKnockFeed(KnockFeed feed) {
    final result = Hive.box(KNOCK_DB_NAME).add(feed);
    log.info("saveKnockFeed - id = $feed");
    return result;
  }

  Future<List<KnockFeed>> loadAllKnockFeed() async {
    log.info("loadAllKnockFeed");
    var feedList = Hive.box(KNOCK_DB_NAME).values.toList();
    return feedList.cast<KnockFeed>();
  }
}
