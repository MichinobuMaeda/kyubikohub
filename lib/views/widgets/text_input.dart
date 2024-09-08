import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../validators.dart';

class TextInput extends HookConsumerWidget {
  final TextInputParam param;
  const TextInput({
    super.key,
    required this.param,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      maxLines: param.maxLines,
      onChanged: (value) {
        param.notifier.value = param.validator(value);
      },
      decoration: InputDecoration(
        labelText: param.label,
        helperText: param.helperText,
        errorText: param.notifier.value.match((l) => l, (r) => null),
      ),
    );
  }
}
