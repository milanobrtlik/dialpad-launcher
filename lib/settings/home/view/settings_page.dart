import 'package:dialpad_launcher/settings/home/view/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsView(LocalAuthentication());
  }
}
