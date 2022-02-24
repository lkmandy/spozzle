part of 'language_control_bloc.dart';

class LanguageControlState extends Equatable {
  const LanguageControlState({
    required this.languages,
    this.language = const Language(0, '🇺🇸', 'English', 'en'),
  });

  /// The list of all available [Language]s.
  final List<Language> languages;

  /// Currently selected [Language].
  final Language language;

  @override
  List<Object> get props => [languages, language];

  LanguageControlState copyWith({
    List<Language>? languages,
    Language? language,
  }) {
    return LanguageControlState(
      languages: languages ?? this.languages,
      language: language ?? this.language,
    );
  }
}
