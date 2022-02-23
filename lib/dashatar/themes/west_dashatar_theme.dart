import 'package:flutter/material.dart';

import '../../colors/colors.dart';
import '../../l10n/l10n.dart';
import '../dashatar.dart';

/// {@template blue_dashatar_theme}
/// The blue dashatar puzzle theme.
/// {@endtemplate}
class WestDashatarTheme extends DashatarTheme {
  /// {@macro blue_dashatar_theme}
  const WestDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarWestDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.bluePrimary;

  @override
  String get backgroundPattern => 'assets/images/dashatar/background_pattern/west_bg.png';

  @override
  Color get defaultColor => PuzzleColors.blue90;

  @override
  Color get buttonColor => PuzzleColors.blue50;

  @override
  Color get menuInactiveColor => PuzzleColors.blue50;

  @override
  Color get countdownColor => PuzzleColors.blue50;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/west.png';

  @override
  String get successThemeAsset => 'assets/images/dashatar/success/west.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/west_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/west.mp3';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/west';
}
