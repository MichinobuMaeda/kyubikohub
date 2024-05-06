import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/conf_repository.dart';
import '../models/data_state.dart';

part 'ui_version_provider.g.dart';

@Riverpod(keepAlive: true)
DataState<String> uiVersion(UiVersionRef ref) =>
    ref.watch(confRepositoryProvider).when(
          data: (conf) => conf == null
              ? const Loading()
              : Success(
                  data: conf.uiVersion ?? '',
                ),
          error: (error, stackTrace) => Error(
            error: error,
            stackTrace: stackTrace,
          ),
          loading: () => const Loading(),
        );
