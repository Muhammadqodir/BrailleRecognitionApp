import '../entities/language.dart';

abstract class LanguageRepository {
  Future<List<Language>> getLanguages();
}
