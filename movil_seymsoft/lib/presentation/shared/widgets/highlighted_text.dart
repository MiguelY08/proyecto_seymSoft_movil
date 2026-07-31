import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = cleanQuery.toLowerCase();
    final spans = <TextSpan>[];
    var cursor = 0;

    while (cursor < text.length) {
      final matchIndex = lowerText.indexOf(lowerQuery, cursor);
      if (matchIndex < 0) {
        spans.add(TextSpan(text: text.substring(cursor)));
        break;
      }
      if (matchIndex > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, matchIndex)));
      }
      final matchEnd = matchIndex + cleanQuery.length;
      spans.add(
        TextSpan(
          text: text.substring(matchIndex, matchEnd),
          style: const TextStyle(
            decoration: TextDecoration.underline,
            decorationThickness: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
      cursor = matchEnd;
    }

    return Text.rich(
      TextSpan(style: style, children: spans),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
