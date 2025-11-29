import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store/core/utils/contants.dart';
import 'package:store/presentation/cubit/auth/auth_cubit.dart';
import 'package:store/presentation/cubit/product/product_cubit.dart';
import 'package:store/presentation/pages/home/widgets/app_drawer.dart';

import 'widgets/product_item.dart';
import 'widgets/product_shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductCubit>();
    cubit.fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        cubit.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.idle) {
          // Cuando se cierra sesión, redirige al login
          context.goNamed(login);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Productos')),
        drawer: const AppDrawer(),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.status == ProductStatus.loading && state.status != ProductStatus.loadingMore) {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: 6,
                itemBuilder: (_, __) => const ProductShimmer(),
              );
            }

            List products = [];
            bool isLoadingMore = false;

            if (state.status == ProductStatus.success) {
              products = state.products;
            } else if (state.status == ProductStatus.loadingMore) {
              products = state.products;
              isLoadingMore = true;
            } else if (state.status == ProductStatus.error) {
              return Center(child: Text(state.message ?? ""));
            }

            return SafeArea(child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length + (isLoadingMore ? 2 : 0),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  return ProductItem(product: products[index]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ));
          },
        ),
      ),
    );
  }
}
