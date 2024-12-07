// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';

import '../../helpers/helpers.dart';
import '../../l10n/l10n.dart';
import '../../language_control/language_control.dart';
import '../../puzzle/puzzle.dart';

class App extends StatefulWidget {
  const App({Key? key, ValueGetter<PlatformHelper>? platformHelperFactory})
      : _platformHelperFactory = platformHelperFactory ?? getPlatformHelper,
        super(key: key);

  final ValueGetter<PlatformHelper> _platformHelperFactory;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// The path to local assets folder.
  static const String localAssetsPrefix = 'assets/';

  static final List<String> audioControlAssets = <String>[
    'assets/images/audio_control/simple_on.png',
    'assets/images/audio_control/simple_off.png',
    'assets/images/audio_control/dashatar_on.png',
    'assets/images/audio_control/littoral_dashatar_off.png',
    'assets/images/audio_control/west_dashatar_off.png',
    'assets/images/audio_control/north_dashatar_off.png',
  ];

  static final List<String> backgroundPatterns = <String>[
    'assets/images/dashatar/background_pattern/north_bg.png',
    'assets/images/dashatar/background_pattern/littoral_bg.png',
    'assets/images/dashatar/background_pattern/northwest_bg.png',
    'assets/images/dashatar/background_pattern/west_bg.png',
  ];

  static final List<String> audioAssets = <String>[
    'assets/audio/shuffle_board.mp3',
    'assets/audio/click.mp3',
    'assets/audio/littoral.mp3',
    'assets/audio/west.mp3',
    'assets/audio/northwest.mp3',
    'assets/audio/north.mp3',
    'assets/audio/victory.mp3',
    'assets/audio/tile_move.mp3',
  ];

  late final PlatformHelper _platformHelper;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _platformHelper = widget._platformHelperFactory();

    _timer = Timer(const Duration(milliseconds: 20), () {
      for (int i = 1; i <= 15; i++) {
        precacheImage(
          Image.asset('assets/images/dashatar/littoral/$i.png').image,
          context,
        );
        precacheImage(
          Image.asset('assets/images/dashatar/northwest/$i.png').image,
          context,
        );
        precacheImage(
          Image.asset('assets/images/dashatar/west/$i.png').image,
          context,
        );
        precacheImage(
          Image.asset('assets/images/dashatar/north/$i.png').image,
          context,
        );
      }
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/north.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/north.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/littoral.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/littoral.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/west.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/west.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/gallery/northwest.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/dashatar/success/northwest.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/logo_spozzle_color.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/logo_spozzle_white.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/shuffle_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/timer_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/simple_dash_large.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/simple_dash_medium.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/simple_dash_small.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/twitter_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/whatsapp_icon.png').image,
        context,
      );
      precacheImage(
        Image.asset('assets/images/facebook_icon.png').image,
        context,
      );

      for (final String audioControlAsset in audioControlAssets) {
        precacheImage(
          Image.asset(audioControlAsset).image,
          context,
        );
      }

      for (final String pattern in backgroundPatterns) {
        precacheImage(
          Image.asset(pattern).image,
          context,
        );
      }

      for (final String audioAsset in audioAssets) {
        prefetchToMemory(audioAsset);
      }
    });
  }

  /// Prefetches the given [filePath] to memory.
  Future<void> prefetchToMemory(String filePath) async {
    if (_platformHelper.isWeb) {
      // We rely on browser caching here. Once the browser downloads the file,
      // the native implementation should be able to access it from cache.
      await http.get(Uri.parse('$localAssetsPrefix$filePath'));
      return;
    }
    throw UnimplementedError(
      'The function `prefetchToMemory` is not implemented '
      'for platforms other than Web.',
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.blueGrey),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF37474F),
        ),
      ),
      locale: Locale(
        context.select(
          (LanguageControlBloc bloc) => bloc.state.language.languageCode,
        ),
      ),
      localizationsDelegates: const <LocalizationsDelegate>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        for (final Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      supportedLocales: AppLocalizations.supportedLocales,
      home: const PuzzlePage(),
    );
  }
}
