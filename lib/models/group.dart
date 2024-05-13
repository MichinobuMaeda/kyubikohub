import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required List<String> users,
    required DateTime? deletedAt,
  }) = _Group;
}
