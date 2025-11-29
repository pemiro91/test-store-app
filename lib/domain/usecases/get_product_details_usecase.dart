import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/domain/entities/product_entity.dart';
import 'package:store/domain/repositories/product_repository.dart';

class GetProductDetailsUseCase {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<Either<Failure, ProductEntity>> call({required String productId}) async {
    return repository.getProductDetail(productId);
  }
}
