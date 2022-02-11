import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../puzzle/puzzle.dart';
import '../../theme/theme.dart';
import '../dashatar.dart';

/// {@template dashatar_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
class DashatarStartSection extends StatelessWidget {
  /// {@macro dashatar_start_section}
  const DashatarStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        PuzzleName(
          key: puzzleNameKey,
        ),
        const ResponsiveGap(large: 16),
        PuzzleTitle(
          key: puzzleTitleKey,
          title: context.l10n.puzzleChallengeTitle,
        ),
        const ResponsiveGap(
          small: 8,
          medium: 18,
          large: 32,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const DashatarPuzzleActionButton(),
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const DashatarTimer(),
          medium: (_, __) => const DashatarTimer(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(small: 12),
      ],
    );
  }
}
