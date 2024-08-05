import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../models/nav_item.dart';
import '../../providers/conf_repository.dart';
import '../../providers/account_repository.dart';
import '../../repositories/firebase_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/list_items_section.dart';
import '../../l10n/app_localizations.dart';

class AppAdminSection extends HookConsumerWidget {
  final TextEditingController _editDescController = TextEditingController();
  AppAdminSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);
    final conf = (ref.watch(confRepositoryProvider) as Success<Conf>);
    final account = ref.watch(accountRepositoryProvider);
    final site = (account is Success<Account?>) ? account.data?.site ?? '' : '';
    final desc = useState(conf.data.desc ?? '');
    final forGuests = useState(conf.data.forGuests ?? '');
    final forMembers = useState(conf.data.forMembers ?? '');
    final forManagers = useState(conf.data.forManagers ?? '');
    final forSubscriber = useState(conf.data.forSubscriber ?? '');

    Future<void> save(String key, ValueNotifier<String> data) async {
      await updateDoc(confRef, {key: data.value});
      controller.close();
    }

    final items = [
      ...[
        (
          title: t.aboutTheApp,
          init: conf.data.desc ?? '',
          value: desc,
          maxLines: textBoxMaxLines,
          save: () => save('desc', desc),
        ),
        (
          title: '${t.sample}: ${t.forGuests}',
          init: conf.data.forGuests ?? '',
          value: forGuests,
          maxLines: textBoxMaxLines,
          save: () => save('forGuests', forGuests),
        ),
        (
          title: '${t.sample}: ${t.forMembers}',
          init: conf.data.forMembers ?? '',
          value: forMembers,
          maxLines: textBoxMaxLines,
          save: () => save('forMembers', forMembers),
        ),
        (
          title: '${t.sample}: ${t.forManagers}',
          init: conf.data.forManagers ?? '',
          value: forManagers,
          maxLines: textBoxMaxLines,
          save: () => save('forManagers', forManagers),
        ),
        (
          title: t.forSubscriber,
          init: conf.data.forSubscriber ?? '',
          value: forSubscriber,
          maxLines: textBoxMaxLines,
          save: () => save('forSubscriber', forSubscriber),
        ),
      ].map(
        (item) => ModalSheetItemProps(
          title: item.title,
          trailing: const Icon(Icons.edit),
          initState: () {
            _editDescController.text = item.init;
          },
          topActions: [
            IconButton(
              icon: const Icon(Icons.save_alt),
              onPressed: item.save,
            ),
          ],
          bottomActions: [
            TextButton(
              onPressed: item.save,
              child: Text(t.save),
            ),
          ],
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(
              width: double.infinity,
              height: double.infinity,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: baseSize),
              child: Padding(
                padding: cardItemPadding,
                child: TextField(
                  controller: _editDescController,
                  maxLines: item.maxLines,
                  autofocus: true,
                  onChanged: (value) {
                    item.value.value = value;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      LinkItemProps(
          title: t.operationLog,
          leading: const Icon(Icons.history),
          trailing: const Icon(Icons.more_horiz),
          name: NavPath.logs.name,
          pathParameters: NavPath.logs.pathParameters(site: site)),
    ];

    return ListItemsSection(
      childCount: items.length,
      items: (index) => items[index],
    );
  }
}
