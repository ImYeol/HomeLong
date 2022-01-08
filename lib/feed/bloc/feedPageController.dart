import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/knockFeed.dart';

class FeedPageController {
  FriendRepository repository;
  List<KnockFeed> knockFeeds = <KnockFeed>[];

  FeedPageController({required this.repository});

  Future<List<KnockFeed>> loadFriends() async {
    knockFeeds = await repository.loadAllKnockFeed();
    return knockFeeds;
  }
}
