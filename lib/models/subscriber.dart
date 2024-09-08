import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscriber.freezed.dart';

@freezed
class Subscriber with _$Subscriber {
  const factory Subscriber({
    required String id,
    required String siteId,
    required String siteName,
    required String name,
    required String email,
    required String tel,
    required String zip,
    required String pref,
    required String city,
    required String addr,
    required String bldg,
    required String desc,
    required DateTime createdAt,
    required String createdBy,
    required DateTime updatedAt,
    required String updatedBy,
    required DateTime? deletedAt,
    required String? deletedBy,
    required DateTime? approvedAt,
    required String? approvedBy,
    required DateTime? rejectedAt,
    required String? rejectedBy,
    required DateTime? completedAt,
    required String? completedBy,
  }) = _Subscriber;
}
