
import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/domain/entities/product_entity.dart';
import 'package:store/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call({required int page, required int limit}) async {
    return repository.getProducts(page: page, limit: limit);
  }
}