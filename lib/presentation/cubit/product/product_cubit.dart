import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/domain/entities/product_entity.dart';
import 'package:store/domain/usecases/get_products_usecase.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final int limit = 10;

  int page = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  ProductCubit({required this.getProductsUseCase}) : super(ProductState());

  List<ProductEntity> products = [];

  void fetchProducts() async {
    if (!hasMore || isLoadingMore) return;

    try {
      if (products.isEmpty) {
        emit(state.copyWith(status: ProductStatus.loading));
      } else {
        isLoadingMore = true;
        emit(
          state.copyWith(status: ProductStatus.loadingMore, products: products),
        );
      }

      final fetched = await getProductsUseCase(page: page, limit: limit);
      fetched.fold(
        (failure) => emit(
          state.copyWith(status: ProductStatus.error, message: failure.message),
        ),
        (fetched) {
          if (fetched.length < limit) hasMore = false;

          products.addAll(fetched);
          page++;
          emit(
            state.copyWith(status: ProductStatus.success, products: products),
          );

          isLoadingMore = false;
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.error,
          message: 'Error fetching products',
        ),
      );
      isLoadingMore = false;
    }
  }
}
