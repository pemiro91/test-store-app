import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({required int page, required int limit});
  Future<Either<Failure, ProductEntity>> getProductDetail(String productId);
}