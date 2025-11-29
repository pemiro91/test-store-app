import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/data/datasource/product_remote_data_source.dart';
import 'package:store/domain/entities/product_entity.dart';
import 'package:store/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({required int page, required int limit}) {
    return remoteDataSource.fetchProducts(page: page, limit: limit);
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductDetail(String productId) {
    return remoteDataSource.getProductDetail(productId: productId);
  }
}