import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/language_model.dart';

abstract class LanguageRemoteDataSource {
  Future<List<LanguageModel>> getLanguages();
}

class LanguageRemoteDataSourceImpl implements LanguageRemoteDataSource {
  final DioClient dioClient;

  LanguageRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<LanguageModel>> getLanguages() async {
    try {
      final response = await dioClient.get(ApiConstants.languages);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] as List<dynamic>;
        return data
            .map((json) => LanguageModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException('Failed to load languages');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
