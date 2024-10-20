import 'package:dialpad_launcher/apps_repository.dart';
import 'package:dialpad_launcher/settings/prison/bloc/prison_bloc.dart';
import 'package:dialpad_launcher/settings/prison/view/prison_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrisonPage extends StatelessWidget {
  const PrisonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          PrisonBloc(ctx.read<AppsRepository>())..add(PrisonReload()),
      child: const PrisonView(),
    );
  }
}
