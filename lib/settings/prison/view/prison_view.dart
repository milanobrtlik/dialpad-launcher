import 'package:device_apps/device_apps.dart';
import 'package:dialpad_launcher/launcher/bloc/launcher_bloc.dart';
import 'package:dialpad_launcher/settings/prison/bloc/prison_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PrisonView extends StatelessWidget {
  const PrisonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Imprisoned apps'),
      ),
      body: BlocBuilder<PrisonBloc, PrisonState>(
        builder: (ctx, state) {
          if (state is PrisonLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PrisonLoaded) {
            if (state.apps.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(48.0),
                child: Center(
                  child: Text(
                    'It looks like you have no apps imprisoned. Go catch few of them.',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (ctx, i) => _ImprisonedAppTile(
                state.apps[i] as ApplicationWithIcon,
              ),
              separatorBuilder: (ctx, i) => const Divider(height: 0),
              itemCount: state.apps.length,
            );
          }

          return const Center(
            child: Text('Something went wrong.'),
          );
        },
      ),
    );
  }
}

class _ImprisonedAppTile extends StatelessWidget {
  const _ImprisonedAppTile(this._app, {Key? key}) : super(key: key);

  final ApplicationWithIcon _app;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.memory(_app.icon, height: 48),
      title: Text(_app.appName),
      trailing: ElevatedButton(
        child: const Text('Remove'),
        onPressed: () async {
          var box = Hive.box('imprisoned');
          await box.delete(_app.packageName);
          context.read<PrisonBloc>().add(PrisonReload());
          context.read<LauncherBloc>().add(LauncherReload());
        },
      ),
    );
  }
}
