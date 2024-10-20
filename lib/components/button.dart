import 'package:flutter/material.dart';

class DialpadButton extends StatelessWidget {
  const DialpadButton(
    this.firstLine,
    this.secondLine,
    this.onPressed, {
    Key? key,
  }) : super(key: key);

  final String firstLine;
  final String secondLine;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () async {
          onPressed(firstLine);
        },
        child: Column(
          children: [
            Text(
              firstLine,
              style: const TextStyle(fontSize: 24),
            ),
            Text(secondLine),
          ],
        ),
      ),
    );
  }
}

class TwoLineButton extends StatelessWidget {
  const TwoLineButton(this._firstLine, this._secondLine, {Key? key})
      : super(key: key);

  final String _firstLine;
  final Widget _secondLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _firstLine,
          style: const TextStyle(fontSize: 24),
        ),
        _secondLine,
      ],
    );
  }
}

class BtnClr extends StatelessWidget {
  const BtnClr(this.child, this._onPressed, this._onLongPress, {Key? key})
      : super(key: key);

  final Function _onPressed;
  final Function _onLongPress;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () async => _onPressed(null),
        onLongPress: () async => _onLongPress(null),
        child: child,
      ),
    );
  }
}
