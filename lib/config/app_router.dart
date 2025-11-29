import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store/core/di/injection_container.dart';
import 'package:store/core/utils/contants.dart';
import 'package:store/domain/usecases/get_product_details_usecase.dart';
import 'package:store/presentation/cubit/product_detail/product_detail_cubit.dart';
import 'package:store/presentation/pages/home/home_page.dart';
import 'package:store/presentation/pages/login/login_page.dart';
import 'package:store/presentation/pages/product_detail/product_detail_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/product/:id',
        name: detail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => ProductDetailCubit(
              getProductDetailsUseCase: sl<GetProductDetailsUseCase>(),
            )..loadProductDetail(id),
            child: ProductDetailPage(productId: id),
          );
        },
      ),
    ],
  );
}
