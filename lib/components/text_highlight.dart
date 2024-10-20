import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  HighlightedText(this._text, this._filter, {Key? key}) : super(key: key);

  final String _text;
  final String? _filter;
  final _filters = [
    '',
    'abc',
    'def',
    'ghi',
    'jkl',
    'mno',
    'pqrs',
    'tuv',
    'wxyz'
  ];

  @override
  Widget build(BuildContext context) {
    if (_filter == null) {
      return RichText(
        text: TextSpan(text: _text, style: DefaultTextStyle.of(context).style),
      );
    }

    var children = List<TextSpan>.empty(growable: true);
    var filter = _filter!.split('');
    var possibleChars = '';

    for (var element in filter) {
      possibleChars += _filters[int.parse(element) - 1];
    }

    for (var char in _text.split('')) {
      if (possibleChars.contains(removeDiacritics(char.toLowerCase()))) {
        children.add(
          TextSpan(
            text: char,
            style: const TextStyle(
              color: Colors.indigoAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else {
        children.add(TextSpan(text: char));
      }
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.subtitle1,
        children: children,
      ),
    );
  }
}
