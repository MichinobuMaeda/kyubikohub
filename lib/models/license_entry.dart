import 'package:freezed_annotation/freezed_annotation.dart';

part 'license_entry.freezed.dart';

@freezed
class LicenseEntry with _$LicenseEntry {
  const factory LicenseEntry({
    required String title,
    required String body,
  }) = _LicenseEntry;
}
