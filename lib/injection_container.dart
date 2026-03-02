import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_helper.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/services/apple_signin_service.dart';
import 'features/auth/data/services/google_signin_service.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/apple_signin_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/google_signin_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      registerUseCase: sl(),
      loginUseCase: sl(),
      googleSignInUseCase: sl(),
      appleSignInUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      googleSignInService: sl(),
      appleSignInService: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => AppleSignInUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      secureStorage: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: sl(),
      secureStorage: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => GoogleSignInService(sl()));
  sl.registerLazySingleton(() => AppleSignInService());

  //! Core
  sl.registerLazySingleton(() => DioClient(sl()));
  sl.registerLazySingleton(() => SecureStorageHelper(sl()));

  //! External
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(
    () => GoogleSignIn(
      clientId: '743301996065-gtg71k9l0hr2us8v80skk50uiihvno71.apps.googleusercontent.com',
      scopes: [
        'email',
        'profile',
      ],
    ),
  );
}
