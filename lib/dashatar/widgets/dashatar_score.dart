import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../colors/colors.dart';
import '../../l10n/arb/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../puzzle/puzzle.dart';
import '../../theme/themes/themes.dart';
import '../../theme/widgets/widgets.dart';
import '../../timer/bloc/timer_bloc.dart';
import '../../typography/typography.dart';
import '../dashatar.dart';

/// {@template dashatar_score}
/// Displays the score of the solved Dashatar puzzle.
/// {@endtemplate}
class DashatarScore extends StatelessWidget {
  /// {@macro dashatar_score}
  const DashatarScore({Key? key}) : super(key: key);

  static const Offset _smallImageOffset = Offset(124, 36);
  static const Offset _mediumImageOffset = Offset(215, -47);
  static const Offset _largeImageOffset = Offset(215, -47);

  @override
  Widget build(BuildContext context) {
    final DashatarTheme theme =
        context.select((DashatarThemeBloc bloc) => bloc.state.theme);
    final PuzzleState state = context.watch<PuzzleBloc>().state;
    final AppLocalizations l10n = context.l10n;

    final int secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (ResponsiveLayoutSize currentSize) {
        final double height =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 355.0;

        final Offset imageOffset = currentSize == ResponsiveLayoutSize.large
            ? _largeImageOffset
            : (currentSize == ResponsiveLayoutSize.medium
                ? _mediumImageOffset
                : _smallImageOffset);

        final double imageHeight =
            currentSize == ResponsiveLayoutSize.small ? 374.0 : 437.0;

        final double completedTextWidth =
            currentSize == ResponsiveLayoutSize.small ? 160.0 : double.infinity;

        final TextStyle wellDoneTextStyle =
            currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline4Soft
                : PuzzleTextStyle.headline3;

        final TextStyle timerTextStyle =
            currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline5
                : PuzzleTextStyle.headline4;

        final Size timerIconSize = currentSize == ResponsiveLayoutSize.small
            ? const Size(21, 21)
            : const Size(28, 28);

        final double timerIconPadding =
            currentSize == ResponsiveLayoutSize.small ? 4.0 : 6.0;

        final TextStyle numberOfMovesTextStyle =
            currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline5
                : PuzzleTextStyle.headline4;

        return ClipRRect(
          key: const Key('dashatar_score'),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(theme.backgroundPattern),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: imageOffset.dx,
                  top: imageOffset.dy,
                  child: Image.asset(
                    theme.successThemeAsset,
                    height: imageHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const AppFlutterLogo(
                        height: 18,
                        isColored: false,
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      SizedBox(
                        key: const Key('dashatar_score_completed'),
                        width: completedTextWidth,
                        child: AnimatedTextKit(
                          totalRepeatCount: 4,
                          pause: const Duration(milliseconds: 2000),
                          animatedTexts: <AnimatedText>[
                            TypewriterAnimatedText(
                              l10n.dashatarSuccessCompleted,
                              textStyle: PuzzleTextStyle.headline5.copyWith(
                                color: theme.defaultColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 16,
                        large: 16,
                      ),
                      AnimatedTextKit(
                        key: const Key('dashatar_score_well_done'),
                        totalRepeatCount: 4,
                        pause: const Duration(milliseconds: 2000),
                        animatedTexts: <AnimatedText>[
                          TypewriterAnimatedText(
                            l10n.dashatarSuccessWellDone,
                            textStyle: wellDoneTextStyle.copyWith(
                              color: PuzzleColors.white,
                            ),
                          ),
                        ],
                      ),
                      const ResponsiveGap(
                        small: 24,
                        medium: 32,
                        large: 32,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('dashatar_score_score'),
                        style: timerTextStyle.copyWith(
                          color: theme.defaultColor,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(
                          l10n.dashatarSuccessScore(
                              intToTimeLeft(secondsElapsed)),
                        ),
                      ),
                      const ResponsiveGap(
                        small: 8,
                        medium: 9,
                        large: 9,
                      ),
                      const ResponsiveGap(
                        small: 2,
                        medium: 8,
                        large: 8,
                      ),
                      AnimatedDefaultTextStyle(
                        key: const Key('dashatar_score_number_of_moves'),
                        style: numberOfMovesTextStyle.copyWith(
                          color: theme.defaultColor,
                        ),
                        duration: PuzzleThemeAnimationDuration.textStyle,
                        child: Text(
                          l10n.dashatarSuccessNumberOfMoves(
                            state.numberOfMoves.toString(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = (value - h * 3600) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    final String hourLeft = h.toString().length < 2 ? '0$h' : h.toString();

    final String minuteLeft = m.toString().length < 2 ? '0$m' : m.toString();

    final String secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();

    final String result = '$hourLeft:$minuteLeft:$secondsLeft';

    return result;
  }
}
