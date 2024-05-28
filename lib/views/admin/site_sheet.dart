import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/site.dart';
import '../../providers/firebase_utils.dart';
import '../widgets/modal_sheet.dart';
import '../app_localizations.dart';

class SiteSheet extends HookConsumerWidget {
  final Site? site;
  final TextEditingController idTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  SiteSheet({super.key, this.site}) {
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

    return ModalSheet(
      title: site?.name ?? t.add,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: cardItemPadding,
                  child: site == null
                      ? SizedBox(
                          width: baseSize * 24,
                          child: TextField(
                            controller: idTextController,
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
                    width: baseSize * 24,
                    child: TextField(
                      controller: nameTextController,
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
                      width: baseSize * 24,
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
                      width: baseSize * 24,
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
                      width: baseSize * 24,
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
                                  : Theme.of(context)
                                      .colorScheme
                                      .errorContainer,
                            ),
                          ),
                          onPressed: buttonEnabled.value
                              ? site!.deleted
                                  ? () async {
                                      buttonEnabled.value = false;
                                      final (ret, message) =
                                          await onRestoreSite(
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
          ),
        ),
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
    return (false, t.itemIsRequired(item: t.siteId));
  } else if (siteName.isEmpty) {
    return (false, t.itemIsRequired(item: t.siteName));
  } else if (name.isEmpty) {
    return (false, t.itemIsRequired(item: t.displayName));
  } else if (email.isEmpty) {
    return (false, t.itemIsRequired(item: t.email));
  } else if (password.isEmpty) {
    return (false, t.itemIsRequired(item: t.password));
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
    return (false, t.itemIsRequired(item: t.siteId));
  } else if (siteName.isEmpty) {
    return (false, t.itemIsRequired(item: t.siteName));
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
    return (false, t.itemIsRequired(item: t.siteId));
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
    return (false, t.itemIsRequired(item: t.siteId));
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
