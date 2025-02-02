import 'package:logger/logger.dart';

class Log {
  static void d(dynamic message,
      {DateTime? time, dynamic error, StackTrace? stackTrace}) {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
      ),
    );

    logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }
}
