import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:store/core/utils/contants.dart';
import 'package:store/presentation/cubit/product_detail/product_detail_cubit.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        if (state.status == ProductDetailStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.status == ProductDetailStatus.error) {
          return Scaffold(body: Center(child: Text(state.message ?? "")));
        }
        final product = state.product;
        debugPrint("${state.userLocation}");
        return Scaffold(
          appBar: AppBar(title: Text(product?.name ?? "")),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.33,
                    width: double.infinity,
                    child: state.userLocation == null
                        ? const Center(child: CircularProgressIndicator())
                        : GoogleMap(
                            onMapCreated: (controller) {
                              context
                                  .read<ProductDetailCubit>()
                                  .setMapController(controller);
                            },
                            initialCameraPosition: CameraPosition(
                              target: state.userLocation!,
                              zoom: 15,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            markers: {
                              Marker(
                                markerId: const MarkerId('current_location'),
                                position:
                                    state.userLocation ?? const LatLng(0, 0),
                              ),
                            },
                          ),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              product?.thumbnail ??
                              "https://loremflickr.com/3362/3179?lock=6877186547094948",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.name ?? "Nombre vacio",
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product?.description ?? "Descripción vacia",
                                maxLines: 10,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (contextDialog) {
                              return AlertDialog(
                                title: Text(
                                  "Confirmar compra",
                                  style: GoogleFonts.roboto(fontSize: 16),
                                ),
                                content: Text(
                                  "¿Deseas confirmar la compra de este producto?",
                                  style: GoogleFonts.roboto(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(contextDialog, false),
                                    child: Text(
                                      "No",
                                      style: GoogleFonts.roboto(fontSize: 16),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(contextDialog, true),
                                    child: Text(
                                      "Sí",
                                      style: GoogleFonts.roboto(fontSize: 16),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (result == true) {
                            if (!context.mounted) return;
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text(
                                    "Compra exitosa",
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  ),
                                  content: Text(
                                    "La compra se realizó correctamente.",
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        context.goNamed(home);
                                      },
                                      child: Text(
                                        "Aceptar",
                                        style: GoogleFonts.roboto(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'Comprar',
                          style: GoogleFonts.roboto(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
