import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dialpad_launcher/app.dart';
import 'package:dialpad_launcher/apps_repository.dart';
import 'package:dialpad_launcher/navigator_bloc/navigator_bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'launcher_event.dart';

part 'launcher_state.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  final NavigatorBloc _navigatorBloc;
  final AppsRepository _appsRepository;
  String? _filter;
  DateTime _lastSearchPress = DateTime.now();

  LauncherBloc(this._appsRepository, this._navigatorBloc)
      : super(LauncherAppsLoading()) {
    on<LauncherAppsLoadingStarted>(_onAppsLoadingStarted);
    on<BtnPressed>(_onBtnPressed);
    on<BtnLongPressed>(_onBtnLongPressed);
    on<AppLaunched>(_onAppLaunched);
    on<AppUninstalled>(_onAppUninstalled);
    on<AppInstalled>(_onAppInstalled);
    on<LauncherReload>(_onReload);
  }

  Future<void> _onReload(
      LauncherReload event, Emitter<LauncherState> emit) async {
    var apps = await _appsRepository.search(_filter);
    emit(LauncherAppsLoaded(apps, _filter));
  }

  Future<void> _onAppInstalled(
      AppInstalled event, Emitter<LauncherState> emit) async {
    var apps = await _appsRepository.onInstallApp(event.packageName);
    emit(LauncherAppsLoaded(apps, null));
  }

  Future<void> _onAppLaunched(
    AppLaunched event,
    Emitter<LauncherState> emit,
  ) async {
    _filter = null;
  }

  Future<void> _onAppUninstalled(
      AppUninstalled event, Emitter<LauncherState> emit) async {
    var apps = await _appsRepository.onUninstallApp(event.packageName);
    emit(LauncherAppsLoaded(apps, null));
  }

  Future<void> _onAppsLoadingStarted(
    LauncherAppsLoadingStarted event,
    Emitter<LauncherState> emit,
  ) async {
    var apps = await _appsRepository.search(event.filter);
    emit(LauncherAppsLoaded(apps, event.filter));
  }

  Future<void> _onBtnPressed(
    BtnPressed event,
    Emitter<LauncherState> emit,
  ) async {
    HapticFeedback.mediumImpact();
    if (event.btn == null) {
      if (_filter != null) {
        var length = _filter!.length;
        if (length > 0) {
          _filter = _filter!.substring(0, _filter!.length - 1);
        }
        _filter = _filter == '' ? null : _filter;
      }
    } else {
      _filter = _filter == null ? event.btn : _filter! + event.btn!;
    }
    if (_filter != null) {
      _delayedClear();
    }
    var apps = await _appsRepository.search(_filter);
    emit(LauncherAppsLoaded(apps, _filter));
  }

  Future<void> _onBtnLongPressed(
    BtnLongPressed event,
    Emitter<LauncherState> emit,
  ) async {
    HapticFeedback.heavyImpact();
    if (event.btn == null) {
      _navigatorBloc.add(Navigate(Routes.settings.route));
      return;
    }
  }

  Future<void> _delayedClear() async {
    _lastSearchPress = DateTime.now();
    const duration = Duration(seconds: 3);
    await Future.delayed(duration);
    if (DateTime.now().subtract(duration).compareTo(_lastSearchPress) <= 0) {
      return;
    }
    _filter = null;
  }
}
