import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/conf_repository.dart';
import '../models/data_state.dart';

part 'about_app_provider.g.dart';

@Riverpod(keepAlive: true)
DataState<String> aboutApp(AboutAppRef ref) =>
    ref.watch(confRepositoryProvider).when(
          data: (conf) => conf == null
              ? const Loading()
              : Success(
                  data: conf.desc ?? '',
                ),
          error: (error, stackTrace) => Error(
            error: error,
            stackTrace: stackTrace,
          ),
          loading: () => const Loading(),
        );
