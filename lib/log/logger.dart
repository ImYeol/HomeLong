import 'package:logger/logger.dart';

class LogUtil {
  Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 3,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ),
  );
  static final LogUtil _logUtil = LogUtil._internal();

  factory LogUtil() => _logUtil;

  LogUtil._internal();
}
