import 'package:flutter/material.dart';

import '../../colors/colors.dart';
import '../../l10n/l10n.dart';
import '../dashatar.dart';

/// {@template green_dashatar_theme}
/// The northwest dashatar puzzle theme.
/// {@endtemplate}
class NorthwestDashatarTheme extends DashatarTheme {
  /// {@macro green_dashatar_theme}
  const NorthwestDashatarTheme() : super();

  @override
  String semanticsLabel(BuildContext context) =>
      context.l10n.dashatarNorthwestDashLabelText;

  @override
  Color get backgroundColor => PuzzleColors.primary1;

  @override
  Color get defaultColor => PuzzleColors.primary7;

  @override
  Color get buttonColor => PuzzleColors.primary3;

  @override
  Color get menuInactiveColor => PuzzleColors.primary4;

  @override
  Color get countdownColor => PuzzleColors.primary5;

  @override
  String get themeAsset => 'assets/images/dashatar/gallery/northwest.png';

  @override
  String get successThemeAsset =>
      'assets/images/dashatar/success/northwest.png';

  @override
  String get audioControlOffAsset =>
      'assets/images/audio_control/northwest_dashatar_off.png';

  @override
  String get audioAsset => 'assets/audio/skateboard.mp3';

  @override
  String get dashAssetsDirectory => 'assets/images/dashatar/northwest';
}
