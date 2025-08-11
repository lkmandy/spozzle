// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get puzzleChangeTooltip => 'Changing the theme will reset your score';

  @override
  String get puzzleRestartTooltip =>
      'Restarting the puzzle will reset your score';

  @override
  String get puzzleChallengeTitle => 'Puzzle Challenge';

  @override
  String get puzzleChallengeName => 'Dash in Africa';

  @override
  String get puzzleNumberOfMoves => 'Moves';

  @override
  String get puzzleNumberOfTilesLeft => 'Tiles';

  @override
  String get puzzleShuffle => 'Shuffle';

  @override
  String get puzzleCompleted => 'Well done. Congrats!';

  @override
  String get dashatarStartGame => 'Start Game';

  @override
  String get dashatarGetReady => 'Get ready...';

  @override
  String get dashatarRestart => 'Restart';

  @override
  String get dashatarCountdownGo => 'GO!';

  @override
  String get dashatarSuccessCompleted => 'It\'s a wrap...';

  @override
  String get dashatarSuccessWellDone => 'You\'re a Genius.\nGreat Job!!';

  @override
  String dashatarSuccessScore(String timeElapsed) {
    return 'Score: $timeElapsed';
  }

  @override
  String dashatarSuccessNumberOfMoves(String numberOfMoves) {
    return 'Moves: $numberOfMoves';
  }

  @override
  String puzzleTileLabelText(String value, String x, String y) {
    return 'Value: $value, position: $x, $y';
  }

  @override
  String puzzleNumberOfMovesAndTilesLeftLabelText(
      String numberOfMoves, String tilesLeft) {
    return 'Moves: $numberOfMoves, tiles: $tilesLeft';
  }

  @override
  String dashatarPuzzleDurationLabelText(
      String hours, String minutes, String seconds) {
    return '$hours hours $minutes minutes $seconds seconds';
  }

  @override
  String get dashatarWestDashLabelText => 'Dumbbell Dash';

  @override
  String get dashatarLittoralDashLabelText => 'Skateboard Dash';

  @override
  String get dashatarNorthDashLabelText => 'Sandwich Dash';

  @override
  String get dashatarNorthwestDashLabelText => 'Skateboard Dash';

  @override
  String get dashatarSuccessShareYourScoreTitle => 'Share your score!';

  @override
  String get dashatarSuccessShareYourScoreMessage =>
      'Invite your friends to enjoy the fun experience too!!';

  @override
  String get dashatarSuccessShareText =>
      'Just solved the #Spozzle Slide Challenge! Check it out ';
}
