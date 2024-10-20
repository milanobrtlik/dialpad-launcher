import 'package:dialpad_launcher/app.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SettingsView extends StatelessWidget {
  const SettingsView(this._auth, {Key? key}) : super(key: key);
  final LocalAuthentication _auth;

  @override
  Widget build(BuildContext context) {
    var items = List<Widget>.from(
      [
        ListTile(
          leading: const Icon(Icons.lock),
          onTap: () async {
            bool? authenticated;
            try {
              authenticated = await _auth.authenticate(
                localizedReason: 'This section is protected, you can access it after successful login.',
              );
            } catch (e) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Error during auth. Maybe no device PIN or Fingerprint set.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Ok'),
                    ),
                  ],
                ),
              );
            }

            if (authenticated == true) {
              Navigator.of(context).pushNamed(Routes.prison.route);
            } else if(authenticated == false) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Ehm, fok off!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).maybePop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Okay '),
                          Icon(Icons.sentiment_dissatisfied_rounded),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          title: const Text('Imprisoned apps'),
        ),
        ListTile(
          leading: const Icon(Icons.visibility_off),
          onTap: () => Navigator.of(context).pushNamed(Routes.excluded.route),
          title: const Text('Excluded from search'),
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          onTap: () => Navigator.of(context).pushNamed(Routes.favorites.route),
          title: const Text('Favorite apps'),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          onTap: () => Navigator.of(context).pushNamed(Routes.about.route),
          title: const Text('About'),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (ctx, i) => items[i],
              separatorBuilder: (ctx, i) => const Divider(height: 0),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}
