import 'package:freezed_annotation/freezed_annotation.dart';

part 'about.freezed.dart';

@freezed
class About with _$About {
  const factory About({
    required String guide,
    required String policy,
  }) = _About;
}
