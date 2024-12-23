import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../audio_control/audio_control.dart';
import '../../colors/colors.dart';
import '../../helpers/helpers.dart';
import '../../layout/layout.dart';
import '../../puzzle/puzzle.dart';
import '../../timer/bloc/timer_bloc.dart';
import '../dashatar.dart';

/// {@template dashatar_share_dialog}
/// Displays a Dashatar share dialog with a score of the completed puzzle
/// and an option to share the score using Twitter or Facebook.
/// {@endtemplate}
class DashatarShareDialog extends StatefulWidget {
  /// {@macro dashatar_share_dialog}
  const DashatarShareDialog({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarShareDialog> createState() => _DashatarShareDialogState();
}

class _DashatarShareDialogState extends State<DashatarShareDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AudioPlayer _successAudioPlayer;
  late final AudioPlayer _clickAudioPlayer;

  @override
  void initState() {
    super.initState();

    _successAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/victory.mp3');
    unawaited(_successAudioPlayer.play());

    _clickAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/click.mp3');

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    Future.delayed(
      const Duration(milliseconds: 140),
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _successAudioPlayer.dispose();
    _clickAudioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      key: const Key('dashatar_share_dialog_success_audio_player'),
      audioPlayer: _successAudioPlayer,
      child: AudioControlListener(
        key: const Key('dashatar_share_dialog_click_audio_player'),
        audioPlayer: _clickAudioPlayer,
        child: ResponsiveLayoutBuilder(
          small: (_, Widget? child) => child!,
          medium: (_, Widget? child) => child!,
          large: (_, Widget? child) => child!,
          child: (ResponsiveLayoutSize currentSize) {
            final EdgeInsets padding = currentSize == ResponsiveLayoutSize.large
                ? const EdgeInsets.fromLTRB(68, 82, 68, 73)
                : (currentSize == ResponsiveLayoutSize.medium
                    ? const EdgeInsets.fromLTRB(48, 54, 48, 53)
                    : const EdgeInsets.fromLTRB(20, 99, 20, 76));

            final Offset closeIconOffset = currentSize == ResponsiveLayoutSize.large
                ? const Offset(44, 37)
                : (currentSize == ResponsiveLayoutSize.medium
                    ? const Offset(25, 28)
                    : const Offset(17, 63));

            final CrossAxisAlignment crossAxisAlignment = currentSize == ResponsiveLayoutSize.large
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center;

            return Stack(
              key: const Key('dashatar_share_dialog'),
              children: <Widget>[
            SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      context.read<TimerBloc>().add(const TimerStopped());
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Padding(
                          padding: padding,
                          child: DashatarShareDialogAnimatedBuilder(
                            animation: _controller,
                            builder: (BuildContext context, Widget? child, DashatarShareDialogEnterAnimation animation) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: crossAxisAlignment,
                                children: <Widget>[
                                  SlideTransition(
                                    position: animation.scoreOffset,
                                    child: Opacity(
                                      opacity: animation.scoreOpacity.value,
                                      child: const DashatarScore(),
                                    ),
                                  ),
                                  const ResponsiveGap(
                                    small: 40,
                                    medium: 40,
                                    large: 80,
                                  ),
                                  DashatarShareYourScore(
                                    animation: animation,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: closeIconOffset.dx,
                  top: closeIconOffset.dy,
                  child: IconButton(
                    key: const Key('dashatar_share_dialog_close_button'),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    iconSize: 18,
                    icon: const Icon(
                      Icons.close,
                      color: PuzzleColors.black,
                    ),
                    onPressed: () {
                      unawaited(_clickAudioPlayer.play());
                      context.read<TimerBloc>().add(const TimerReset());
                      Navigator.push (
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => const PuzzlePage()),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
