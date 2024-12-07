import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nested/nested.dart';
import '../../audio_control/audio_control.dart';
import '../../dashatar/dashatar.dart';
import '../../l10n/l10n.dart';
import '../../language_control/bloc/language_control_bloc.dart';
import '../../language_control/language.dart';
import '../../layout/layout.dart';
import '../../models/models.dart';
import '../../simple/simple.dart';
import '../../theme/theme.dart';
import '../../timer/timer.dart';
import '../../typography/typography.dart';
import '../puzzle.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider(
          create: (_) {
            final DashatarThemeBloc dashatarThemeBloc = DashatarThemeBloc(
              themes: const <DashatarTheme>[
                NorthwestDashatarTheme(),
                NorthDashatarTheme(),
                LittoralDashatarTheme(),
                WestDashatarTheme(),
              ],
            );
            return dashatarThemeBloc;
          },
        ),
        BlocProvider(
          create: (_) => DashatarPuzzleBloc(
            secondsToBegin: 3,
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => ThemeBloc(
            initialThemes: <PuzzleTheme>[
              context.read<DashatarThemeBloc>().state.theme,
            ],
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => AudioControlBloc(),
        ),
      ],
      child: const PuzzleView(),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final bool shufflePuzzle = theme is SimpleTheme;

    return Scaffold(
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(theme.backgroundPattern), fit: BoxFit.cover),
        ),
        child: BlocListener<DashatarThemeBloc, DashatarThemeState>(
          listener: (BuildContext context, DashatarThemeState state) {
            final DashatarTheme dashatarTheme =
                context.read<DashatarThemeBloc>().state.theme;
            context.read<ThemeBloc>().add(ThemeUpdated(theme: dashatarTheme));
          },
          child: MultiBlocProvider(
            providers: <SingleChildWidget>[
              BlocProvider(
                create: (BuildContext context) => TimerBloc(
                  ticker: const Ticker(),
                ),
              ),
              BlocProvider(
                create: (BuildContext context) => PuzzleBloc(4)
                  ..add(
                    PuzzleInitialized(
                      shufflePuzzle: shufflePuzzle,
                    ),
                  ),
              ),
            ],
            child: const _Puzzle(
              key: Key('puzzle_view_puzzle'),
            ),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final PuzzleState state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: const Column(
                  children: <Widget>[
                    PuzzleHeader(),
                    PuzzleSections(),
                  ],
                ),
              ),
            ),
            if (theme is! SimpleTheme)
              theme.layoutDelegate.backgroundBuilder(state),
          ],
        );
      },
    );
  }
}

