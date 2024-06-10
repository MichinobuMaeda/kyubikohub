import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';

class LinkItem {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final String name;
  final Map<String, String> pathParameters;
  final bool deleted;

  LinkItem({
    required this.title,
    this.leading,
    this.trailing,
    required this.name,
    this.pathParameters = const <String, String>{},
    this.deleted = false,
  });
}

class LinkItemsSection extends HookConsumerWidget {
  final int childCount;
  final double height;
  final LinkItem Function(int index) item;

  const LinkItemsSection({
    super.key,
    required this.childCount,
    this.height = listItemHeight,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverFixedExtentList(
      itemExtent: height,
      delegate: SliverChildBuilderDelegate(
        childCount: childCount,
        (BuildContext context, int index) {
          final entry = item(index);
          return SizedBox(
            height: height,
            child: Material(
              type: MaterialType.transparency,
              child: ListTile(
                leading: entry.leading,
                title: Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: entry.deleted
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context).colorScheme.error,
                        )
                      : null,
                ),
                trailing: entry.trailing,
                hoverColor: listItemsHoverColor(context),
                tileColor: listItemsStripeColor(context, index),
                onTap: () {
                  context.pushNamed(
                    entry.name,
                    pathParameters: entry.pathParameters,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
