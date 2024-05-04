import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/conf_repository.dart';
import '../models/data_state.dart';

part 'ui_version_provider.g.dart';

@Riverpod(keepAlive: true)
DataState<String> uiVersion(UiVersionRef ref) => ref.watch(
      confRepositoryProvider.select(
        (conf) => switch (conf) {
          Loading() => const Loading(),
          Error() => Error(error: conf.error, stackTrace: conf.stackTrace),
          Success() => Success(data: conf.data.uiVersion!),
        },
      ),
    );
