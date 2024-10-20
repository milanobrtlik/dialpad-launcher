import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:dialpad_launcher/components/dialpad.dart';
import 'package:dialpad_launcher/components/text_highlight.dart';
import 'package:dialpad_launcher/launcher/bloc/launcher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LauncherView extends StatelessWidget {
  const LauncherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceApps.listenToAppsChanges().listen((event) {
      if (event.event == ApplicationEventType.uninstalled) {
        context.read<LauncherBloc>().add(AppUninstalled(event.packageName));
      } else if (event.event == ApplicationEventType.installed) {
        context.read<LauncherBloc>().add(AppInstalled(event.packageName));
      }
    });
    return WillPopScope(
      onWillPop: () {
        context.read<LauncherBloc>().add(LauncherAppsLoadingStarted(null));
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<LauncherBloc, LauncherState>(
                  builder: (ctx, state) {
                    if (state is LauncherAppsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is LauncherAppsLoaded) {
                      if (state.apps.isEmpty) {
                        return const Center(child: Text('No results'));
                      }
                      return AppsList(state.apps, state.filter);
                    }

                    return const Center(child: Text('Error'));
                  },
                ),
              ),
              Dialpad(
                (btn) => context.read<LauncherBloc>()..add(BtnPressed(btn)),
                (btn) => context.read<LauncherBloc>()..add(BtnLongPressed(btn)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppsList extends StatelessWidget {
  const AppsList(this._apps, this._filter, {Key? key}) : super(key: key);

  final List<Application> _apps;
  final String? _filter;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: true,
      itemBuilder: (ctx, i) => _ListTile(
        _apps[i] as ApplicationWithIcon,
        _filter,
      ),
      separatorBuilder: (ctx, i) => const Divider(height: 0),
      itemCount: _apps.length,
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile(this._app, this._filter, {Key? key}) : super(key: key);

  final ApplicationWithIcon _app;
  final String? _filter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: 3),
      leading: Image.memory(_app.icon, width: 48),
      title: HighlightedText(_app.appName, _filter),
      onTap: () {
        context.read<LauncherBloc>().add(AppLaunched());
        _app.openApp();
      },
      onLongPress: () => showDialog(
        context: context,
        builder: (_) => _AppSubMenu(_app),
      ),
    );
  }
}

class _AppSubMenu extends StatelessWidget {
  const _AppSubMenu(this._app, {Key? key}) : super(key: key);

  final ApplicationWithIcon _app;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(_app.appName),
      children: [
        _SimpleDialogItem(
          Icons.lock,
          'Imprison',
          () {
            Hive.box('imprisoned').put(_app.packageName, _app.packageName);
            context.read<LauncherBloc>().add(LauncherReload());
            Navigator.of(context).maybePop();
          },
        ),
        _SimpleDialogItem(
          Icons.visibility_off,
          'Hide',
          () {
            Hive.box('excluded').put(_app.packageName, _app.packageName);
            context.read<LauncherBloc>().add(LauncherReload());
            Navigator.of(context).maybePop();
          },
        ),
        _SimpleDialogItem(
          Icons.delete_forever,
          'Uninstall',
          () {
            Navigator.of(context).pop();
            _app.uninstallApp();
          },
        ),
        _SimpleDialogItem(
          Icons.info_outline,
          'Info',
          () {
            Navigator.of(context).pop();
            _app.openSettingsScreen();
          },
        ),
      ],
    );
  }
}

class _SimpleDialogItem extends StatelessWidget {
  const _SimpleDialogItem(this._icon, this._title, this._onTap, {Key? key})
      : super(key: key);

  final IconData _icon;
  final String _title;
  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: _onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(_icon, size: 36.0),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(_title),
          ),
        ],
      ),
    );
  }
}
