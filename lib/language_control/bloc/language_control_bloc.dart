import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../language.dart';

part 'language_control_event.dart';
part 'language_control_state.dart';

class LanguageControlBloc
    extends Bloc<LanguageControlEvent, LanguageControlState> {
  LanguageControlBloc({required List<Language> languages})
      : super(LanguageControlState(languages: languages)) {
    on<LanguageControlChange>(_onLanguageControlChanged);
  }

  void _onLanguageControlChanged(
      LanguageControlChange event, Emitter<LanguageControlState> emit) {
    emit(
      state.copyWith(language: state.languages[event.languageIndex]),
    );
  }
}
