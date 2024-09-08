import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kyubikohub/views/widgets/modal_sheet.dart';

import '../../config.dart';
import '../../models/data_state.dart';
import '../../models/nav_item.dart';
import '../../providers/account_repository.dart';
import '../../providers/notices_repository.dart';
import '../widgets/list_item.dart';
import '../../l10n/app_localizations.dart';

class NoticesSection extends HookConsumerWidget {
  final bool short;
  const NoticesSection({super.key, this.short = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final account = ref.watch(accountRepositoryProvider);
    final site = (account is Success<Account?>) ? account.data?.site ?? '' : '';
    final noticeList = ref
        .watch(noticesRepositoryProvider)
        .map(
          (notice) => (
            title: '${formatYmdHms(notice.createdAt)} ${notice.title}',
            message: notice.message,
            note: notice.note,
            deleted: notice.deletedAt != null,
          ),
        )
        .toList();
    final notices = [
      ...noticeList.sublist(
        0,
        min(
          short ? noticesShort : noticesLimit,
          noticeList.length,
        ),
      ),
      if (noticeList.isEmpty)
        (
          title: t.noData,
          message: '',
          note: null,
          deleted: false,
        ),
      if (short && noticeList.length > noticesShort)
        (
          title: t.showMore,
          message: '',
          note: null,
          deleted: false,
        ),
    ];

    return ListItemsSection(
      childCount: notices.length,
      (context, ref, index, height) => noticeList.isEmpty
          ? ListItem(
              index: index,
              height: height,
              title: notices[index].title,
            )
          : short &&
                  noticeList.length > noticesShort &&
                  index == (notices.length - 1)
              ? ListItem.linkAction(
                  index: index,
                  height: height,
                  title: notices[index].title,
                  pathName: NavPath.notices.name,
                  pathParameters: {paramSiteName: site},
                )
              : ListItem.modalAction(
                  index: index,
                  height: height,
                  title: notices[index].title,
                  deleted: notices[index].deleted,
                  child: ModalSheet(
                    title: notices[index].title,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Text(notices[index].title),
                              Text(notices[index].message, maxLines: 1000),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
