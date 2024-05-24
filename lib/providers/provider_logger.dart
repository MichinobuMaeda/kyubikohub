import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/data_state.dart';

const maxLength = 512;

String valueToString(Object? value) {
  final val = value is AsyncValue ? value.value : value;
  final data = val is Success ? val.data : val;
  final str = "$data";
  return str.length > maxLength ? str.substring(0, maxLength) : str;
}

class ProviderLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint(
      '''
ADDED   : [${provider.name}] ${valueToString(value)}''',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '''
UPDATED : [${provider.name}] ${valueToString(previousValue)}'
  --> ${valueToString(newValue)}''',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint(
      '''
DISPOSED: [${provider.name}]''',
    );
  }
}
