import 'package:flutter/material.dart';
import 'package:spozzle/colors/colors.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/l10n/l10n.dart';

/// {@template yellow_dashatar_theme}
/// The yellow dashatar puzzle theme.
/// {@endtemplate}
class NorthDashatarTheme extends DashatarTheme {
  /// {@macro yellow_dashatar_theme}
  const NorthDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarNorthDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.yellowPrimary;

  @override
  AssetImage get backgroundPattern => const AssetImage('assets/images/dashatar/background_pattern/west.jpeg');

  @override
  Color get defaultColor => PuzzleColors.yellow90;

  @override
  Color get buttonColor => PuzzleColors.yellow50;

  @override
  Color get menuInactiveColor => PuzzleColors.yellow50;

  @override
  Color get countdownColor => PuzzleColors.yellow50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/north.png';

  @override
  String get successThemeAsset => 'assets/images/dashatar/success/north.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/north_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/north.mp3';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/north';
}
