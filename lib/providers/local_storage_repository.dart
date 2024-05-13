import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_storage_repository.g.dart';

enum LocalStorageKey {
  site(name: 'site');

  final String name;
  const LocalStorageKey({required this.name});
}

@Riverpod(keepAlive: true)
SharedPreferences? localStorageRepository(LocalStorageRepositoryRef ref) =>
    null;
