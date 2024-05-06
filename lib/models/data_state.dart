import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_state.freezed.dart';

sealed class DataState<T> {
  // ignore: unused_element
  const DataState._(); // Due to spec. of the package 'freezed'
  const DataState(); // Due to spec. of the package 'freezed'
}

@freezed
class Loading<T> extends DataState<T> with _$Loading<T> {
  const factory Loading() = _Loading;
}

@freezed
class Error<T> extends DataState<T> with _$Error<T> {
  const Error._(); // Due to spec. of the package 'freezed'
  const factory Error({
    required Object error,
    required StackTrace stackTrace,
  }) = _Error;

  String get message => '${error.toString()}\n\n${stackTrace.toString()}';
}

@Freezed(genericArgumentFactories: true)
class Success<T> extends DataState<T> with _$Success<T> {
  const factory Success({
    required T data,
  }) = _Success;
}
