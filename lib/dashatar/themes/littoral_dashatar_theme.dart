import 'package:flutter/material.dart';
import 'package:spozzle/colors/colors.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/l10n/l10n.dart';

/// {@template green_dashatar_theme}
/// The green dashatar puzzle theme.
/// {@endtemplate}
class LittoralDashatarTheme extends DashatarTheme {
  /// {@macro green_dashatar_theme}
  const LittoralDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarLittoralDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.greenPrimary;

  @override
  AssetImage get backgroundPattern => const AssetImage('assets/images/dashatar/background_pattern/west.jpeg');

  @override
  Color get defaultColor => PuzzleColors.green90;

  @override
  Color get buttonColor => PuzzleColors.green50;

  @override
  Color get menuInactiveColor => PuzzleColors.green50;

  @override
  Color get countdownColor => PuzzleColors.green50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/littoral.png';

  @override
  String get successThemeAsset => 'assets/images/dashatar/success/littoral.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/littoral_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/littoral.mp3';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/littoral';
}
