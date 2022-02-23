import 'package:flutter/material.dart';
import 'package:spozzle/colors/colors.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/l10n/l10n.dart';

/// {@template green_dashatar_theme}
/// The green dashatar puzzle theme.
/// {@endtemplate}
class NorthwestDashatarTheme extends DashatarTheme {
  /// {@macro green_dashatar_theme}
  const NorthwestDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarNorthwestDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.greenPrimary;

  @override
  String get backgroundPattern => 'assets/images/dashatar/background_pattern/northwest_bg.png';

  @override
  Color get defaultColor => PuzzleColors.green90;

  @override
  Color get buttonColor => PuzzleColors.green50;

  @override
  Color get menuInactiveColor => PuzzleColors.green50;

  @override
  Color get countdownColor => PuzzleColors.green50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/northwest.png';

  @override
  String get successThemeAsset =>
      'assets/images/dashatar/success/northwest.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/northwest_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/north.mp3';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/northwest';
}
