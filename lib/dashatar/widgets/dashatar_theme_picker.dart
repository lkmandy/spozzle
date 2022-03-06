import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
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

  static const double _activeThemeNormalSize = 180.0;
  static const double _activeThemeSmallSize = 140.0;
  static const double _borderRadiusSmallSize = 4.0;
  static const double _inactiveThemeNormalSize = 96.0;
  static const double _inactiveThemeSmallSize = 50.0;
  static const double _borderRadiusNormalSize = 8.0;
  static const double _borderRadiusNormalSizeBig = 8.0;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarThemePicker> createState() => _DashatarThemePickerState();
}

class _DashatarThemePickerState extends State<DashatarThemePicker> {
  late final AudioPlayer _audioPlayer;
  int index = 0;
  int endIndex = 3;

  late CarouselSliderController _sliderController;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory();
    _sliderController = CarouselSliderController();
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
            final double borderRadius = isSmallSize
                ? DashatarThemePicker._borderRadiusSmallSize
                : DashatarThemePicker._borderRadiusNormalSize;
            final double borderRadiusBig = isSmallSize
                ? DashatarThemePicker._borderRadiusNormalSize
                : DashatarThemePicker._borderRadiusNormalSizeBig;
            final double inactiveSize = isSmallSize
                ? DashatarThemePicker._inactiveThemeSmallSize
                : DashatarThemePicker._inactiveThemeNormalSize;

            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.white54,
                    iconSize: 32,
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: () async {
                      if (index > 0)
                        setState(() {
                          index--;
                        });
                      _sliderController.previousPage();
                      context
                          .read<DashatarThemeBloc>()
                          .add(DashatarThemeChanged(themeIndex: index));

                      // Play the audio of the current Dashatar theme.
                      await _audioPlayer.setAsset(themeState.theme.audioAsset);
                      unawaited(_audioPlayer.play());
                    },
                  ),
                  SizedBox(
                    key: const Key('dashatar_theme_picker'),
                    height: activeSize,
                    width: activeSize * 1.3,
                    child: CarouselSlider.builder(
                        controller: _sliderController,
                        slideBuilder: (int index) {
                          themeState.themes.length;
                          final DashatarTheme theme = themeState.themes[index];
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
                                      DashatarThemeChanged(themeIndex: index));

                                  // Play the audio of the current Dashatar theme.
                                  await _audioPlayer.setAsset(theme.audioAsset);
                                  unawaited(_audioPlayer.play());
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage(theme.backgroundPattern),
                                        fit: BoxFit.cover),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                    child: Image.asset(
                                      theme.themeAsset,
                                      fit: BoxFit.fill,
                                      semanticLabel:
                                          theme.semanticsLabel(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        slideTransform: CubeTransform(),
                        slideIndicator: CircularSlideIndicator(
                          indicatorRadius: 5.0,
                            padding: EdgeInsets.only(bottom: 4.0),
                            alignment: Alignment.bottomCenter,
                            indicatorBorderColor: themeState.theme.buttonColor,
                            currentIndicatorColor:
                                themeState.theme.buttonColor),
                        itemCount: themeState.themes.length),
                  ),
                  IconButton(
                    color: Colors.white54,
                    iconSize: 32,
                    icon: Icon(Icons.keyboard_arrow_right),
                    onPressed: () async {
                      if (index < endIndex)
                        setState(() {
                          index++;
                        });
                      _sliderController.nextPage();

                      context
                          .read<DashatarThemeBloc>()
                          .add(DashatarThemeChanged(themeIndex: index));

                      // Play the audio of the current Dashatar theme.
                      await _audioPlayer.setAsset(themeState.theme.audioAsset);
                      unawaited(_audioPlayer.play());
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
