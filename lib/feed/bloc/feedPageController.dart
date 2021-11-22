import 'package:homg_long/feed/model/knockFeed.dart';

class FeedPageController {
  List<KnockFeed> knockFeeds = [
    KnockFeed(
        id: "1", name: "asdf1", image: "", date: DateTime.now().toString()),
    KnockFeed(
        id: "2", name: "asdf12", image: "", date: DateTime.now().toString()),
    KnockFeed(
        id: "3", name: "asdf123", image: "", date: DateTime.now().toString()),
    KnockFeed(
        id: "4", name: "asdf1234", image: "", date: DateTime.now().toString()),
    KnockFeed(
        id: "5", name: "asdf12345", image: "", date: DateTime.now().toString()),
    KnockFeed(
        id: "6",
        name: "asdf123456",
        image: "",
        date: DateTime.now().toString()),
  ];
  Future<List<KnockFeed>> loadFriends() async {
    return await Future.delayed(Duration(milliseconds: 500), () {
      return knockFeeds;
    });
  }
}
