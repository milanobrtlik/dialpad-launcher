import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:diacritic/diacritic.dart';
import 'package:hive_flutter/adapters.dart';

class AppsRepository {
  AppsRepository(this._imprisoned, this._excluded);

  final Box _imprisoned;
  final Box _excluded;

  List<Application> _apps = List.empty(growable: true);

  Future<List<Application>> onUninstallApp(String packageName) async {
    _apps.removeWhere((element) => element.packageName == packageName);
    _apps.sort((a, b) => removeDiacritics(a.appName)
        .toLowerCase()
        .compareTo(removeDiacritics(b.appName).toLowerCase()));
    filterApps(_apps);
    return _apps;
  }

  Future<List<Application>> onInstallApp(String packageName) async {
    var app = await DeviceApps.getApp(packageName, true);
    if (app != null) {
      _apps.add(app);
    }
    filterApps(_apps);

    _apps.sort((a, b) => removeDiacritics(a.appName)
        .toLowerCase()
        .compareTo(removeDiacritics(b.appName).toLowerCase()));

    return _apps;
  }

  final _keyboard = [
    '',
    'abc',
    'def',
    'ghi',
    'jkl',
    'mno',
    'pqrs',
    'tuv',
    'wxyz',
  ];

  Future<List<Application>> load({bool force = false}) async {
    if (_apps.isEmpty || force == true) {
      _apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeSystemApps: true,
        includeAppIcons: true,
      );
    }

    return _apps.toList();
  }

  List<Application> filterApps(List<Application> apps) {
    var imprisoned = _imprisoned.values;
    if(imprisoned.isEmpty == false) {
      apps.removeWhere((app) => imprisoned.contains(app.packageName));
    }
    var excluded = _excluded.values;
    if(excluded.isEmpty == false) {
      apps.removeWhere((app) => excluded.contains(app.packageName));
    }

    return apps;
  }

  Future<List<Application>> search(String? filter) async {
    List<Application> apps = await load();
    filterApps(apps);
    if (filter == null) {
      apps.sort((a, b) => removeDiacritics(a.appName)
          .toLowerCase()
          .compareTo(removeDiacritics(b.appName).toLowerCase()));
      return apps;
    }

    Map<String, _Search> map = {
      for (var app in apps)
        app.packageName: _Search(removeDiacritics(app.appName).toLowerCase())
    };

    var abc0 = _keyboard[int.parse(filter[0]) - 1];
    map.removeWhere((key, value) => abc0.contains(value.term[0]) == false);

    if (filter.length > 1) {
      for (var i = 1; i < filter.length; i++) {
        var abc1 = _keyboard[int.parse(filter[i]) - 1];
        var regex = RegExp('[$abc1]');
        map.removeWhere((key, value) => value.term.contains(regex) == false);
        map.forEach((key, value) {
          var i = value.term.indexOf(regex);
          value.term = value.term.substring(i + 1, value.term.length);
          value.score -= i;
        });
      }
    }

    apps = apps.where((app) => map.containsKey(app.packageName)).toList();
    apps.sort((a, b) =>
        map[b.packageName]!.score.compareTo(map[a.packageName]!.score));

    return apps;
  }

  Future<List<Application>> loadImprisoned() async {
    var apps = await load();
    var imprisoned = _imprisoned.values;
    if(imprisoned.isEmpty) {
      return List<Application>.empty();
    }
    return apps.where((app) => imprisoned.contains(app.packageName))
        .toList();
  }

  Future<List<Application>> loadExcluded() async {
    var apps = await load();
    if(_excluded.values.isEmpty) {
      return List<Application>.empty();
    }

    return apps.where((app) => _excluded.values.contains(app.packageName))
        .toList();
  }
}

class _Search {
  _Search(this.term);

  String term;
  int score = 0;
}
