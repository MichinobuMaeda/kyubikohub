import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../../providers/modal_sheet_controller_provider.dart';
import '../../providers/log_repository.dart';
import '../widgets/go_back_header.dart';
import '../widgets/section_header.dart';
import '../widgets/modal_sheet.dart';
import '../widgets/list_items_section.dart';
import '../app_localizations.dart';

class LogsScreen extends HookConsumerWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.read(modalSheetControllerProviderProvider.notifier);
    final siteProvider = ref.watch(siteRepositoryProvider);
    final sites = [
      (
        id: null,
        title: '--',
      ),
      ...((siteProvider is Success<SiteRecord>)
              ? siteProvider.data.sites
              : [] as List<Site>)
          .where((site) => !site.deleted)
          .map((site) => (
                id: site.id,
                title: site.name,
              )),
    ];
    final date = useState(today());
    final site = useState(sites[0]);
    final logs = useFuture(getLog(site.value.id, date.value));

    return CustomScrollView(
      slivers: [
        const GoBackHeader(),
        SectionHeader(
          title: Text(t.operationLog),
          leading: const Icon(Icons.history),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            height: listItemHeightWithSubtitle,
            child: Padding(
              padding: cardItemPadding,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: () async {
                      date.value = await showDatePicker(
                            context: context,
                            initialDate: date.value,
                            firstDate: DateTime(2000),
                            lastDate: today(),
                          ) ??
                          date.value;
                    },
                  ),
                  Text(date.value.toIso8601String().substring(0, 10)),
                  IconButton(
                    icon: const Icon(Icons.domain),
                    onPressed: () {
                      controller.set(
                        showBottomSheet(
                          context: context,
                          backgroundColor: modalColor(context),
                          builder: (context) => ModalSheet(
                            title: t.sites,
                            body: CustomScrollView(
                              slivers: [
                                ListItemsSection(
                                  childCount: sites.length,
                                  items: (index) => ActionItemProps(
                                    title: sites[index].title,
                                    onTap: () {
                                      site.value = sites[index];
                                      controller.close();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Text(site.value.title),
                ],
              ),
            ),
          ),
        ),
        if (logs.data != null)
          ListItemsSection(
            childCount: logs.data!.length,
            height: listItemHeightWithSubtitle,
            items: (index) => ModalSheetItemProps(
              title:
                  logs.data![index].ts.toIso8601String().replaceAll('T', ' '),
              subtitle: logs.data![index].message,
              child: SingleChildScrollView(
                child: Padding(
                  padding: cardItemPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      logs.data![index].message,
                      style: GoogleFonts.courierPrime(),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}