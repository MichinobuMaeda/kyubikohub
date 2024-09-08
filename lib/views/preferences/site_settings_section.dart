import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../providers/site_repository.dart';
import '../../repositories/firebase_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_sheet.dart';
import '../widgets/list_item.dart';
import '../../l10n/app_localizations.dart';

class SiteSettingsSection extends HookConsumerWidget {
  const SiteSettingsSection({super.key});

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
    final forManagers = useState(site?.forManagers ?? '');

    final items = [
      (
        title: t.forGuests,
        init: site?.forGuests ?? '',
        value: forGuests,
        controller: TextEditingController(),
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
        controller: TextEditingController(),
        save: () async {
          await updateDoc(
            siteRef(id: site?.id ?? ''),
            {'forMembers': forMembers.value},
          );
          controller.close();
        },
      ),
      (
        title: t.forManagers,
        init: site?.forManagers ?? '',
        value: forManagers,
        controller: TextEditingController(),
        save: () async {
          await updateDoc(
            siteRef(id: site?.id ?? ''),
            {'forManagers': forManagers.value},
          );
          controller.close();
        },
      ),
    ];

    return ListItemsSection(
      childCount: items.length,
      (context, ref, index, height) => ListItem.modalAction(
        index: index,
        height: height,
        title: items[index].title,
        trailing: const Icon(Icons.edit),
        initState: () {
          items[index].controller.text = items[index].init;
        },
        child: ModalSheet(
          closeOnTapOutside: true,
          title: items[index].title,
          topActions: [
            IconButton(
              icon: const Icon(Icons.save_alt),
              onPressed: items[index].save,
            ),
          ],
          bottomActions: [
            TextButton(
              onPressed: items[index].save,
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
                controller: items[index].controller,
                maxLines: 64,
                autofocus: true,
                onChanged: (value) {
                  items[index].value.value = value;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
