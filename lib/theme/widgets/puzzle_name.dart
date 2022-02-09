import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../l10n/l10n.dart';

import '../../layout/layout.dart';
import '../../typography/typography.dart';
import '../theme.dart';

/// {@template puzzle_name}
/// Displays the name of the current puzzle theme.
/// Visible only on a large layout.
/// {@endtemplate}
class PuzzleName extends StatelessWidget {
  /// {@macro puzzle_name}
  const PuzzleName({
    Key? key,
    this.color,
  }) : super(key: key);

  /// The color of this name, defaults to [PuzzleTheme.nameColor].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final Color nameColor = color ?? theme.nameColor;

    return ResponsiveLayoutBuilder(
      small: (BuildContext context, Widget? child) =>
          Center(child: puzzleName(context, nameColor, theme.name)),
      medium: (BuildContext context, Widget? child) =>
          Center(child: puzzleName(context, nameColor, theme.name)),
      large: (BuildContext context, Widget? child) =>
          puzzleName(context, nameColor, theme.name),
    );
  }

  AnimatedDefaultTextStyle puzzleName(
      BuildContext context, Color nameColor, String name) {
    return AnimatedDefaultTextStyle(
      style: PuzzleTextStyle.headline5.copyWith(
        color: nameColor,
      ),
      duration: PuzzleThemeAnimationDuration.textStyle,
      child: Text(
        context.l10n.puzzleChallengeName,
        key: const Key('puzzle_name_theme'),
      ),
    );
  }
}
