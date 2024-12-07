import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../colors/colors.dart';
import '../../typography/typography.dart';
import '../theme.dart';

/// {@template puzzle_button}
/// Displays the puzzle action button.
/// {@endtemplate}
class PuzzleButton extends StatelessWidget {
  /// {@macro puzzle_button}
  const PuzzleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  /// The background color of this button.
  /// Defaults to [PuzzleTheme.buttonColor].
  final Color? backgroundColor;

  /// The text color of this button.
  /// Defaults to [PuzzleColors.white].
  final Color? textColor;

  /// Called when this button is tapped.
  final VoidCallback? onPressed;

  /// The label of this button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final Color buttonTextColor = textColor ?? PuzzleColors.white;
    final Color buttonBackgroundColor = backgroundColor ?? theme.buttonColor;

    return SizedBox(
      width: 60,
      height: 44,
      child: AnimatedTextButton(
        duration: PuzzleThemeAnimationDuration.textStyle,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: PuzzleTextStyle.headline5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(buttonBackgroundColor),
          foregroundColor: WidgetStateProperty.all(buttonTextColor),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
