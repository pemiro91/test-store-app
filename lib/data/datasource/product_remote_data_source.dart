import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/core/network/dio_client.dart';
import 'package:store/core/utils/enviroments_values.dart';
import 'package:store/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> fetchProducts({
    required int page,
    required int limit,
  });

  Future<Either<Failure, ProductModel>> getProductDetail({required String productId});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, List<ProductModel>>> fetchProducts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '$baseUrl/products?page=$page&limit=$limit',
      );
      final List data = response.data as List;
      final products = data.map((json) => ProductModel.fromJson(json)).toList();

      return Right(products);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return Left(NetworkFailure("No hay conexión a internet"));
      }

      return Left(
        ServerFailure(e.response?.data["message"] ?? "Error del servidor"),
      );
    } catch (e) {
      return Left(ServerFailure("Ocurrió un error inesperado"));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductDetail({required String productId}) async {
    try {
      final response = await dioClient.dio.get('$baseUrl/products/$productId');
      final product = ProductModel.fromJson(response.data);
      return Right(product);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return Left(NetworkFailure("No hay conexión a internet"));
      }

      return Left(
        ServerFailure(e.response?.data["message"] ?? "Error del servidor"),
      );
    } catch (e) {
      return Left(ServerFailure("Ocurrió un error inesperado"));
    }
  }
}
