import 'package:bloc/bloc.dart';
import 'package:dialpad_launcher/apps_repository.dart';
import 'package:dialpad_launcher/dialpad_launcher_observer.dart';
import 'package:dialpad_launcher/launcher/bloc/launcher_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'navigator_bloc/navigator_bloc.dart';

void main() async {
  await Hive.initFlutter();
  var imprisoned = await Hive.openBox('imprisoned');
  var excluded = await Hive.openBox('excluded');
  BlocOverrides.runZoned(
    () => runApp(
      RepositoryProvider.value(
        value: AppsRepository(imprisoned, excluded),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(
              create: (ctx) => NavigatorBloc(),
            ),
            BlocProvider<LauncherBloc>(
              create: (ctx) => LauncherBloc(
                  ctx.read<AppsRepository>(), ctx.read<NavigatorBloc>())
                ..add(LauncherReload()),
            ),
          ],
          child: const MyApp(),
        ),
      ),
    ),
    blocObserver: DialpadLauncherObserver(),
  );
}
