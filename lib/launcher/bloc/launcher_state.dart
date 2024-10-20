part of 'launcher_bloc.dart';

@immutable
abstract class LauncherState {}

class LauncherAppsLoading extends LauncherState {}

class LauncherAppsLoaded extends LauncherState {
  final List<Application> apps;
  final String? filter;

  LauncherAppsLoaded(this.apps, this.filter);
}

class LauncherAppsLoadingError extends LauncherState {}
