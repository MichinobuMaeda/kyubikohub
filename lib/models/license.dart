import 'package:freezed_annotation/freezed_annotation.dart';

part 'license.freezed.dart';

@freezed
class License with _$License {
  const factory License({
    required String title,
    required String body,
  }) = _License;
}
