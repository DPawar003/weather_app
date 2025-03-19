import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,  // Number of method calls to include in the log
      errorMethodCount: 5, // Number of method calls for error logs
      lineLength: 80,  // Width of the log output
      colors: true, // Enable colored logs
      printEmojis: true, // Enable emojis for log levels
      // printTime: true, // Show timestamp in logs/////////
    ),
  );

  static void debug(String message) {
    _logger.d(message);
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
