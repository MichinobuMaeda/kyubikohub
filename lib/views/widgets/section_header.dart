import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';

class SectionHeader extends HookConsumerWidget {
  final double height;
  final Color? color;
  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  const SectionHeader({
    super.key,
    this.height = sectionHeaderHeight,
    this.color,
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => PinnedHeaderSliver(
        child: Container(
          color: color ?? sectionHeaderColor(context),
          height: sectionHeaderHeight,
          child: ListTile(
            leading: leading,
            trailing: trailing,
            title: title,
            style: ListTileStyle.list,
            onTap: onTap,
          ),
        ),
      );
}
