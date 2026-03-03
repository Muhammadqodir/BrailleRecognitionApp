import 'package:equatable/equatable.dart';
import '../../domain/entities/language.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageLoading extends LanguageState {
  const LanguageLoading();
}

class LanguageLoaded extends LanguageState {
  final List<Language> languages;
  final Language? selectedLanguage;

  const LanguageLoaded({
    required this.languages,
    this.selectedLanguage,
  });

  LanguageLoaded copyWith({
    List<Language>? languages,
    Language? selectedLanguage,
  }) {
    return LanguageLoaded(
      languages: languages ?? this.languages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [languages, selectedLanguage];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError(this.message);

  @override
  List<Object?> get props => [message];
}
