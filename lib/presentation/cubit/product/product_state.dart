part of 'product_cubit.dart';

enum ProductStatus { idle, loading, loadingMore, success, error }

class ProductState {
  final ProductStatus status;
  final List<ProductEntity> products;
  final String? message;


  const ProductState({
    this.status = ProductStatus.idle,
    this.products = const [],
    this.message,

  });

  ProductState copyWith({
    ProductStatus? status,
    String? message,
    List<ProductEntity>? products,

  }) {
    return ProductState(
        status: status ?? this.status,
        message: message,
        products: products ?? this.products,
    );
  }
}

