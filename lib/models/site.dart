import 'package:freezed_annotation/freezed_annotation.dart';

part 'site.freezed.dart';

@freezed
class Site with _$Site {
  const factory Site({
    required String id,
    required String name,
    required String forGuests,
    required String forMembers,
    required String forMangers,
    required bool deleted,
  }) = _Site;
}
