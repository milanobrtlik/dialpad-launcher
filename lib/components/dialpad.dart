import 'package:flutter/material.dart';

import 'button.dart';

class Dialpad extends StatelessWidget {
  const Dialpad(this._onPressed, this._onLongPress, {Key? key})
      : super(key: key);

  final Function _onPressed;
  final Function _onLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 5,
            spreadRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BtnClr(
                const TwoLineButton(
                  '1',
                  Icon(
                    Icons.backspace_outlined,
                  ),
                ),
                _onPressed,
                _onLongPress,
              ),
              const VerticalDivider(width: 24),
              DialpadButton('2', 'ABC', _onPressed),
              const VerticalDivider(width: 24),
              DialpadButton('3', 'DEF', _onPressed),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DialpadButton('4', 'GHI', _onPressed),
              const VerticalDivider(width: 24),
              DialpadButton('5', 'JKL', _onPressed),
              const VerticalDivider(width: 24),
              DialpadButton('6', 'MNO', _onPressed),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DialpadButton('7', 'PQRS', _onPressed),
              const VerticalDivider(width: 24),
              DialpadButton('8', 'TUV', _onPressed),
              const VerticalDivider(width: 24),
              DialpadButton('9', 'WXYZ', _onPressed),
            ],
          ),
        ],
      ),
    );
  }
}
