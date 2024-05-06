import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final int? maxLines;
  const SectionTitle(this.text, {super.key, this.maxLines});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 3.0, bottom: 12.0),
        child: Text(
          text,
          overflow: TextOverflow.fade,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

class ListTitle extends StatelessWidget {
  final String text;
  final int? maxLines;
  const ListTitle(this.text, {super.key, this.maxLines});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
        child: Text(
          text,
          overflow: TextOverflow.fade,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleSmall?.fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}

class BodyText extends StatelessWidget {
  final String text;
  final int? maxLines;
  const BodyText(this.text, {super.key, this.maxLines});

  @override
  Widget build(BuildContext context) => Text(
        text,
        overflow: TextOverflow.fade,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
}

class BodyLargeText extends StatelessWidget {
  final String text;
  final int? maxLines;
  const BodyLargeText(this.text, {super.key, this.maxLines});

  @override
  Widget build(BuildContext context) => Text(
        text,
        overflow: TextOverflow.fade,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      );
}
