import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../config.dart';
import '../../repositories/firebase_repository.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../widgets/list_items_section.dart';
import '../../l10n/app_localizations.dart';

class SitesSection extends HookConsumerWidget {
  const SitesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final siteProvider = ref.watch(siteRepositoryProvider);
    final sites = [
      (
        title: null,
        data: null,
        deleted: false,
      ),
      ...((siteProvider is Success<SiteRecord>)
              ? siteProvider.data.sites
              : [] as List<Site>)
          .map((site) => (
                title: site.name,
                data: site,
                deleted: site.deleted,
              )),
    ];

    return ListItemsSection(
      childCount: sites.length,
      items: (index) => ModalSheetItemProps(
        title: sites[index].title ?? t.add,
        deleted: sites[index].deleted,
        trailing: Icon(sites[index].data == null ? Icons.add : Icons.edit),
        child: SiteForm(site: sites[index].data),
      ),
    );
  }
}

@visibleForTesting
class SiteForm extends HookConsumerWidget {
  final Site? site;
  final TextEditingController idTextController = TextEditingController(),
      nameTextController = TextEditingController(),
      passwordTextController = TextEditingController();

  SiteForm({super.key, this.site}) {
    idTextController.text = site == null ? '' : site!.id;
    nameTextController.text = site == null ? '' : site!.name;
    passwordTextController.text = generatePassword();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final id = useState(idTextController.text);
    final name = useState(nameTextController.text);
    final managerName = useState('');
    final managerEmail = useState('');
    final managerPassword = useState(passwordTextController.text);
    final passwordVisible = useState(false);
    final savedMessage = useState('');
    final buttonEnabled = useState(true);
    final deletedMessage = useState('');

    return FocusTraversalGroup(
      child: CustomScrollView(
        slivers: [
          SliverList.list(
            children: [
              Padding(
                padding: cardItemPadding,
                child: site == null
                    ? SizedBox(
                        child: TextField(
                          controller: idTextController,
                          autofocus: site == null,
                          onChanged: (value) {
                            id.value = value;
                          },
                          decoration: InputDecoration(
                            label: Text(t.id),
                          ),
                        ),
                      )
                    : Text('ID: ${site!.id}'),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    controller: nameTextController,
                    autofocus: site != null,
                    onChanged: (value) {
                      name.value = value;
                    },
                    decoration: InputDecoration(
                      label: Text(t.siteName),
                    ),
                  ),
                ),
              ),
              if (site == null)
                Padding(
                  padding: cardItemPadding,
                  child: SizedBox(
                    child: TextField(
                      onChanged: (value) {
                        managerName.value = value;
                      },
                      decoration: InputDecoration(
                        label: Text(t.displayName),
                      ),
                    ),
                  ),
                ),
              if (site == null)
                Padding(
                  padding: cardItemPadding,
                  child: SizedBox(
                    child: TextField(
                      onChanged: (value) {
                        managerEmail.value = value;
                      },
                      decoration: InputDecoration(
                        label: Text(t.email),
                      ),
                    ),
                  ),
                ),
              if (site == null)
                Padding(
                  padding: cardItemPadding,
                  child: SizedBox(
                    child: TextField(
                      controller: passwordTextController,
                      onChanged: (value) {
                        managerPassword.value = value;
                      },
                      obscureText: !passwordVisible.value,
                      decoration: InputDecoration(
                        label: Text(t.password),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            passwordVisible.value = !passwordVisible.value;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: cardItemPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilledButton(
                      onPressed: buttonEnabled.value
                          ? site == null
                              ? () async {
                                  buttonEnabled.value = false;
                                  final (ret, message) = await onSaveNewSite(
                                    t: t,
                                    siteId: id.value,
                                    siteName: name.value,
                                    name: managerName.value,
                                    email: managerEmail.value,
                                    password: managerPassword.value,
                                  );
                                  savedMessage.value = message;
                                  buttonEnabled.value = !ret;
                                }
                              : () async {
                                  final (_, message) = await onSaveEditedSite(
                                    t: t,
                                    siteId: id.value,
                                    siteName: name.value,
                                  );
                                  savedMessage.value = message;
                                }
                          : null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.save_alt),
                          const SizedBox(width: iconTextGap),
                          Text(t.save),
                        ],
                      ),
                    ),
                    const SizedBox(height: buttonGap),
                    Text(
                      savedMessage.value,
                      style: TextStyle(
                        color: savedMessage.value == t.saved
                            ? Theme.of(context).colorScheme.tertiary
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                    if (site != null) const SizedBox(height: buttonGap),
                    if (site != null)
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateColor.resolveWith(
                            (state) => buttonEnabled.value
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.errorContainer,
                          ),
                        ),
                        onPressed: buttonEnabled.value
                            ? site!.deleted
                                ? () async {
                                    buttonEnabled.value = false;
                                    final (ret, message) = await onRestoreSite(
                                      t: t,
                                      siteId: id.value,
                                    );
                                    deletedMessage.value = message;
                                    buttonEnabled.value = !ret;
                                  }
                                : () async {
                                    buttonEnabled.value = false;
                                    final (ret, message) = await onDeleteSite(
                                      t: t,
                                      siteId: id.value,
                                    );
                                    deletedMessage.value = message;
                                    buttonEnabled.value = !ret;
                                  }
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              site!.deleted ? Icons.restore : Icons.delete,
                            ),
                            const SizedBox(width: iconTextGap),
                            Text(site!.deleted ? t.restore : t.delete),
                          ],
                        ),
                      ),
                    if (site != null) const SizedBox(height: buttonGap),
                    if (site != null)
                      Text(
                        deletedMessage.value,
                        style: TextStyle(
                          color: deletedMessage.value == t.deleted ||
                                  deletedMessage.value == t.restored
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@visibleForTesting
Future<(bool, String)> onSaveNewSite({
  required AppLocalizations t,
  required String siteId,
  required String siteName,
  required String name,
  required String email,
  required String password,
}) async {
  if (siteId.isEmpty) {
    return (false, t.itemIsRequired(t.siteId));
  } else if (siteName.isEmpty) {
    return (false, t.itemIsRequired(t.siteName));
  } else if (name.isEmpty) {
    return (false, t.itemIsRequired(t.displayName));
  } else if (email.isEmpty) {
    return (false, t.itemIsRequired(t.email));
  } else if (password.isEmpty) {
    return (false, t.itemIsRequired(t.password));
  } else {
    final ret = await createSite(
      siteId: siteId,
      siteName: siteName,
      name: name,
      email: email,
      password: password,
    );
    if (ret) {
      return (true, t.saved);
    } else {
      return (false, t.systemError);
    }
  }
}

@visibleForTesting
Future<(bool, String)> onSaveEditedSite({
  required AppLocalizations t,
  required String siteId,
  required String siteName,
}) async {
  if (siteId.isEmpty) {
    return (false, t.itemIsRequired(t.siteId));
  } else if (siteName.isEmpty) {
    return (false, t.itemIsRequired(t.siteName));
  } else {
    try {
      await updateDoc(
        siteRef(id: siteId),
        {"name": siteName},
      );
      return (true, t.saved);
    } catch (e, s) {
      debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
      return (false, t.systemError);
    }
  }
}

@visibleForTesting
Future<(bool, String)> onDeleteSite({
  required AppLocalizations t,
  required String siteId,
}) async {
  if (siteId.isEmpty) {
    return (false, t.itemIsRequired(t.siteId));
  } else {
    try {
      await deleteDoc(siteRef(id: siteId));
      return (true, t.deleted);
    } catch (e, s) {
      debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
      return (false, t.systemError);
    }
  }
}

@visibleForTesting
Future<(bool, String)> onRestoreSite({
  required AppLocalizations t,
  required String siteId,
}) async {
  if (siteId.isEmpty) {
    return (false, t.itemIsRequired(t.siteId));
  } else {
    try {
      await restoreDoc(siteRef(id: siteId));
      return (true, t.restored);
    } catch (e, s) {
      debugPrintStack(label: 'ERROR   : ${e.toString()}', stackTrace: s);
      return (false, t.systemError);
    }
  }
}
