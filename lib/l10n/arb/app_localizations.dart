import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Shown as a tooltip for puzzle menu buttons
  ///
  /// In en, this message translates to:
  /// **'Changing the theme will reset your score'**
  String get puzzleChangeTooltip;

  /// Shown as a tooltip for the puzzle restart button
  ///
  /// In en, this message translates to:
  /// **'Restarting the puzzle will reset your score'**
  String get puzzleRestartTooltip;

  /// Shown as the title of the puzzle
  ///
  /// In en, this message translates to:
  /// **'Puzzle Challenge'**
  String get puzzleChallengeTitle;

  /// Shown as the name of the puzzle
  ///
  /// In en, this message translates to:
  /// **'Dash in Africa'**
  String get puzzleChallengeName;

  /// Indicates how many moves have been made on the current puzzle
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get puzzleNumberOfMoves;

  /// Indicates how many puzzle tiles are not in their correct position
  ///
  /// In en, this message translates to:
  /// **'Tiles'**
  String get puzzleNumberOfTilesLeft;

  /// Shown on the button that shuffle the puzzle
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get puzzleShuffle;

  /// Shown as the success state when the puzzle is completed
  ///
  /// In en, this message translates to:
  /// **'Well done. Congrats!'**
  String get puzzleCompleted;

  /// Shown before the puzzle is started
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get dashatarStartGame;

  /// No description provided for @dashatarGetReady.
  ///
  /// In en, this message translates to:
  /// **'Get ready...'**
  String get dashatarGetReady;

  /// Shown after the puzzle is started and may be restarted
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get dashatarRestart;

  /// Shown when the countdown has just finished and the puzzle is about to start
  ///
  /// In en, this message translates to:
  /// **'GO!'**
  String get dashatarCountdownGo;

  /// Shown as a title in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'It\'s a wrap...'**
  String get dashatarSuccessCompleted;

  /// Shown as a subtitle in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'You\'re a Genius.\nGreat Job!!'**
  String get dashatarSuccessWellDone;

  /// Shown as a score title in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'Score: {timeElapsed}'**
  String dashatarSuccessScore(String timeElapsed);

  /// Shown as a number of moves in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'Moves: {numberOfMoves}'**
  String dashatarSuccessNumberOfMoves(String numberOfMoves);

  /// Semantic label for the puzzle tile
  ///
  /// In en, this message translates to:
  /// **'Value: {value}, position: {x}, {y}'**
  String puzzleTileLabelText(String value, String x, String y);

  /// Semantic label for the puzzle tile
  ///
  /// In en, this message translates to:
  /// **'Moves: {numberOfMoves}, tiles: {tilesLeft}'**
  String puzzleNumberOfMovesAndTilesLeftLabelText(
      String numberOfMoves, String tilesLeft);

  /// Semantic label for the Dashatar timer
  ///
  /// In en, this message translates to:
  /// **'{hours} hours {minutes} minutes {seconds} seconds'**
  String dashatarPuzzleDurationLabelText(
      String hours, String minutes, String seconds);

  /// Semantic label for the blue Dash
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Dash'**
  String get dashatarWestDashLabelText;

  /// Semantic label for the green Dash
  ///
  /// In en, this message translates to:
  /// **'Skateboard Dash'**
  String get dashatarLittoralDashLabelText;

  /// Semantic label for the yellow Dash
  ///
  /// In en, this message translates to:
  /// **'Sandwich Dash'**
  String get dashatarNorthDashLabelText;

  /// Semantic label for the green Dash
  ///
  /// In en, this message translates to:
  /// **'Skateboard Dash'**
  String get dashatarNorthwestDashLabelText;

  /// Shown as a share title in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'Share your score!'**
  String get dashatarSuccessShareYourScoreTitle;

  /// Shown as a share message in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'Invite your friends to enjoy the fun experience too!!'**
  String get dashatarSuccessShareYourScoreMessage;

  /// The text to share for this Flutter Puzzle challenge, shown in the Dashatar success state
  ///
  /// In en, this message translates to:
  /// **'Just solved the #Spozzle Slide Challenge! Check it out '**
  String get dashatarSuccessShareText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
