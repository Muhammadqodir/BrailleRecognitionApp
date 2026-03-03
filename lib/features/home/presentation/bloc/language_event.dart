import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LoadLanguages extends LanguageEvent {
  const LoadLanguages();
}

class SelectLanguage extends LanguageEvent {
  final int languageId;

  const SelectLanguage(this.languageId);

  @override
  List<Object?> get props => [languageId];
}
