import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spozzle/helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('getAudioPlayer', () {
    test('returns a new instance of AudioPlayer', () {
      expect(getAudioPlayer(), isA<AudioPlayer>());
    });
  });

  group('replay', () {
    test('replays the audio', () async {
      final AudioPlayer audioPlayer = AudioPlayer();
      unawaited(audioPlayer.play());

      int playCount = 0;
      audioPlayer.playingStream.listen((bool playing) {
        if (playing == true) {
          playCount++;
        }
      });

      await audioPlayer.replay();
      await Future.microtask(() {});

      expect(playCount, equals(2));
    });
  });
}
