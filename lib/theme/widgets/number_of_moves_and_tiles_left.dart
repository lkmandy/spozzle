import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../typography/typography.dart';
import '../theme.dart';

/// {@template number_of_moves_and_tiles_left}
/// Displays how many moves have been made on the current puzzle
/// and how many puzzle tiles are not in their correct position.
/// {@endtemplate}
class NumberOfMovesAndTilesLeft extends StatelessWidget {
  /// {@macro number_of_moves_and_tiles_left}
  const NumberOfMovesAndTilesLeft({
    Key? key,
    required this.numberOfMoves,
    required this.numberOfTilesLeft,
    this.color,
  }) : super(key: key);

  /// The number of moves to be displayed.
  final int numberOfMoves;

  /// The number of tiles left to be displayed.
  final int numberOfTilesLeft;

  /// The color of texts that display [numberOfMoves] and [numberOfTilesLeft].
  /// Defaults to [PuzzleTheme.defaultColor].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final AppLocalizations l10n = context.l10n;
    final Color textColor = color ?? theme.defaultColor;

    return ResponsiveLayoutBuilder(
      small: (BuildContext context, Widget? child) => Center(child: child),
      medium: (BuildContext context, Widget? child) => Center(child: child),
      large: (BuildContext context, Widget? child) => child!,
      child: (ResponsiveLayoutSize currentSize) {
        const MainAxisAlignment mainAxisAlignment =
            //  currentSize == ResponsiveLayoutSize.large
            //     ? MainAxisAlignment.start
            //     :
            MainAxisAlignment.end;

        final TextStyle bodyTextStyle =
            currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.bodySmall
                : PuzzleTextStyle.body;

        return Semantics(
          label: l10n.puzzleNumberOfMovesAndTilesLeftLabelText(
            numberOfMoves.toString(),
            numberOfTilesLeft.toString(),
          ),
          child: ExcludeSemantics(
            child: Row(
              key: const Key('number_of_moves_and_tiles_left'),
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                AnimatedDefaultTextStyle(
                  style: PuzzleTextStyle.headline4.copyWith(
                    color: textColor,
                  ),
                  duration: PuzzleThemeAnimationDuration.textStyle,
                  child: Text(' ${l10n.puzzleNumberOfMoves}: '),
                ),
                AnimatedDefaultTextStyle(
                  key: const Key('number_of_moves_and_tiles_left_moves'),
                  style: bodyTextStyle.copyWith(
                    color: textColor,
                  ),
                  duration: PuzzleThemeAnimationDuration.textStyle,
                  child: Text('${numberOfMoves.toString()}  '),
                ),
                AnimatedDefaultTextStyle(
                  style: PuzzleTextStyle.headline4.copyWith(
                    color: textColor,
                  ),
                  duration: PuzzleThemeAnimationDuration.textStyle,
                  child: Text(' ${l10n.puzzleNumberOfTilesLeft}: '),
                ),
                AnimatedDefaultTextStyle(
                  key: const Key('number_of_moves_and_tiles_left_tiles_left'),
                  style: bodyTextStyle.copyWith(
                    color: textColor,
                  ),
                  duration: PuzzleThemeAnimationDuration.textStyle,
                  child: Text(numberOfTilesLeft.toString()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
