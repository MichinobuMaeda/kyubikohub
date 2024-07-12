import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscriber.freezed.dart';

@freezed
class Subscriber with _$Subscriber {
  const factory Subscriber({
    required String id,
    required String site,
    required String name,
    required String email,
    required String tel,
    required String zip,
    required String prefecture,
    required String city,
    required String address1,
    required String address2,
    required String desc,
    required String managerName,
    required String managerEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    required DateTime deletedAt,
    required String deletedBy,
    required DateTime approvedAt,
    required String approvedBy,
    required DateTime rejectedAt,
    required String rejectedBy,
    required DateTime completedAt,
    required String completedBy,
  }) = _Subscriber;
}
