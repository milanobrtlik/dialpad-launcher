part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorEvent {}

class Navigate extends NavigatorEvent {
  final String path;

  Navigate(this.path);
}
