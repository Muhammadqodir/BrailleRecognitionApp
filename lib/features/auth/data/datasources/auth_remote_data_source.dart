import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage_helper.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle(String idToken);

  Future<UserModel> signInWithApple({
    required String identityToken,
    required String userId,
    String? name,
    String? email,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;
  final SecureStorageHelper secureStorage;

  AuthRemoteDataSourceImpl({
    required this.dioClient,
    required this.secureStorage,
  });

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 201) {
        final userData = response.data['user'];
        final token = response.data['token'];

        // Save token
        await secureStorage.saveToken(token);
        await secureStorage.saveUserId(userData['id']);

        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Registration failed');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final token = response.data['token'];

        // Save token
        await secureStorage.saveToken(token);
        await secureStorage.saveUserId(userData['id']);

        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Login failed');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle(String idToken) async {
    try {
      final response = await dioClient.post(
        ApiConstants.googleSignIn,
        data: {
          'id_token': idToken,
        },
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final token = response.data['token'];

        // Save token
        await secureStorage.saveToken(token);
        await secureStorage.saveUserId(userData['id']);

        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Google sign-in failed');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithApple({
    required String identityToken,
    required String userId,
    String? name,
    String? email,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.appleSignIn,
        data: {
          'identity_token': identityToken,
          'user_id': userId,
          if (name != null) 'name': name,
          if (email != null) 'email': email,
        },
      );

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        final token = response.data['token'];

        // Save token
        await secureStorage.saveToken(token);
        await secureStorage.saveUserId(userData['id']);

        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Apple sign-in failed');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dioClient.get(ApiConstants.me);

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        return UserModel.fromJson(userData);
      } else {
        throw ServerException('Failed to get current user');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post(ApiConstants.logout);
      await secureStorage.clearAll();
    } on DioException catch (e) {
      // Even if the request fails, clear local storage
      await secureStorage.clearAll();
      throw _handleDioError(e);
    } catch (e) {
      await secureStorage.clearAll();
      throw ServerException(e.toString());
    }
  }

  /// Handle Dio errors and convert to appropriate exceptions
  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Unknown error';
        
        if (statusCode == 401) {
          return UnauthorizedException(message);
        } else if (statusCode == 422) {
          return ValidationException(message);
        } else {
          return ServerException(message);
        }
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      default:
        return ServerException('Unexpected error occurred');
    }
  }
}
