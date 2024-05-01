import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/about.dart';
import '../repositories/conf_repository.dart';
import 'data_state.dart';

part 'about_app_provider.g.dart';

@Riverpod(keepAlive: true)
DataState<About> aboutApp(AboutAppRef ref) => ref.watch(
      confRepositoryProvider.select(
        (selected) => selected.when(
          data: (data) => switch (data) {
            Loading() => Loading(),
            Error() => Error(data.error, data.stackTrace),
            Success() => Success(
                About(
                  guide: data.data.guide ?? '',
                  policy: data.data.policy ?? '',
                ),
              ),
          },
          error: (error, stack) => Error(error, stack),
          loading: () => Loading(),
        ),
      ),
    );
