import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dialpad_launcher/apps_repository.dart';
import 'package:meta/meta.dart';

part 'prison_event.dart';

part 'prison_state.dart';

class PrisonBloc extends Bloc<PrisonEvent, PrisonState> {
  final AppsRepository _appsRepository;

  PrisonBloc(this._appsRepository) : super(PrisonLoading()) {
    on<PrisonReload>((event, emit) async {
      var apps = await _appsRepository.loadImprisoned();
      emit(PrisonLoaded(apps));
    });
  }
}
