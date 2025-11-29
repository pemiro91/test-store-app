import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/domain/entities/product_entity.dart';
import 'package:store/domain/usecases/get_product_details_usecase.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  GoogleMapController? _controller;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  StreamSubscription<Position>? _positionSub;

  ProductDetailCubit({required this.getProductDetailsUseCase})
    : super(ProductDetailState());

  void setMapController(GoogleMapController controller) {
    _controller = controller;
  }

  void loadProductDetail(String productId) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            message:
                "No se otorgaron permisos de ubicación. Activa los permisos manualmente.",
          ),
        );
        return;
      }

      final result = await getProductDetailsUseCase(productId: productId);
      ProductEntity? product;

      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ProductDetailStatus.error,
            message: "Error al cargar: ${failure.message}",
          ),
        ),
        (productServer) {
          product = productServer;
        },
      );
      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 1,
        ),
      ).listen((pos){
        final location = LatLng(pos.latitude, pos.longitude);
        emit(
          state.copyWith(
            status: ProductDetailStatus.success,
            product: product,
            userLocation: location,
          ),
        );
        if (_controller != null) {
          _controller!.animateCamera(
            CameraUpdate.newLatLng(location),
          );
        }
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductDetailStatus.error,
          message: "Error al cargar: $e",
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    return super.close();
  }
}
