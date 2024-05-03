import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/conf_repository.dart';
import 'data_state.dart';

part 'ui_version_provider.g.dart';

@Riverpod(keepAlive: true)
DataState<String> uiVersion(UiVersionRef ref) => ref.watch(
      confRepositoryProvider.select(
        (data) => switch (data) {
            Loading() => Loading(),
            Error() => Error(data.error, data.stackTrace),
            Success() => Success(data.data.uiVersion!),
          },
        ),
    );