/// {@template puzzle_header}
/// Displays the header of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleHeader extends StatelessWidget {
  /// {@macro puzzle_header}
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (BuildContext context, Widget? child) => const Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0,  16.0, 0.0),
          child: Header(),
        ),
        medium: (BuildContext context, Widget? child) => const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Header(),
        ),
        large: (BuildContext context, Widget? child) => const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Header(
            withName: false,
          ),
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({
    Key? key,
    this.withName = true,
  }) : super(key: key);
  final bool withName;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  void _changeLanguage(Language lang) {
    context
        .read<LanguageControlBloc>()
        .add(LanguageControlChange(languageIndex: lang.id));
  }

  @override
  Widget build(BuildContext context) {
    final DashatarTheme theme =
    context.select((DashatarThemeBloc bloc) => bloc.state.theme);

    return Stack(
      children: <Widget>[
        const Align(
          alignment: Alignment.centerLeft,
          child: PuzzleLogo(),
        ),
        if (widget.withName)
          const Align(
            alignment: Alignment.topCenter,
            child: PuzzleName(color: Colors.white54),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButton(
                  dropdownColor: theme.buttonColor,
                  onChanged: (Language? language) {
                    _changeLanguage(language!);
                  },
                  icon: const Icon(
                    LineIcons.language,
                    color: Colors.white54,
                    size: 24.0,
                  ),
                  underline: const SizedBox(),
                  items: context
                      .select(
                          (LanguageControlBloc bloc) => bloc.state.languages)
                      .map<DropdownMenuItem<Language>>((Language lang) =>
                          DropdownMenuItem(
                            value: lang,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(lang.flag,),
                                Text(lang.name, style: const TextStyle(color: Colors.white70),),
                              ],
                            ),
                          ))
                      .toList()
                    ..reversed,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: AudioControl(key: audioControlKey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// {@template puzzle_logo}
/// Displays the logo of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleLogo extends StatelessWidget {
  /// {@macro puzzle_logo}
  const PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppFlutterLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
    );
  }
}

/// {@template puzzle_sections}
/// Displays start and end sections of the puzzle.
/// {@endtemplate}
class PuzzleSections extends StatelessWidget {
  /// {@macro puzzle_sections}
  const PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final PuzzleState state = context.select((PuzzleBloc bloc) => bloc.state);

    return ResponsiveLayoutBuilder(
      small: (BuildContext context, Widget? child) => Column(
        children: <Widget>[
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      medium: (BuildContext context, Widget? child) => Column(
        children: <Widget>[
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      large: (BuildContext context, Widget? child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          const PuzzleBoard(),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final Puzzle puzzle =
        context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    final PuzzleState state = context.select((PuzzleBloc bloc) => bloc.state);

    final int size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (BuildContext context, PuzzleState state) {
          if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: theme.layoutDelegate.boardBuilder(
          size,
          puzzle.tiles
              .map(
                (Tile tile) => _PuzzleTile(
                  key: Key('puzzle_tile_${tile.value}'),
                  tile: tile,
                ),
              )
              .toList(),
          state: state,
        ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme theme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final PuzzleState state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}

/// {@template puzzle_menu}
/// Displays the menu of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleMenu extends StatelessWidget {
  /// {@macro puzzle_menu}
  const PuzzleMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => const SizedBox(),
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (ResponsiveLayoutSize currentSize) {
        return Row(
          children: <Widget>[
            const Gap(44),
            AudioControl(
              key: audioControlKey,
            )
          ],
        );
      },
    );
  }
}

/// {@template puzzle_menu_item}
/// Displays the menu item of the [PuzzleMenu].
/// {@endtemplate}
@visibleForTesting
class PuzzleMenuItem extends StatelessWidget {
  /// {@macro puzzle_menu_item}
  const PuzzleMenuItem({
    Key? key,
    required this.theme,
    required this.themeIndex,
  }) : super(key: key);

  /// The theme corresponding to this menu item.
  final PuzzleTheme theme;

  /// The index of [theme] in [ThemeState.themes].
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    final PuzzleTheme currentTheme =
        context.select((ThemeBloc bloc) => bloc.state.theme);
    final bool isCurrentTheme = theme == currentTheme;

    return ResponsiveLayoutBuilder(
      small: (_, Widget? child) => Column(
        children: <Widget>[
          Container(
            width: 100,
            height: 40,
            decoration: isCurrentTheme
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: currentTheme.menuUnderlineColor,
                      ),
                    ),
                  )
                : null,
            child: child,
          ),
        ],
      ),
      medium: (_, Widget? child) => child!,
      large: (_, Widget? child) => child!,
      child: (ResponsiveLayoutSize currentSize) {
        final double leftPadding =
            themeIndex > 0 && currentSize != ResponsiveLayoutSize.small
                ? 40.0
                : 0.0;

        return Padding(
          padding: EdgeInsets.only(left: leftPadding),
          child: Tooltip(
            message:
                theme != currentTheme ? context.l10n.puzzleChangeTooltip : '',
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ).copyWith(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                // Ignore if this theme is already selected.
                if (theme == currentTheme) {
                  return;
                }

                // Update the currently selected theme.
                context
                    .read<ThemeBloc>()
                    .add(ThemeChanged(themeIndex: themeIndex));

                // Reset the timer of the currently running puzzle.
                context.read<TimerBloc>().add(const TimerReset());

                // Stop the Dashatar countdown if it has been started.
                context.read<DashatarPuzzleBloc>().add(
                      const DashatarCountdownStopped(),
                    );

                // Initialize the puzzle board for the newly selected theme.
                context.read<PuzzleBloc>().add(
                      PuzzleInitialized(
                        shufflePuzzle: theme is SimpleTheme,
                      ),
                    );
              },
              child: AnimatedDefaultTextStyle(
                duration: PuzzleThemeAnimationDuration.textStyle,
                style: PuzzleTextStyle.headline5.copyWith(
                  color: isCurrentTheme
                      ? currentTheme.menuActiveColor
                      : currentTheme.menuInactiveColor,
                ),
                child: Text(theme.name),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The global key of [PuzzleLogo].
///
/// Used to animate the transition of [PuzzleLogo] when changing a theme.
final GlobalKey<State<StatefulWidget>> puzzleLogoKey =
    GlobalKey(debugLabel: 'puzzle_logo');

/// The global key of [PuzzleName].
///
/// Used to animate the transition of [PuzzleName] when changing a theme.
final GlobalKey<State<StatefulWidget>> puzzleNameKey =
    GlobalKey(debugLabel: 'puzzle_name');

/// The global key of [PuzzleTitle].
///
/// Used to animate the transition of [PuzzleTitle] when changing a theme.
final GlobalKey<State<StatefulWidget>> puzzleTitleKey =
    GlobalKey(debugLabel: 'puzzle_title');

/// The global key of [NumberOfMovesAndTilesLeft].
///
/// Used to animate the transition of [NumberOfMovesAndTilesLeft]
/// when changing a theme.
final GlobalKey<State<StatefulWidget>> numberOfMovesAndTilesLeftKey =
    GlobalKey(debugLabel: 'number_of_moves_and_tiles_left');

/// The global key of [AudioControl].
///
/// Used to animate the transition of [AudioControl]
/// when changing a theme.
final GlobalKey<State<StatefulWidget>> audioControlKey =
    GlobalKey(debugLabel: 'audio_control');
