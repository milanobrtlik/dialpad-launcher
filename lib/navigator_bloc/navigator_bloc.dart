import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigator_event.dart';
part 'navigator_state.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, CustomNavigatorState> {
  NavigatorBloc() : super(const NavigateTo('/')) {
    on<Navigate>((event, emit) => emit(NavigateTo(event.path)));
  }
}
