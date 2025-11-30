import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:store/config/app_router.dart';
import 'package:store/core/di/injection_container.dart' as di;

import 'presentation/cubit/auth/auth_cubit.dart';
import 'presentation/cubit/login_form/login_form_cubit.dart';
import 'presentation/cubit/product/product_cubit.dart';
import 'presentation/cubit/product_detail/product_detail_cubit.dart';
import 'presentation/pages/login/controller/login_controller.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  await dotenv.load(fileName: ".env");
  Get.put(LoginController());
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<ProductCubit>()),
        BlocProvider(create: (_) => di.sl<ProductDetailCubit>()),
        BlocProvider(create: (_) => di.sl<LoginFormCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Test Mobile App',
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
