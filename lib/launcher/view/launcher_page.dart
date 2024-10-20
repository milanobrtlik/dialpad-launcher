import 'package:dialpad_launcher/launcher/view/launcher_view.dart';
import 'package:dialpad_launcher/navigator_bloc/navigator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LauncherPage extends StatelessWidget {
  const LauncherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigatorBloc, CustomNavigatorState>(
      listener: (context, state) {
        Navigator.of(context).pushNamed(state.path);
      },
      child: const LauncherView(),
    );
  }
}
