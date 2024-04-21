import 'package:flutter/material.dart';

sealed class DataState {}

class Loading extends DataState {}

class Error extends DataState {
  final String message;

  Error(Object error, StackTrace stackTrace)
      : message = "${error.toString()}\n\n${stackTrace.toString()}" {
    debugPrintStack(label: error.toString(), stackTrace: stackTrace);
  }
}

class Success<T> extends DataState {
  final T data;
  Success(this.data);
}
