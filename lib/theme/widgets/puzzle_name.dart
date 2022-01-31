import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spozzle/layout/layout.dart';
import 'package:spozzle/theme/theme.dart';
import 'package:spozzle/typography/typography.dart';

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
    final PuzzleTheme theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final Color nameColor = color ?? theme.nameColor;

    return ResponsiveLayoutBuilder(
      small: (context, child) => const SizedBox(),
      medium: (context, child) => const SizedBox(),
      large: (context, child) => AnimatedDefaultTextStyle(
        style: PuzzleTextStyle.headline5.copyWith(
          color: nameColor,
        ),
        duration: PuzzleThemeAnimationDuration.textStyle,
        child: Text(
          theme.name,
          key: const Key('puzzle_name_theme'),
        ),
      ),
    );
  }
}
