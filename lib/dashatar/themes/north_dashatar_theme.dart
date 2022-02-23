import 'package:flutter/material.dart';
import 'package:spozzle/colors/colors.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/l10n/l10n.dart';

/// {@template pink_dashatar_theme}
/// The pink dashatar puzzle theme.
/// {@endtemplate}
class NorthDashatarTheme extends DashatarTheme {
  /// {@macro pink_dashatar_theme}
  const NorthDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarNorthDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.pinkPrimary;

  @override
  String get backgroundPattern => 'assets/images/dashatar/background_pattern/north_bg.png';

  @override
  Color get defaultColor => PuzzleColors.pink90;

  @override
  Color get buttonColor => PuzzleColors.pink50;

  @override
  Color get menuInactiveColor => PuzzleColors.pink50;

  @override
  Color get countdownColor => PuzzleColors.pink50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/north.png';

  @override
  String get successThemeAsset => 'assets/images/dashatar/success/north.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/north_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/northwest.mp3';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/north';
}
