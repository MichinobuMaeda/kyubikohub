import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user.dart';
import '../repositories/firebase_firestore.dart';
import 'data_state.dart';

part 'me_provider.g.dart';

@Riverpod(keepAlive: true)
DataState me(MeRef ref) => ref.watch(myAccountProvider).when(
      data: (myAccount) => ref.watch(usersProvider).when(
            data: (users) => Success<User>(
              users.singleWhere((user) => user.id == myAccount.user),
            ),
            error: (error, stackTrace) => Error(error, stackTrace),
            loading: () => Loading(),
          ),
      error: (error, stackTrace) => Error(error, stackTrace),
      loading: () => Loading(),
    );
