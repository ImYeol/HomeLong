import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:homg_long/repository/friendRepository.dart';
import 'package:homg_long/repository/model/knockFeed.dart';
import 'package:homg_long/repository/userRepository.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// https://velog.io/@ezuunuu/Flutter-Firebasemessaging-%EB%B0%B1%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%A9%94%EC%84%B8%EC%A7%80
// https://doitduri.me/45
// https://uaremine.tistory.com/24

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  print(
      'Handling a background message $message : id ${message.category} : ${message.sentTime}');
  //KnockFeed knock = KnockFeed.fromJson(message.data);
  final pref = await SharedPreferences.getInstance();
  var messageList = pref.getStringList("messages") ?? <String>[];
  print("background message list : $messageList");
  messageList.add(jsonEncode(message.data));
  var success = await pref.setStringList("messages", messageList);
  if (success) print("success to save feed");
}

Future<void> loadFirebaseBackgroundMessages() async {
  final pref = await SharedPreferences.getInstance();
  var messageList = pref.getStringList("messages");
  print("loadFirebaseBackgroundMessages : $messageList");
  if (messageList != null) {
    messageList.forEach((message) {
      var map = jsonDecode(message);
      KnockFeed feed = KnockFeed.fromJson(map);
      FriendRepository().saveKnockFeed(feed);
    });
    pref.remove("messages");
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

late String? token;

void setUpFcmNotification() async {
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void handleFcmMessages() async {
  // get token
  // token expire condition :
  // 1) When user Uninstall/Reinstall the app or Clears App Data
  // 2) You manually delete FCM Instance using FirebaseMessaging().deleteInstanceID()
  token = await FirebaseMessaging.instance.getToken();
  print("fcm token : $token");

  // If the application is opened from a terminated state
  // a Future containing a RemoteMessage will be returned.
  // Once consumed, the RemoteMessage will be removed
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("initial message : ${message.data}");
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    }
  });

  // handle remote messages from FCM
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage message : ${message.data}");
    KnockFeed knock = KnockFeed.fromJson(message.data);
    FriendRepository().saveKnockFeed(knock);

    // RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    // if (notification != null && android != null) {
    //   flutterLocalNotificationsPlugin.show(
    //     notification.hashCode,
    //     notification.title,
    //     notification.body,
    //     NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         channel.id,
    //         channel.name,
    //         channelDescription: channel.description,
    //         // TODO add a proper drawable resource to android, for now using
    //         //      one that already exists in example app.
    //         icon: 'launch_background',
    //       ),
    //     ),
    //   );
    // }
  });

  // A Stream which posts a RemoteMessage when the application is opened from a background state.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    // Navigator.pushNamed(
    //   context,
    //   '/message',
    //   arguments: MessageArguments(message, true),
    // );
  });
}
