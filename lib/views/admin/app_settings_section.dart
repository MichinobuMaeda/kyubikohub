import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../providers/conf_repository.dart';
import '../../providers/firebase_utils.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/modal_items_section.dart';
import '../app_localizations.dart';

class AppSettingsSection extends HookConsumerWidget {
  final TextEditingController _editDescController = TextEditingController();
  AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);
    final orgDesc = ref.watch(
      confRepositoryProvider.select(
        (conf) => (conf is Success<Conf>) ? conf.data.desc ?? '' : '',
      ),
    );
    final desc = useState(orgDesc);

    Future<void> saveDesc() async {
      await updateDoc(confRef, {'desc': desc.value});
      controller.close();
    }

    final items = [
      ModalItem(
        title: t.aboutTheApp,
        trailing: const Icon(Icons.edit),
        initState: () {
          _editDescController.text = orgDesc;
        },
        topActions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: saveDesc,
          ),
        ],
        bottomActions: [
          TextButton(
            onPressed: saveDesc,
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
                desc.value = value;
              },
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
