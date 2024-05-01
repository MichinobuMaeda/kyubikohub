import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/license_entry.dart';
import '../repositories/license_repository.dart';
import 'data_state.dart';

part 'license_entries_provider.g.dart';

@Riverpod(keepAlive: true)
DataState<List<LicenseEntry>> licenseEntry(LicenseEntryRef ref) =>
    ref.watch(licenseRepositoryProvider).when(
          data: (data) => Success(data
              .map((entry) => LicenseEntry(
                    title: entry.packages.toList().join(', '),
                    body: entry.paragraphs
                        .toList()
                        .map((p) => p.text.trim())
                        .join('\n\n'),
                  ))
              .toList()),
          error: (error, stack) => Error(error.toString(), stack),
          loading: () => Loading(),
        );
