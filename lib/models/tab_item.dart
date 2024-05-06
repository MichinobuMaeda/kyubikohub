import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_item.freezed.dart';

@freezed
class TabItem with _$TabItem {
  const factory TabItem({
    required IconData icon,
    required String label,
    required Widget page,
  }) = _TabItem;
}
