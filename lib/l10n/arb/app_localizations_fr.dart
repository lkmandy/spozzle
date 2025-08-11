// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get puzzleChangeTooltip =>
      'Le changement de thème réinitialisera votre score';

  @override
  String get puzzleRestartTooltip =>
      'Recommencer le puzzle réinitialisera votre score.';

  @override
  String get puzzleChallengeTitle => 'Défi de Jeu';

  @override
  String get puzzleChallengeName => 'Dash en Afrique';

  @override
  String get puzzleNumberOfMoves => 'Déplacements';

  @override
  String get puzzleNumberOfTilesLeft => 'Pièce';

  @override
  String get puzzleShuffle => 'Shuffle';

  @override
  String get puzzleCompleted => 'Bien joué. Félicitations !';

  @override
  String get dashatarStartGame => 'Début du jeu';

  @override
  String get dashatarGetReady => 'Préparez-vous...';

  @override
  String get dashatarRestart => 'Redémarrer';

  @override
  String get dashatarCountdownGo => 'VA!';

  @override
  String get dashatarSuccessCompleted => 'C\'est la fin...';

  @override
  String get dashatarSuccessWellDone => 'Tu es un Génie.\nBon Travail!!';

  @override
  String dashatarSuccessScore(String timeElapsed) {
    return 'But: $timeElapsed';
  }

  @override
  String dashatarSuccessNumberOfMoves(String numberOfMoves) {
    return 'Coups: $numberOfMoves';
  }

  @override
  String puzzleTileLabelText(String value, String x, String y) {
    return 'Valeur: $value, position: $x, $y';
  }

  @override
  String puzzleNumberOfMovesAndTilesLeftLabelText(
      String numberOfMoves, String tilesLeft) {
    return 'Déplacements: $numberOfMoves, Pièces: $tilesLeft';
  }

  @override
  String dashatarPuzzleDurationLabelText(
      String hours, String minutes, String seconds) {
    return '$hours heures $minutes minutes $seconds secondes';
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
  String get dashatarSuccessShareYourScoreTitle => 'Partagez votre score!';

  @override
  String get dashatarSuccessShareYourScoreMessage =>
      'Invitez vos amis à profiter de l\'expérience amusante aussi!!';

  @override
  String get dashatarSuccessShareText =>
      'Je viens de résoudre le #Spozzle Slide Challenge! Vérifiez-le ';
}
