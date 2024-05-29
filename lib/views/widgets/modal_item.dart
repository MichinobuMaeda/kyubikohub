import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_sheet.dart';

class ModalItem extends HookConsumerWidget {
  final int index;
  final String title;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> topActions;
  final List<Widget> bottomActions;
  final bool deleted;

  const ModalItem({
    super.key,
    this.index = 0,
    required this.title,
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
      height: listItemHeight,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: leading,
          title: Text(
            title,
            style: deleted
                ? TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Theme.of(context).colorScheme.error,
                  )
                : null,
          ),
          trailing: trailing,
          hoverColor: listItemsHoverColor(context),
          tileColor: listItemsStripeColor(context, index),
          onTap: () {
            controller.set(
              showBottomSheet(
                context: context,
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
