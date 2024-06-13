import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config.dart';
import '../widgets/list_items_section.dart';
import '../app_localizations.dart';

typedef LicenseRecord = ({String title, String body});

Future<List<LicenseRecord>> listLicense() async {
  final list = <LicenseRecord>[];
  await LicenseRegistry.licenses.forEach((entry) {
    final title = entry.packages.toList().join(', ');
    final body = entry.paragraphs.map((p) => p.text.trim()).join('\n\n');
    if (list.any((item) => item.title == title)) {
      final index = list.indexWhere((item) => item.title == title);
      list[index] = (title: title, body: '${list[index].body}\n\n$body');
    } else {
      list.add((title: title, body: body));
    }
  });
  return list;
}

class LicensesSection extends HookConsumerWidget {
  const LicensesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final licenseList = useMemoized(() => listLicense());
    final entries = useFuture(licenseList);

    return ListItemsSection(
      childCount: entries.data?.length ?? 0,
      height: listItemHeightWithSubtitle,
      items: (index) => ModalSheetItemProps(
        title: entries.data![index].title,
        subtitle: entries.data![index].body,
        trailing: const Icon(Icons.more_horiz),
        topActions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => copyText(entries.data![index]),
          ),
        ],
        bottomActions: [
          TextButton(
            onPressed: () => copyText(entries.data![index]),
            child: Text(t.copy),
          ),
        ],
        child: SingleChildScrollView(
          child: Padding(
            padding: cardItemPadding,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                entries.data![index].body,
                maxLines: 10000,
                style: GoogleFonts.courierPrime(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void copyText(LicenseRecord license) => Clipboard.setData(
        ClipboardData(text: '${license.title}\n\n${license.body}'),
      );
}
