import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_languages_usecase.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final GetLanguagesUseCase getLanguagesUseCase;

  LanguageBloc({required this.getLanguagesUseCase})
      : super(const LanguageInitial()) {
    on<LoadLanguages>(_onLoadLanguages);
    on<SelectLanguage>(_onSelectLanguage);
  }

  Future<void> _onLoadLanguages(
    LoadLanguages event,
    Emitter<LanguageState> emit,
  ) async {
    emit(const LanguageLoading());
    try {
      final languages = await getLanguagesUseCase();
      emit(LanguageLoaded(
        languages: languages,
        selectedLanguage: languages.isNotEmpty ? languages.first : null,
      ));
    } catch (e) {
      emit(LanguageError(e.toString()));
    }
  }

  void _onSelectLanguage(
    SelectLanguage event,
    Emitter<LanguageState> emit,
  ) {
    final current = state;
    if (current is LanguageLoaded) {
      final matches = current.languages.where((l) => l.id == event.languageId);
      final selected = matches.isNotEmpty ? matches.first : current.languages.first;
      emit(current.copyWith(selectedLanguage: selected));
    }
  }
}
