import 'package:flutter/material.dart';
import 'package:spozzle/colors/colors.dart';
import 'package:spozzle/dashatar/dashatar.dart';
import 'package:spozzle/l10n/l10n.dart';

/// {@template purple_dashatar_theme}
/// The purple dashatar puzzle theme.
/// {@endtemplate}
class LittoralDashatarTheme extends DashatarTheme {
  /// {@macro purple_dashatar_theme}
  const LittoralDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarLittoralDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.purplePrimary;

  @override
  String get backgroundPattern => 'assets/images/dashatar/background_pattern/littoral_bg.png';

  @override
  Color get defaultColor => PuzzleColors.purple90;

  @override
  Color get buttonColor => PuzzleColors.purple50;

  @override
  Color get menuInactiveColor => PuzzleColors.purple50;

  @override
  Color get countdownColor => PuzzleColors.purple50;

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
