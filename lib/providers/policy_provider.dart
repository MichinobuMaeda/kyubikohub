import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/firebase_firestore.dart';
import 'data_state.dart';

part 'policy_provider.g.dart';

@Riverpod(keepAlive: true)
DataState policy(PolicyRef ref) => ref.watch(
      confProvider.select(
        (selected) => selected.when(
          data: (data) => Success(data.policy ?? ''),
          error: (error, stack) => Error(error.toString(), stack),
          loading: () => Loading(),
        ),
      ),
    );
