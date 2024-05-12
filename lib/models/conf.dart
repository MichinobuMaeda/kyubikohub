import 'package:freezed_annotation/freezed_annotation.dart';

part 'conf.freezed.dart';

@freezed
class Conf with _$Conf {
  const factory Conf({
    required String? uiVersion,
    required String? desc,
  }) = _Conf;
}
