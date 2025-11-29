part of 'product_detail_cubit.dart';

enum ProductDetailStatus { idle, loading, success, error }

class ProductDetailState {
  final ProductDetailStatus status;
  final ProductEntity? product;
  final LatLng? userLocation;
  final String? message;

  const ProductDetailState({
    this.status = ProductDetailStatus.idle,
    this.product,
    this.userLocation,
    this.message,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    final ProductEntity? product,
    final LatLng? userLocation,
    String? message,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      userLocation: userLocation ?? this.userLocation,
      message: message,
    );
  }
}
