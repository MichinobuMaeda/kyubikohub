import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import 'modal_sheet.dart';

class ListItemsSection extends HookConsumerWidget {
  final double height;
  final int childCount;
  final ListItem Function(
    BuildContext context,
    WidgetRef ref,
    int index,
    double height,
  ) listItem;

  const ListItemsSection(
    this.listItem, {
    super.key,
    this.height = listItemHeight,
    required this.childCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverFixedExtentList(
        itemExtent: height,
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => listItem(
            context,
            ref,
            index,
            height,
          ),
          childCount: childCount,
        ),
      );
}

class ListItem extends HookConsumerWidget {
  final int index;
  final double height;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool deleted;
  final Function()? Function(BuildContext context, WidgetRef ref)? action;

  const ListItem({
    super.key,
    required this.index,
    required this.height,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.deleted = false,
    this.action,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
        height: height,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            leading: leading,
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: deleted
                  ? TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Theme.of(context).colorScheme.error,
                    )
                  : subtitle != null
                      ? TextStyle(color: Theme.of(context).colorScheme.primary)
                      : null,
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: trailing,
            hoverColor: listItemsHoverColor(context),
            tileColor: listItemsStripeColor(context, index),
            onTap: onTap(context, ref),
          ),
        ),
      );

  Function()? onTap(BuildContext context, WidgetRef ref) =>
      action == null ? null : action!(context, ref);

  factory ListItem.linkAction({
    Key? key,
    required int index,
    required double height,
    required String title,
    String? subtitle,
    Widget? leading,
    Widget trailing = const Icon(Icons.more_horiz),
    bool deleted = false,
    required String pathName,
    required Map<String, String> pathParameters,
  }) =>
      ListItem(
        key: key,
        index: index,
        height: height,
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        deleted: deleted,
        action: (BuildContext context, WidgetRef ref) => () {
          context.pushNamed(
            pathName,
            pathParameters: pathParameters,
          );
        },
      );

  factory ListItem.modalAction({
    Key? key,
    required int index,
    required double height,
    required String title,
    String? subtitle,
    Widget? leading,
    Widget trailing = const Icon(Icons.more_horiz),
    bool deleted = false,
    void Function()? initState,
    required ModalSheet child,
  }) =>
      ListItem(
        key: key,
        index: index,
        height: height,
        title: title,
        subtitle: subtitle,
        leading: leading,
        trailing: trailing,
        deleted: deleted,
        action: (BuildContext context, WidgetRef ref) => () {
          ref.read(modalSheetControllerProviderProvider.notifier).set(
                showBottomSheet(
                  context: context,
                  backgroundColor: modalColor(context),
                  builder: (context) {
                    if (initState != null) {
                      initState();
                    }
                    return child;
                  },
                ),
              );
        },
      );
}
