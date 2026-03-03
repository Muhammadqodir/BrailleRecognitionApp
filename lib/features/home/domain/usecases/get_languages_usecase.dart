import '../entities/language.dart';
import '../repositories/language_repository.dart';

class GetLanguagesUseCase {
  final LanguageRepository repository;

  GetLanguagesUseCase(this.repository);

  Future<List<Language>> call() => repository.getLanguages();
}
