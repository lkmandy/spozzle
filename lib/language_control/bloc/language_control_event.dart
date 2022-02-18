part of 'language_control_bloc.dart';

abstract class LanguageControlEvent extends Equatable {
  const LanguageControlEvent();
}

class LanguageControlChange extends LanguageControlEvent {
  const LanguageControlChange({required this.languageIndex});

  /// The index of the changed theme in [DashatarThemeState.themes].
  final int languageIndex;

  @override
  List<Object> get props => <int>[languageIndex];
}
