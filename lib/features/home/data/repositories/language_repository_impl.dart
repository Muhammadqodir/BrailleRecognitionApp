import '../../domain/entities/language.dart';
import '../../domain/repositories/language_repository.dart';
import '../datasources/language_remote_data_source.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageRemoteDataSource remoteDataSource;

  LanguageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Language>> getLanguages() async {
    return await remoteDataSource.getLanguages();
  }
}
