import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nav_item.freezed.dart';

const paramSiteName = 'site';

enum NavPath {
  home(
    name: 'home',
    path: '',
  ),
  group(
    name: 'group',
    path: 'groups',
    param: 'group',
  ),
  users(
    name: 'users',
    path: 'users',
  ),
  user(
    name: 'user',
    path: 'users',
    param: 'user',
  ),
  notices(
    name: 'notices',
    path: 'notices',
  ),
  preferences(
    name: 'preferences',
    path: 'preferences',
  ),
  about(
    name: 'about',
    path: 'about',
  ),
  admin(
    name: 'admin',
    path: 'admin',
  ),
  logs(
    name: 'logs',
    path: 'logs',
  );

  final String name;
  final String path;
  final String? param;

  const NavPath({
    required this.name,
    required this.path,
    this.param,
  });

  Map<String, String> pathParameters({
    required String site,
    String? param,
  }) =>
      param == null || this.param == null
          ? {
              paramSiteName: site,
            }
          : {
              paramSiteName: site,
              this.param!: param,
            };
}

@freezed
class NavItem with _$NavItem {
  const factory NavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required NavPath navPath,
  }) = _NavItem;
}
