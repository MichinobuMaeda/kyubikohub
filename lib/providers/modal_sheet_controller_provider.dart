import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'modal_sheet_controller_provider.g.dart';

@Riverpod(keepAlive: true)
class ModalSheetControllerProvider extends _$ModalSheetControllerProvider {
  @override
  PersistentBottomSheetController? build() => null;

  void set(PersistentBottomSheetController controller) {
    state = controller;
  }

  void close() {
    state?.close();
    state = null;
  }
}
