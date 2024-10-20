import 'package:device_apps/device_apps.dart';
import 'package:dialpad_launcher/launcher/bloc/launcher_bloc.dart';
import 'package:dialpad_launcher/settings/excluded/bloc/excluded_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExcludedView extends StatelessWidget {
  const ExcludedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Excluded apps'),
      ),
      body: BlocBuilder<ExcludedBloc, ExcludedState>(
        builder: (ctx, state) {
          if (state is ExcludedLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExcludedLoaded) {
            if (state.apps.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(48.0),
                child: Center(
                  child: Text(
                    'It looks like you\'re ok with all these shitty apps in your phone...\nGo find them and exclude them!',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (ctx, i) => _ExcludedAppTile(
                state.apps[i] as ApplicationWithIcon,
              ),
              separatorBuilder: (ctx, i) => const Divider(height: 0),
              itemCount: state.apps.length,
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

class _ExcludedAppTile extends StatelessWidget {
  const _ExcludedAppTile(this._app, {Key? key}) : super(key: key);

  final ApplicationWithIcon _app;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.memory(_app.icon, height: 48),
      title: Text(_app.appName),
      trailing: ElevatedButton(
        child: const Text('Restore'),
        onPressed: () async {
          var box = Hive.box('excluded');
          await box.delete(_app.packageName);
          context.read<ExcludedBloc>().add(ExcludedReload());
          context.read<LauncherBloc>().add(LauncherReload());
        },
      ),
    );
  }
}
