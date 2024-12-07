import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:nested/nested.dart';
import '../../audio_control/bloc/audio_control_bloc.dart';
import '../../colors/colors.dart';
import '../../helpers/modal_helper.dart';
import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../puzzle/bloc/puzzle_bloc.dart';
import '../../puzzle/puzzle.dart';
import '../../theme/theme.dart';
import '../../timer/timer.dart';
import '../../typography/typography.dart';
import '../bloc/dashatar_theme_bloc.dart';
import '../dashatar.dart';
import '../themes/dashatar_theme.dart';

/// {@template dashatar_timer}
/// Displays how many seconds elapsed since starting the puzzle.
/// {@endtemplate}
class DashatarTimer extends StatefulWidget {
  /// {@macro dashatar_timer}
  const DashatarTimer({
    Key? key,
    this.textStyle,
    this.iconSize,
    this.iconPadding,
    this.mainAxisAlignment,
  }) : super(key: key);

  /// The optional [TextStyle] of this timer.
  final TextStyle? textStyle;

  /// The optional icon [Size] of this timer.
  final Size? iconSize;

  /// The optional icon padding of this timer.
  final double? iconPadding;

  /// The optional [MainAxisAlignment] of this timer.
  /// Defaults to [MainAxisAlignment.center] if not provided.
  final MainAxisAlignment? mainAxisAlignment;

  @override
  State<DashatarTimer> createState() => _DashatarTimerState();
}

