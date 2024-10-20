part of 'excluded_bloc.dart';

@immutable
abstract class ExcludedState {}

class ExcludedLoading extends ExcludedState {}

class ExcludedLoaded extends ExcludedState {
  final List<Application> apps;

  ExcludedLoaded(this.apps);
}
