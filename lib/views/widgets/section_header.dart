import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';

// https://stackoverflow.com/questions/53085311/sticky-headers-on-sliverlist
class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Color? color;
  final double height;
  final ListTile item;

  SectionHeaderDelegate({
    this.color,
    this.height = sectionHeaderHeight,
    required Widget title,
    Widget? leading,
    Widget? trailing,
    void Function()? onTap,
  }) : item = ListTile(
          leading: leading,
          trailing: trailing,
          title: title,
          style: ListTileStyle.list,
          onTap: onTap,
        );

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color ??
          Theme.of(context).colorScheme.primaryContainer.withAlpha(224),
      height: sectionHeaderHeight,
      child: item,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class SectionHeader extends HookConsumerWidget {
  final SectionHeaderDelegate delegate;

  SectionHeader({
    super.key,
    double height = sectionHeaderHeight,
    required Widget title,
    Widget? leading,
    Widget? trailing,
    Color? color,
    void Function()? onTap,
  }) : delegate = SectionHeaderDelegate(
          height: height,
          title: title,
          leading: leading,
          trailing: trailing,
          color: color,
          onTap: onTap,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverPersistentHeader(
        pinned: true,
        delegate: delegate,
      );
}
