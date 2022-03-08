import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spozzle/audio_control/audio_control.dart';
import 'package:spozzle/helpers/helpers.dart';
import 'package:spozzle/l10n/l10n.dart';

/// The url to share for this Flutter Puzzle challenge.
const _shareUrl = 'https://spozzle.web.app/#/';

/// {@template dashatar_twitter_button}
/// Displays a button that shares the Flutter Puzzle challenge
/// on Twitter when tapped.
/// {@endtemplate}
class DashatarTwitterButton extends StatelessWidget {
  /// {@macro dashatar_twitter_button}
  const DashatarTwitterButton({Key? key}) : super(key: key);

  String _twitterShareUrl(BuildContext context) {
    final shareText = '${context.l10n.dashatarSuccessShareText} ${_shareUrl} \n#FlutterPuzzleHack #Flutter #Dart';
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://twitter.com/intent/tweet?text=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return DashatarShareButton(
      title: 'Twitter',
      icon: Image.asset(
        'assets/images/twitter_icon.png',
        width: 13.13,
        height: 10.67,
      ),
      color: const Color(0xFF13B9FD),
      onPressed: () => openLink(_twitterShareUrl(context)),
    );
  }
}

/// {@template dashatar_whatsapp_button}
/// Displays a button that shares the Flutter Puzzle challenge
/// on Whatsapp when tapped.
/// {@endtemplate}
class DashatarWhatsAppButton extends StatelessWidget {
  /// {@macro dashatar_whatsapp_button}
  const DashatarWhatsAppButton({Key? key}) : super(key: key);

  String _whatsAppShareUrl(BuildContext context) {
    final shareText = '${context.l10n.dashatarSuccessShareText} ${_shareUrl} \n#FlutterPuzzleHack #Flutter #Dart';
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://wa.me/?text=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return DashatarShareButton(
      title: 'WhatsApp',
      icon: Image.asset(
        'assets/images/whatsapp_icon.png',
        width: 13.13,
        height: 10.67,
      ),
      color: const Color(0xFF25D366),
      onPressed: () => openLink(_whatsAppShareUrl(context)),
    );
  }
}

/// {@template dashatar_facebook_button}
/// Displays a button that shares the Flutter Puzzle challenge
/// on Facebook when tapped.
/// {@endtemplate}
class DashatarFacebookButton extends StatelessWidget {
  /// {@macro dashatar_facebook_button}
  const DashatarFacebookButton({Key? key}) : super(key: key);

  String _facebookShareUrl(BuildContext context) {
    final shareText = context.l10n.dashatarSuccessShareText;
    final encodedShareText = Uri.encodeComponent(shareText);
    return 'https://www.facebook.com/sharer.php?u=$_shareUrl&quote=$encodedShareText';
  }

  @override
  Widget build(BuildContext context) {
    return DashatarShareButton(
      title: 'Facebook',
      icon: Image.asset(
        'assets/images/facebook_icon.png',
        width: 6.56,
        height: 13.13,
      ),
      color: const Color(0xFF0468D7),
      onPressed: () => openLink(_facebookShareUrl(context)),
    );
  }
}

/// {@template dashatar_share_button}
/// Displays a share button colored with [color] which
/// displays the [icon] and [title] as its content.
/// {@endtemplate}
@visibleForTesting
class DashatarShareButton extends StatefulWidget {
  /// {@macro dashatar_share_button}
  const DashatarShareButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
    required this.color,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback onPressed;

  /// The title of this button.
  final String title;

  /// The icon of this button.
  final Widget icon;

  /// The color of this button.
  final Color color;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<DashatarShareButton> createState() => _DashatarShareButtonState();
}

class _DashatarShareButtonState extends State<DashatarShareButton> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/click.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: widget.color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            primary: widget.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.transparent,
          ),
          onPressed: () async {
            widget.onPressed();
            unawaited(_audioPlayer.replay());
          },
          child: Row(
            children: [
              //const Gap(12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  width: 32,
                  height: 32,
                  color: widget.color,
                  child: widget.icon,
                ),
              ),
              // const Gap(10),
              // Text(
              //   widget.title,
              //   style: PuzzleTextStyle.headline5.copyWith(
              //     color: widget.color,
              //   ),
              // ),
              // const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
