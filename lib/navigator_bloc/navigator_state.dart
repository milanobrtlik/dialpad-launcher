part of 'navigator_bloc.dart';

@immutable
abstract class CustomNavigatorState {
  final String path;

  const CustomNavigatorState(this.path);
}

class NavigateTo extends CustomNavigatorState {
  const NavigateTo(String path) : super(path);
}
