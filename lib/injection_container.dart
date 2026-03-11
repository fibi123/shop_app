import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/dio_client.dart';
import '../core/network/network_info.dart';

import '../data/datasources/local/auth_local_datasource.dart';
import '../data/datasources/local/theme_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/datasources/remote/products_remote_datasource.dart';
import '../data/datasources/remote/posts_remote_datasource.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/products_repository_impl.dart';
import '../data/repositories/posts_repository_impl.dart';

import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/products_repository.dart';
import '../domain/repositories/posts_repository.dart';

import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../domain/usecases/get_posts_usecase.dart';

import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/products/products_bloc.dart';
import '../presentation/bloc/posts/posts_bloc.dart';
import '../presentation/bloc/theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── External ──────────────────────────────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // ── Core ──────────────────────────────────────────────────────
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // ── Data sources ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );

  // ── Repositories ──────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ── Use cases ─────────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));

  // ── BLoCs ─────────────────────────────────────────────────────
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCachedUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ProductsBloc(getProductsUseCase: sl()),
  );
  sl.registerFactory(
    () => PostsBloc(getPostsUseCase: sl()),
  );
  sl.registerLazySingleton(
    () => ThemeCubit(themeLocalDataSource: sl()),
  );
}
