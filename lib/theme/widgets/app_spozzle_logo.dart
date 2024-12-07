import 'package:flutter/material.dart';
import '../../layout/layout.dart';
import '../themes/themes.dart';

/// {@template app_flutter_logo}
/// Variant of the Spozzle logo that can be either white or colored.
/// {@endtemplate}
class AppFlutterLogo extends StatelessWidget {
  /// {@macro app_flutter_logo}
  const AppFlutterLogo({
    Key? key,
    this.isColored = true,
    this.height,
  }) : super(key: key);

  /// Whether this logo is colored.
  final bool isColored;

  /// The optional height of this logo.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final String assetName = isColored
        ? 'assets/images/logo_spozzle_color.png'
        : 'assets/images/logo_spozzle_white.png';

    return AnimatedSwitcher(
      duration: PuzzleThemeAnimationDuration.logoChange,
      child: height != null
          ? Image.asset(
              assetName,
              height: height,
            )
          : ResponsiveLayoutBuilder(
              key: Key(assetName),
              small: (_, __) => Image.asset(
                assetName,
                height: 30,
              ),
              medium: (_, __) => Image.asset(
                assetName,
                height: 38,
              ),
              large: (_, __) => Image.asset(
                assetName,
                height: 46,
              ),
            ),
    );
  }
}
