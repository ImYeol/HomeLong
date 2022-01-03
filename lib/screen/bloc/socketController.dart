import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class SocketController extends GetxService {
  late IOWebSocketChannel? channel; //channel varaible for websocket
  bool connected = false; // boolean value to track connection status

  void openChannel() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.0.109:6060/"); //channel IP : Port
      channel!.stream.listen(
        receiveMessage,
        onDone: socketClosed,
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  void closeChannel() {
    channel?.sink.close();
  }

  void receiveMessage(dynamic message) {}

  void socketClosed() {
    print("Web socket is closed");
    connected = false;
  }
}
