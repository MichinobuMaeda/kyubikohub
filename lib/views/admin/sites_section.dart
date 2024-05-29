import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/site.dart';
import '../../providers/site_repository.dart';
import '../widgets/modal_item.dart';
import '../app_localizations.dart';
import 'site_form.dart';

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

    return SliverFixedExtentList(
      itemExtent: listItemHeight,
      delegate: SliverChildBuilderDelegate(
        childCount: sites.length,
        (BuildContext context, int index) => ModalItem(
          index: index,
          title: sites[index].title ?? t.add,
          deleted: sites[index].deleted,
          trailing: Icon(sites[index].data == null ? Icons.add : Icons.edit),
          child: SiteForm(site: sites[index].data),
        ),
      ),
    );
  }
}
