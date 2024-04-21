import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/firebase_firestore.dart';
import 'data_state.dart';

part 'ui_version_provider.g.dart';

@Riverpod(keepAlive: true)
DataState uiVersion(UiVersionRef ref) => ref.watch(
      confProvider.select(
        (selected) => selected.when(
          data: (data) =>
              data.uiVersion != null ? Success(data.uiVersion!) : Loading(),
          error: (error, stack) => Error(error.toString(), stack),
          loading: () => Loading(),
        ),
      ),
    );
