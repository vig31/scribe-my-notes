import 'package:logger/logger.dart';

class CustomLogger {
  static final CustomLogger _instance = CustomLogger._internal();

  late final Logger _logger;

  factory CustomLogger() {
    return _instance;
  }

  CustomLogger._internal() {
    _logger = Logger();
  }

  void logDebug(String message) {
    _logger.d(message);
  }

  void logInfo(String message) {
    _logger.i(message);
  }

  void logWarning(String message) {
    _logger.w(message);
  }

  void logError(String message) {
    _logger.e(message);
  }

  void logFatelException({required Object error, StackTrace? stack}) {
    _logger.f(error, error: error, stackTrace: stack);
  }
}
