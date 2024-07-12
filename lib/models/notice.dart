import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice.freezed.dart';

@freezed
class Notice with _$Notice {
  const factory Notice({
    required String id,
    required String title,
    required String message,
    required String? note,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required DateTime? deletedAt,
  }) = _Notice;
}
