import 'package:flutter/material.dart';

sealed class DataState<T> {}

class Loading<T> extends DataState<T> {}

class Error<T> extends DataState<T> {
  final String message;
  final Object error;
  final StackTrace stackTrace;

  Error(this.error, this.stackTrace)
      : message = "${error.toString()}\n\n${stackTrace.toString()}" {
    debugPrintStack(label: error.toString(), stackTrace: stackTrace);
  }
}

class Success<T> extends DataState<T> {
  final T data;
  Success(this.data);
}
