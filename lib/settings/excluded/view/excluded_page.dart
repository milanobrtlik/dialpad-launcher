import 'package:dialpad_launcher/settings/excluded/bloc/excluded_bloc.dart';
import 'package:dialpad_launcher/settings/excluded/view/excluded_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../apps_repository.dart';

class ExcludedPage extends StatelessWidget {
  const ExcludedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ExcludedBloc(ctx.read<AppsRepository>())..add(ExcludedReload()),
      child: const ExcludedView(),
    );
  }
}
