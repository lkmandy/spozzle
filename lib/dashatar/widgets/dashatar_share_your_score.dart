import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../colors/colors.dart';
import '../../l10n/arb/app_localizations.dart';
import '../../l10n/l10n.dart';
import '../../layout/layout.dart';
import '../../typography/typography.dart';
import '../dashatar.dart';

/// {@template dashatar_share_your_score}
/// Displays buttons to share a score of the completed puzzle.
/// {@endtemplate}
class DashatarShareYourScore extends StatelessWidget {
  /// {@macro dashatar_share_your_score}
  const DashatarShareYourScore({
    Key? key,
    required this.animation,
  }) : super(key: key);

  /// The entry animation of this widget.
  final DashatarShareDialogEnterAnimation animation;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => child!,
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (ResponsiveLayoutSize currentSize) {
        final TextStyle titleTextStyle =
            currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.headline4
                : PuzzleTextStyle.headline3;

        final TextStyle messageTextStyle =
            currentSize == ResponsiveLayoutSize.small
                ? PuzzleTextStyle.bodyXSmall
                : PuzzleTextStyle.bodySmall;

        final CrossAxisAlignment titleAndMessageCrossAxisAlignment =
            currentSize == ResponsiveLayoutSize.large
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center;

        final TextAlign textAlign = currentSize == ResponsiveLayoutSize.large
            ? TextAlign.left
            : TextAlign.center;

        final double messageWidth = currentSize == ResponsiveLayoutSize.large
            ? double.infinity
            : (currentSize == ResponsiveLayoutSize.medium ? 434.0 : 307.0);

        final MainAxisAlignment buttonsMainAxisAlignment =
            currentSize == ResponsiveLayoutSize.large
                ? MainAxisAlignment.start
                : MainAxisAlignment.center;

        return Column(
          key: const Key('dashatar_share_your_score'),
          crossAxisAlignment: titleAndMessageCrossAxisAlignment,
          children: <Widget>[
            SlideTransition(
              position: animation.shareYourScoreOffset,
              child: Opacity(
                opacity: animation.shareYourScoreOpacity.value,
                child: Column(
                  crossAxisAlignment: titleAndMessageCrossAxisAlignment,
                  children: <Widget>[
                    Text(
                      l10n.dashatarSuccessShareYourScoreTitle,
                      key: const Key('dashatar_share_your_score_title'),
                      textAlign: textAlign,
                      style: titleTextStyle.copyWith(
                        color: PuzzleColors.black,
                      ),
                    ),
                    const Gap(16),
                    SizedBox(
                      width: messageWidth,
                      child: Text(
                        l10n.dashatarSuccessShareYourScoreMessage,
                        key: const Key('dashatar_share_your_score_message'),
                        textAlign: textAlign,
                        style: messageTextStyle.copyWith(
                          color: PuzzleColors.grey1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const ResponsiveGap(
              small: 40,
              medium: 40,
              large: 24,
            ),
            SlideTransition(
              position: animation.socialButtonsOffset,
              child: Opacity(
                opacity: animation.socialButtonsOpacity.value,
                child: Row(
                  mainAxisAlignment: buttonsMainAxisAlignment,
                  children: const <Widget>[
                    DashatarTwitterButton(),
                    Gap(16),
                    DashatarWhatsAppButton(),
                    Gap(16),
                    DashatarFacebookButton(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
