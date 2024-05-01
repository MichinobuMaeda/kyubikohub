import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/firebase_auth.dart';
import 'data_state.dart';

part 'auth_loaded_state_provider.g.dart';

@riverpod
Future<bool> authLoadedState(AuthLoadedStateRef ref) => ref.watch(
      firebaseAuthRepositoryProvider.selectAsync(
        (authUser) => authUser is Success,
      ),
    );
