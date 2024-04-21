import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config.dart';
import '../../models/user.dart';
import '../../providers/data_state.dart';
import '../../providers/me_provider.dart';
import '../../providers/ui_version_provider.dart';
import '../app_localizations.dart';
import '../widgets/sliver_error_message.dart';
import '../widgets/sliver_loading_message.dart';
import '../widgets/sliver_title.dart';
import 'sliver_header.dart';
import 'sliver_update_app.dart';
import 'sliver_footer.dart';

enum AppState { loading, loaded, user, admin }

class ScreenBase extends HookConsumerWidget {
  final AppState requiredState;
  final List<Widget> slivers;

  const ScreenBase(this.slivers, this.requiredState, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final uiVersion = ref.watch(uiVersionProvider);
    final me = ref.watch(meProvider);
    final updateRequired = switch (uiVersion) {
      Loading() || Error() => false,
      Success() => uiVersion.data != version
    };
    // final sliversAdminPrivError = [
    //   SliverErrorMessage(message: t.adminPrivRequired),
    // ];

    List<Widget> guardLoading() => requiredState != AppState.loading
        ? [const SliverLoadingMessage()]
        : slivers;

    List<Widget> guardUser(User? user) =>
        ([AppState.user, AppState.admin].contains(requiredState) &&
                user == null)
            ? [SliverTitle(t.login)]
            // : (required == AppState.admin && user?.admin != true)
            //     ? sliversAdminPrivError
            : slivers;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverHeader(appTitle),
          if (updateRequired) const SliverUpdateApp(),
          ...switch (uiVersion) {
            Loading() => guardLoading(),
            Error() => [SliverErrorMessage(uiVersion.message)],
            Success() => switch (me) {
                Loading() => guardLoading(),
                Error() => [SliverErrorMessage(me.message)],
                Success() => guardUser(me.data),
              }
          },
          SliverFooter(t.copyright),
        ],
      ),
    );
  }
}
