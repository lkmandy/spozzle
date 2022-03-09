import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/layout.dart';
import '../../typography/typography.dart';
import '../theme.dart';

/// {@template puzzle_title}
/// Displays the title of the puzzle in the given color.
/// {@endtemplate}
class PuzzleTitle extends StatelessWidget {
  /// {@macro puzzle_title}
  const PuzzleTitle({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  /// The title to be displayed.
  final String title;

  /// The color of [title], defaults to [PuzzleTheme.titleColor].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final Color titleColor = color ?? theme.titleColor;

    return ResponsiveLayoutBuilder(
      small: (BuildContext context, Widget? child) => Center(
        child: SizedBox(
          width: 300,
          child: Center(
            child: child,
          ),
        ),
      ),
      medium: (BuildContext context, Widget? child) => Center(
        child: child,
      ),
      large: (BuildContext context, Widget? child) => SizedBox(
        width: 300,
        child: child,
      ),
      child: (ResponsiveLayoutSize currentSize) {
        final TextStyle textStyle = (currentSize == ResponsiveLayoutSize.large
                ? PuzzleTextStyle.headline2
                : PuzzleTextStyle.headline4)
            .copyWith(color: titleColor);

        final TextAlign textAlign = currentSize == ResponsiveLayoutSize.small
            ? TextAlign.center
            : TextAlign.left;

        return AnimatedDefaultTextStyle(
          style: textStyle,
          duration: PuzzleThemeAnimationDuration.textStyle,
          child: Text(
            title,
            textAlign: textAlign,
            style: const TextStyle(color: Colors.white70),
          ),
        );
      },
    );
  }
}
