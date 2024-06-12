import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_sheet.dart';

sealed class BaseItemProps {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool deleted;

  BaseItemProps({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.deleted = false,
  });
}

class ActionItemProps extends BaseItemProps {
  final void Function() onTap;

  ActionItemProps({
    required super.title,
    super.leading,
    super.trailing,
    super.deleted = false,
    required this.onTap,
  });
}

class LinkItemProps extends BaseItemProps {
  final String name;
  final Map<String, String> pathParameters;

  LinkItemProps({
    required super.title,
    super.leading,
    super.trailing,
    super.deleted = false,
    required this.name,
    required this.pathParameters,
  });
}

class ModalSheetItemProps extends BaseItemProps {
  final List<Widget> topActions;
  final List<Widget> bottomActions;
  final void Function()? initState;
  final Widget child;

  ModalSheetItemProps({
    required super.title,
    super.subtitle,
    super.leading,
    super.trailing,
    super.deleted = false,
    this.topActions = const [],
    this.bottomActions = const [],
    this.initState,
    required this.child,
  });
}

class ListItem extends HookConsumerWidget {
  final int index;
  final double height;
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool deleted;
  final void Function() Function(BuildContext, WidgetRef)? onTap;

  const ListItem({
    super.key,
    required this.index,
    this.height = listItemHeight,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.deleted = false,
    this.onTap,
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
            onTap: onTap == null ? null : onTap!(context, ref),
          ),
        ),
      );

  factory ListItem.fromItem({
    Key? key,
    required int index,
    double height = listItemHeight,
    required BaseItemProps item,
  }) =>
      switch (item) {
        ActionItemProps() => ListItem(
            key: key,
            index: index,
            height: height,
            title: item.title,
            leading: item.leading,
            trailing: item.trailing,
            deleted: item.deleted,
            onTap: (BuildContext context, WidgetRef ref) => item.onTap,
          ),
        LinkItemProps() => ListItem(
            key: key,
            index: index,
            height: height,
            title: item.title,
            leading: item.leading,
            trailing: item.trailing,
            deleted: item.deleted,
            onTap: (BuildContext context, WidgetRef ref) => () {
              context.pushNamed(
                item.name,
                pathParameters: item.pathParameters,
              );
            },
          ),
        ModalSheetItemProps() => ListItem(
            key: key,
            index: index,
            height: height,
            title: item.title,
            subtitle: item.subtitle,
            leading: item.leading,
            trailing: item.trailing,
            deleted: item.deleted,
            onTap: (BuildContext context, WidgetRef ref) => () {
              final controller = ref.read(
                modalSheetControllerProviderProvider.notifier,
              );
              if (item.initState != null) {
                item.initState!();
              }
              controller.set(
                showBottomSheet(
                  context: context,
                  backgroundColor: modalColor(context),
                  builder: (context) => ModalSheet(
                    title: item.title,
                    body: item.child,
                    topActions: item.topActions,
                    bottomActions: item.bottomActions,
                  ),
                ),
              );
            },
          ),
      };
}

class ListItemsSection extends HookConsumerWidget {
  final int childCount;
  final double height;
  final BaseItemProps Function(int index) items;

  const ListItemsSection({
    super.key,
    required this.childCount,
    this.height = listItemHeight,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverFixedExtentList(
        itemExtent: height,
        delegate: SliverChildBuilderDelegate(
          childCount: childCount,
          (BuildContext context, int index) {
            final item = items(index);
            return ListItem.fromItem(
              index: index,
              height: height,
              item: item,
            );
          },
        ),
      );
}