class _DashatarTimerState extends State<DashatarTimer>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  bool isPlaying = true;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final int secondsElapsed =
        context.select((TimerBloc bloc) => bloc.state.secondsElapsed);

    final DashatarTheme theme =
        context.select((DashatarThemeBloc bloc) => bloc.state.theme);

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (ResponsiveLayoutSize currentSize) {
        final TextStyle currentTextStyle = widget.textStyle ??
            (currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline4
                : PuzzleTextStyle.headline3);

        final Size currentIconSize = widget.iconSize ??
            (currentSize == ResponsiveLayoutSize.small
                ? const Size(28, 28)
                : const Size(32, 32));

        final Duration timeElapsed = Duration(seconds: secondsElapsed);

        return ResponsiveLayoutBuilder(
          small: (BuildContext context, Widget? child) => Row(
            key: const Key('dashatar_timer'),
            mainAxisAlignment:
                widget.mainAxisAlignment ?? MainAxisAlignment.center,
            children: <Widget>[
              if (context.read<TimerBloc>().state.isRunning &&
                  secondsElapsed > 0)
                BlocListener<TimerBloc, TimerState>(
                  listener: (BuildContext context, TimerState state) {
                    if (context.read<TimerBloc>().state.isRunning) {
                      _animationController!.reverse();
                    } else {
                      _animationController!.forward();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: theme.buttonColor, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          if (context.read<TimerBloc>().state.isRunning) {
                            _animationController!.forward();
                            context.read<TimerBloc>().add(const TimerStopped());
                          } else {
                            context.read<TimerBloc>().add(const TimerResumed());
                            _animationController!.reverse();
                          }
                        },
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: _animationController!,
                          color: theme.defaultColor,
                          size: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedDefaultTextStyle(
                style: currentTextStyle.copyWith(
                  color: PuzzleColors.white,
                ),
                duration: PuzzleThemeAnimationDuration.textStyle,
                child: Text(
                  _formatDuration(timeElapsed),
                  key: ValueKey(secondsElapsed),
                  semanticsLabel: _getDurationLabel(timeElapsed, context),
                ),
              ),
              Gap(widget.iconPadding ?? 8),
              Image.asset(
                'assets/images/timer_icon.png',
                key: const Key('dashatar_timer_icon'),
                width: currentIconSize.width,
                height: currentIconSize.height,
              ),
            ],
          ),
          medium: (BuildContext context, Widget? child) => Row(
            key: const Key('dashatar_timer'),
            mainAxisAlignment:
                widget.mainAxisAlignment ?? MainAxisAlignment.center,
            children: <Widget>[
              if (context.read<TimerBloc>().state.isRunning &&
                  secondsElapsed > 0)
                BlocListener<TimerBloc, TimerState>(
                  listener: (BuildContext context, TimerState state) {
                    if (context.read<TimerBloc>().state.isRunning) {
                      _animationController!.reverse();
                    } else {
                      _animationController!.forward();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: theme.buttonColor, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          if (context.read<TimerBloc>().state.isRunning) {
                            _animationController!.forward();
                            context.read<TimerBloc>().add(const TimerStopped());
                          } else {
                            context.read<TimerBloc>().add(const TimerResumed());
                            _animationController!.reverse();
                          }
                        },
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: _animationController!,
                          color: theme.defaultColor,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedDefaultTextStyle(
                style: currentTextStyle.copyWith(
                  color: PuzzleColors.white,
                ),
                duration: PuzzleThemeAnimationDuration.textStyle,
                child: Text(
                  _formatDuration(timeElapsed),
                  key: ValueKey(secondsElapsed),
                  semanticsLabel: _getDurationLabel(timeElapsed, context),
                ),
              ),
              Gap(widget.iconPadding ?? 8),
              Image.asset(
                'assets/images/timer_icon.png',
                key: const Key('dashatar_timer_icon'),
                width: currentIconSize.width,
                height: currentIconSize.height,
              ),
            ],
          ),
          large: (BuildContext context, Widget? child) => Row(
            key: const Key('dashatar_timer'),
            mainAxisAlignment:
                widget.mainAxisAlignment ?? MainAxisAlignment.center,
            children: <Widget>[
              if (context.read<TimerBloc>().state.isRunning &&
                  secondsElapsed > 0)
                BlocListener<TimerBloc, TimerState>(
                  listener: (BuildContext context, TimerState state) {
                    if (context.read<TimerBloc>().state.isRunning) {
                      _animationController!.reverse();
                    } else {
                      _animationController!.forward();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: theme.buttonColor, shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: () {
                          if (context.read<TimerBloc>().state.isRunning) {
                            _animationController!.forward();
                            context.read<TimerBloc>().add(const TimerStopped());
                          } else {
                            context.read<TimerBloc>().add(const TimerResumed());
                            _animationController!.reverse();
                          }
                        },
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.pause_play,
                          progress: _animationController!,
                          color: theme.defaultColor,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedDefaultTextStyle(
                style: currentTextStyle.copyWith(
                  color: PuzzleColors.white,
                ),
                duration: PuzzleThemeAnimationDuration.textStyle,
                child: Text(
                  _formatDuration(timeElapsed),
                  key: ValueKey(secondsElapsed),
                  semanticsLabel: _getDurationLabel(timeElapsed, context),
                ),
              ),
              Gap(widget.iconPadding ?? 8),
              Image.asset(
                'assets/images/timer_icon.png',
                key: const Key('dashatar_timer_icon'),
                width: currentIconSize.width,
                height: currentIconSize.height,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Timer> buildTimer(BuildContext context) async {
    return Timer(const Duration(milliseconds: 370), () async {
      await showAppDialog<void>(
        context: context,
        child: MultiBlocProvider(
          providers: <SingleChildWidget>[
            BlocProvider.value(
              value: context.read<DashatarThemeBloc>(),
            ),
            BlocProvider.value(
              value: context.read<PuzzleBloc>(),
            ),
            BlocProvider.value(
              value: context.read<TimerBloc>(),
            ),
            BlocProvider.value(
              value: context.read<AudioControlBloc>(),
            ),
          ],
          child: const DashatarShareDialog(),
        ),
      );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  String _getDurationLabel(Duration duration, BuildContext context) {
    return context.l10n.dashatarPuzzleDurationLabelText(
      duration.inHours.toString(),
      duration.inMinutes.remainder(60).toString(),
      duration.inSeconds.remainder(60).toString(),
    );
  }
}
