import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/purchases_repository.dart';
import 'data/repositories/sales_repository.dart';
import 'presentation/auth/cubit/auth_cubit.dart';
import 'presentation/compras/cubit/purchases_cubit.dart';
import 'presentation/login/widgets/login_screen.dart';
import 'presentation/shared/widgets/nav_bar.dart';
import 'presentation/ventas/cubit/sales_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage);
    final authRepository = AuthRepository(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
    );
    final salesRepository = SalesRepository(apiClient);
    final purchasesRepository = PurchasesRepository(apiClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(authRepository)..restoreSession(),
        ),
        BlocProvider(create: (_) => SalesCubit(salesRepository)),
        BlocProvider(create: (_) => PurchasesCubit(purchasesRepository)),
      ],
      child: MaterialApp(
        title: 'SeymSoft',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A5F)),
          useMaterial3: true,
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.initial:
          case AuthStatus.checking:
            return const _SplashScreen();
          case AuthStatus.authenticated:
            return const MainScaffold();
          case AuthStatus.unauthenticated:
          case AuthStatus.loading:
          case AuthStatus.failure:
            return const LoginScreen();
        }
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF1F3F6),
      body: Center(child: CircularProgressIndicator(color: Color(0xFF1E3A5F))),
    );
  }
}
