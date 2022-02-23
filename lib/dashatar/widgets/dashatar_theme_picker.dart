import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../audio_control/audio_control.dart';
import '../../helpers/helpers.dart';
import '../../layout/layout.dart';
import '../dashatar.dart';

/// {@template dashatar_theme_picker}
/// Displays the Dashatar theme picker to choose between
/// [DashatarThemeState.themes].
///
/// By default allows to choose between [WestDashatarTheme],
/// [LittoralDashatarTheme] or [NorthDashatarTheme].
/// {@endtemplate}
class DashatarThemePicker extends StatefulWidget {
  /// {@macro dashatar_theme_picker}
  const DashatarThemePicker({
    Key? key,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  static const double _activeThemeNormalSize = 140.0;
  static const double _activeThemeSmallSize = 85.0;
  static const double _inactiveThemeNormalSize = 96.0;
  static const double _inactiveThemeSmallSize = 50.0;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarThemePicker> createState() => _DashatarThemePickerState();
}

class _DashatarThemePickerState extends State<DashatarThemePicker> {
  late final AudioPlayer _audioPlayer;
  int initialIndex = 0;
  int endIndex = 2;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DashatarThemeState themeState =
        context.watch<DashatarThemeBloc>().state;
    final DashatarTheme activeTheme = themeState.theme;

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: ResponsiveLayoutBuilder(
        small: (_, Widget? child) => child!,
        medium: (_, Widget? child) => child!,
        large: (_, Widget? child) => child!,
        child: (ResponsiveLayoutSize currentSize) {
          final bool isSmallSize = currentSize == ResponsiveLayoutSize.small;
          final double activeSize = isSmallSize
              ? DashatarThemePicker._activeThemeSmallSize
              : DashatarThemePicker._activeThemeNormalSize;
          final double inactiveSize = isSmallSize
              ? DashatarThemePicker._inactiveThemeSmallSize
              : DashatarThemePicker._inactiveThemeNormalSize;

          return Stack(
            alignment: Alignment.center,
            children: [
              Align(
                child: AnimatedContainer(
                  width: activeSize,
                  height: activeSize,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 350),
                  child: Image.asset(
                    activeTheme.themeAsset,
                    fit: BoxFit.fill,
                    semanticLabel: activeTheme.semanticsLabel(context),
                    opacity: const AlwaysStoppedAnimation<double>(0.3),
                  ),
                ),
              ),
              Align(
                child: SizedBox(
                  key: const Key('dashatar_theme_picker'),
                  height: activeSize,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          child: initialIndex != 0 &&
                                  themeState.themes.length > 3
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (initialIndex != 0 && endIndex != 0) {
                                      setState(() {
                                        initialIndex -= 1;
                                        endIndex -= 1;
                                      });
                                    }
                                  },
                                )
                              : Container(),
                        ),
                        ...List<Widget>.generate(
                          themeState.themes.length,
                          (int index) {
                            final DashatarTheme theme =
                            themeState.themes[index];
                            final bool isActiveTheme = theme == activeTheme;
                            final double padding =
                            index > 0 ? (isSmallSize ? 4.0 : 8.0) : 0.0;
                            final double size = inactiveSize;

                            return Padding(
                              padding: EdgeInsets.only(left: padding),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  key: Key('dashatar_theme_picker_$index'),
                                  onTap: () async {
                                    if (isActiveTheme) {
                                      return;
                                    }

                                    // Update the current Dashatar theme.
                                    context.read<DashatarThemeBloc>().add(
                                        DashatarThemeChanged(
                                            themeIndex: index));

                                    // Play the audio of the current Dashatar theme.
                                    await _audioPlayer.setAsset(
                                        theme.audioAsset);
                                    unawaited(_audioPlayer.play());
                                  },
                                  child: AnimatedContainer(
                                    width: size,
                                    height: size,
                                    curve: Curves.easeInOut,
                                    duration: const Duration(milliseconds: 350),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        theme.themeAsset,
                                        fit: BoxFit.fill,
                                        semanticLabel: theme.semanticsLabel(
                                            context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),);
                          },), ],)
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
