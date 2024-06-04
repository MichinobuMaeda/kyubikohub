import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_sheet.dart';

class ModalItem {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> topActions;
  final List<Widget> bottomActions;
  final bool deleted;
  final void Function()? initState;

  ModalItem({
    required this.title,
    this.subtitle,
    required this.child,
    this.leading,
    this.trailing,
    this.topActions = const [],
    this.bottomActions = const [],
    this.deleted = false,
    this.initState,
  });
}

class ModalItemsSection extends HookConsumerWidget {
  final int childCount;
  final double height;
  final ModalItem Function(int index) item;

  const ModalItemsSection({
    super.key,
    required this.childCount,
    this.height = listItemHeight,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);

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
                      : entry.subtitle != null
                          ? TextStyle(
                              color: Theme.of(context).colorScheme.primary)
                          : null,
                ),
                subtitle: entry.subtitle != null
                    ? Text(
                        entry.subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: entry.trailing,
                hoverColor: listItemsHoverColor(context),
                tileColor: listItemsStripeColor(context, index),
                onTap: () {
                  if (entry.initState != null) {
                    entry.initState!();
                  }
                  controller.set(
                    showBottomSheet(
                      context: context,
                      builder: (context) => ModalSheet(
                        title: entry.title,
                        body: entry.child,
                        topActions: entry.topActions,
                        bottomActions: entry.bottomActions,
                      ),
                    ),
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
