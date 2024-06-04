import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_sheet.dart';

class ModalItems extends HookConsumerWidget {
  final int index;
  final double height;
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> topActions;
  final List<Widget> bottomActions;
  final bool deleted;

  const ModalItems({
    super.key,
    this.index = 0,
    required this.height,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.child,
    this.topActions = const [],
    this.bottomActions = const [],
    this.deleted = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);

    return SizedBox(
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
          onTap: () {
            controller.set(
              showBottomSheet(
                context: context,
                constraints: const BoxConstraints(
                  minWidth: contentWidth,
                  maxWidth: contentWidth,
                ),
                builder: (context) => ModalSheet(
                  title: title,
                  body: child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
