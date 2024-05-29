import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';

// https://stackoverflow.com/questions/53085311/sticky-headers-on-sliverlist
class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final IconData? leading;
  final double height;

  SectionHeaderDelegate({
    required this.height,
    required this.title,
    this.leading,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      height: sectionHeaderHeight,
      child: ListTile(
        leading: Icon(leading),
        title: Text(title),
        style: ListTileStyle.list,
      ),
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
  final String title;
  final IconData? leading;
  final double height;
  const SectionHeader({
    super.key,
    required this.title,
    this.leading,
    this.height = sectionHeaderHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverPersistentHeader(
        pinned: true,
        delegate: SectionHeaderDelegate(
          title: title,
          leading: leading,
          height: height,
        ),
      );
}
