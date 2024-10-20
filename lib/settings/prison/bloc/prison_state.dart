part of 'prison_bloc.dart';

@immutable
abstract class PrisonState {}

class PrisonLoading extends PrisonState {}

class PrisonLoaded extends PrisonState {
  final List<Application> apps;

  PrisonLoaded(this.apps);
}
