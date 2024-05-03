import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/firebase_auth.dart';
import 'data_state.dart';

part 'auth_loaded_state_provider.g.dart';

@riverpod
bool authLoadedState(AuthLoadedStateRef ref) => ref.watch(
      firebaseAuthRepositoryProvider.select(
        (authUser) => authUser is Success,
      ),
    );
