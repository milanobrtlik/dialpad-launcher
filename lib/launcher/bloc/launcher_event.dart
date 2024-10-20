part of 'launcher_bloc.dart';

@immutable
abstract class LauncherEvent {}

class LauncherReload extends LauncherEvent {}

class LauncherAppsLoadingStarted extends LauncherEvent {
  final String? filter;

  LauncherAppsLoadingStarted(this.filter);
}

class LauncherAppsLoadingDone extends LauncherEvent {
  LauncherAppsLoadingDone(this.apps);

  final List<Application> apps;
}

class BtnPressed extends LauncherEvent {
  final String? btn;

  BtnPressed(this.btn);
}

class BtnLongPressed extends LauncherEvent {
  final String? btn;

  BtnLongPressed(this.btn);
}

class AppLaunched extends LauncherEvent {}

class AppInstalled extends LauncherEvent {
  final String packageName;
  AppInstalled(this.packageName);
}

class AppUninstalled extends LauncherEvent {
  final String packageName;
  AppUninstalled(this.packageName);
}
