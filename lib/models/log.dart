import 'package:freezed_annotation/freezed_annotation.dart';

part 'log.freezed.dart';

enum LogLevel {
  error('error'),
  warn('warn'),
  info('info');

  final String value;
  const LogLevel(this.value);
}

@freezed
class Log with _$Log {
  const factory Log({
    required DateTime ts,
    required LogLevel level,
    required String user,
    required String message,
  }) = _Log;
}
