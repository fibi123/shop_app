import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../injection_container.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/products/products_bloc.dart';
import '../presentation/bloc/posts/posts_bloc.dart';
import '../presentation/bloc/theme/theme_cubit.dart';
import '../core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
        ),
        BlocProvider<ProductsBloc>(
          create: (_) => sl<ProductsBloc>(),
        ),
        BlocProvider<PostsBloc>(
          create: (_) => sl<PostsBloc>(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => sl<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Taghyeer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppPages.generateRoute,
          );
        },
      ),
    );
  }
}
