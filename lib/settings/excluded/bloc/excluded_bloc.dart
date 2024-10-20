import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dialpad_launcher/apps_repository.dart';
import 'package:meta/meta.dart';

part 'excluded_event.dart';

part 'excluded_state.dart';

class ExcludedBloc extends Bloc<ExcludedEvent, ExcludedState> {
  final AppsRepository _appsRepository;

  ExcludedBloc(this._appsRepository) : super(ExcludedLoading()) {
    on<ExcludedReload>((event, emit) async {
      emit(ExcludedLoading());
      var apps = await _appsRepository.loadExcluded();
      emit(ExcludedLoaded(apps));
    });
  }
}
