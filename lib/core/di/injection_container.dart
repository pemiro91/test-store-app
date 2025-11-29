import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:store/core/network/dio_client.dart';
import 'package:store/data/datasource/product_remote_data_source.dart';
import 'package:store/data/repositories/auth_repository_impl.dart';
import 'package:store/data/repositories/product_repository_impl.dart';
import 'package:store/domain/repositories/product_repository.dart';
import 'package:store/domain/usecases/get_product_details_usecase.dart';
import 'package:store/domain/usecases/get_products_usecase.dart';
import 'package:store/presentation/cubit/auth/auth_cubit.dart';
import 'package:store/presentation/cubit/login_form/login_form_cubit.dart';
import 'package:store/presentation/cubit/product/product_cubit.dart';
import 'package:store/presentation/cubit/product_detail/product_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final dioClient = DioClient();
  // Core
  sl.registerLazySingleton<Dio>(() => dioClient.dio);
  sl.registerLazySingleton(() => dioClient);
  // Datasource
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  // UseCase
  sl.registerLazySingleton(() => GetProductsUseCase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl<ProductRepository>()));
  // Repositories
  sl.registerLazySingleton<AuthRepositoryImpl>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<ProductRepositoryImpl>(
    () => ProductRepositoryImpl(sl()),
  );

  // Cubits / Blocs
  sl.registerFactory(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => ProductCubit(getProductsUseCase: sl()));
  sl.registerFactory(() => ProductDetailCubit(getProductDetailsUseCase: sl()));
  sl.registerFactory(() => LoginFormCubit());
}
