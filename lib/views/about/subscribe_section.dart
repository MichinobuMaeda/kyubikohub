import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/conf.dart';
import '../../providers/conf_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../widgets/list_items_section.dart';
import '../validators.dart';
import '../app_localizations.dart';

class SubscribeSection extends HookConsumerWidget {
  const SubscribeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    return ListItemsSection(
      childCount: 1,
      items: (index) => ModalSheetItemProps(
        title: t.subscribe,
        leading: const Icon(Icons.outgoing_mail),
        trailing: const Icon(Icons.more_horiz),
        child: const SubscribeForm(),
      ),
    );
  }
}

typedef FieldValue = ({String val, String? err});

@visibleForTesting
class SubscribeForm extends HookConsumerWidget {
  const SubscribeForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final forSubscriber = ref.watch(
      confRepositoryProvider.select(
        (conf) => (conf is Success<Conf>) ? conf.data.forSubscriber : null,
      ),
    );
    final site = useState<FieldValue>((val: '', err: null));
    final email = useState<FieldValue>((val: '', err: null));
    final name = useState<FieldValue>((val: '', err: null));
    final tel = useState<FieldValue>((val: '', err: null));
    final zip = useState<FieldValue>((val: '', err: null));
    final prefecture = useState<FieldValue>((val: '', err: null));
    final city = useState<FieldValue>((val: '', err: null));
    final address1 = useState<FieldValue>((val: '', err: null));
    final address2 = useState<FieldValue>((val: '', err: null));
    final desc = useState<FieldValue>((val: '', err: null));
    final managerName = useState<FieldValue>((val: '', err: null));
    final managerEmail = useState<FieldValue>((val: '', err: null));
    final savedMessage = useState('');

    return FocusTraversalGroup(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: cardItemPadding,
              child: forSubscriber == null
                  ? Text(t.defaultLoadingMessage)
                  : MarkdownBody(
                      data: forSubscriber,
                      onTapLink: onTapLink,
                      styleSheet: markdownStyleSheet(context),
                    ),
            ),
          ),
          SliverList.list(
            children: [
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      site.value = (
                        val: value,
                        err: validateRequired(value)
                            ? validateLowercasesAndNumerics(value)
                                ? null
                                : t.lowercasesAndNumerics
                            : '${t.required} ${t.lowercasesAndNumerics}',
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.siteId,
                      helperText: '${t.required} ${t.lowercasesAndNumerics}',
                      errorText: site.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      name.value = (
                        val: value,
                        err: validateRequired(value) ? null : t.required,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.subscriberName,
                      helperText: t.required,
                      errorText: name.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      email.value = (
                        val: value,
                        err: validateRequired(value)
                            ? validateLowercasesAndNumerics(value)
                                ? null
                                : t.emailFormat
                            : '${t.required} ${t.emailFormat}',
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.subscriberEmail,
                      helperText: '${t.required} ${t.emailFormat}',
                      errorText: email.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      tel.value = (
                        val: value,
                        err: validateTel(value) ? null : t.telFormat,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.tel,
                      helperText: t.telFormat,
                      errorText: tel.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      zip.value = (
                        val: value,
                        err: validateRequired(value) ? null : t.required,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.zip,
                      helperText: t.required,
                      errorText: zip.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      prefecture.value = (
                        val: value,
                        err: validateRequired(value) ? null : t.required,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.prefecture,
                      helperText: t.required,
                      errorText: prefecture.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      city.value = (
                        val: value,
                        err: validateRequired(value) ? null : t.required,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.city,
                      helperText: t.required,
                      errorText: city.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      address1.value = (
                        val: value,
                        err: validateRequired(value) ? null : t.required,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.address1,
                      helperText: t.required,
                      errorText: address1.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      address2.value = (
                        val: value,
                        err: null,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.address2,
                      helperText: t.address2HelperText,
                      errorText: address2.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    maxLines: 6,
                    onChanged: (value) {
                      desc.value = (
                        val: value,
                        err: value.length < 200
                            ? t.lengthNotLessThan(length: 200)
                            : null,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: t.purposeSubscription,
                      helperText: t.lengthNotLessThan(length: 200),
                      errorText: desc.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      managerName.value = (val: value, err: null);
                    },
                    decoration: InputDecoration(
                      labelText: '${t.manager} ${t.displayName}',
                      helperText: t.notForIndividualApplication,
                      errorText: managerName.value.err,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: cardItemPadding,
                child: SizedBox(
                  child: TextField(
                    onChanged: (value) {
                      managerEmail.value = (
                        val: value,
                        err: validateEmail(value) ? null : t.emailFormat,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: '${t.manager} ${t.email}',
                      helperText: t.notForIndividualApplication,
                      errorText: managerEmail.value.err,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: cardItemPadding,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        FilledButton(
                          onPressed: site.value.err == null &&
                                  site.value.val.isNotEmpty &&
                                  email.value.err == null &&
                                  email.value.val.isNotEmpty &&
                                  name.value.err == null &&
                                  name.value.val.isNotEmpty &&
                                  tel.value.err == null &&
                                  zip.value.err == null &&
                                  zip.value.val.isNotEmpty &&
                                  prefecture.value.err == null &&
                                  prefecture.value.val.isNotEmpty &&
                                  city.value.err == null &&
                                  city.value.val.isNotEmpty &&
                                  address1.value.err == null &&
                                  address1.value.val.isNotEmpty &&
                                  address2.value.err == null &&
                                  desc.value.err == null &&
                                  desc.value.val.isNotEmpty &&
                                  managerName.value.err == null &&
                                  managerEmail.value.err == null
                              ? () => save(context, ref)
                              : null,
                          child: Row(
                            children: [
                              const Icon(Icons.send),
                              const SizedBox(width: buttonGap),
                              Text(t.send),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: buttonGap),
                  Text(
                    savedMessage.value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @visibleForTesting
  Future<void> save(
    BuildContext context,
    WidgetRef ref,
  ) async {
    ref.read(modalSheetControllerProviderProvider.notifier).close();
  }
}
