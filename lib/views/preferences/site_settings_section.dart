import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../providers/firebase_utils.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_items_section.dart';
import '../app_localizations.dart';

class SiteSettingsSection extends HookConsumerWidget {
  final TextEditingController _editDescController = TextEditingController();
  SiteSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);
    final site = ref.watch(
      siteRepositoryProvider.select(
        (siteRecord) => (siteRecord is Success<SiteRecord>)
            ? siteRecord.data.selected
            : null,
      ),
    );
    final forGuests = useState(site?.forGuests ?? '');
    final forMembers = useState(site?.forMembers ?? '');
    final forMangers = useState(site?.forMangers ?? '');

    final items = [
      ...[
        (
          title: t.forGuests,
          init: site?.forGuests ?? '',
          value: forGuests,
          save: () async {
            await updateDoc(
              siteRef(id: site?.id ?? ''),
              {'forGuests': forGuests.value},
            );
            controller.close();
          },
        ),
        (
          title: t.forMembers,
          init: site?.forMembers ?? '',
          value: forMembers,
          save: () async {
            await updateDoc(
              siteRef(id: site?.id ?? ''),
              {'forMembers': forMembers.value},
            );
            controller.close();
          },
        ),
        (
          title: t.forMangers,
          init: site?.forMangers ?? '',
          value: forMangers,
          save: () async {
            await updateDoc(
              siteRef(id: site?.id ?? ''),
              {'forMangers': forMangers.value},
            );
            controller.close();
          },
        ),
      ].map(
        (item) => ModalItem(
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
              child: TextField(
                controller: _editDescController,
                maxLines: 64,
                autofocus: true,
                onChanged: (value) {
                  item.value.value = value;
                },
              ),
            ),
          ),
        ),
      ),
    ];

    return ModalItemsSection(
      childCount: items.length,
      item: (index) => items[index],
    );
  }
}
