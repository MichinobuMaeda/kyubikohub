import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'org_repository.g.dart';

var orgStream = StreamController<String>();

@Riverpod(keepAlive: true)
Stream<String> orgRepository(OrgRepositoryRef ref) =>
    orgStream.stream.distinct().map(
      (org) {
        Future(() async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('org', org);
        });
        return org;
      },
    );
