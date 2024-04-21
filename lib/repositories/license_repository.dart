import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'license_repository.g.dart';

@Riverpod(keepAlive: true)
Future<List<LicenseEntry>> licenseRepository(LicenseRepositoryRef ref) =>
    LicenseRegistry.licenses.toList();
