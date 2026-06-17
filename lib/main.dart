import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/blocs/auth_bloc.dart';
import 'features/auth/blocs/auth_state.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/products/blocs/product_bloc.dart';
import 'features/products/blocs/product_event.dart'; // If you want to load on startup
import 'features/cart/blocs/cart_bloc.dart';
import 'features/products/blocs/feed_bloc.dart';
import 'features/products/data/product_data_source.dart';
import 'features/products/domain/product_repository.dart';

import 'features/products/presentation/navbar.dart';
import 'features/products/blocs/feed_event.dart';
import 'features/auth/blocs/auth_event.dart';

void main() {
  final remoteDataSource = ProductRemoteDataSource();
  final repository = ProductRepository(remoteDataSource: remoteDataSource);
  
  runApp(MyApp(repository: repository)); 
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(repository: repository)..add(LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<FeedBloc>(
          create: (context) => FeedBloc()..add(LoadFeedPosts()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Revalue',
        debugShowCheckedModeBanner: false, // Hides the annoying "DEBUG" banner
        
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A0A0A), // True-black background
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A0A0A),
            elevation: 0,
            centerTitle: true,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            secondary: Colors.grey,
          ),
        ),
        
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // 1. If authenticated, show the app
            if (state is AuthAuthenticated) {
              return const MainNavigationShell();
            }
            
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator(color: Colors.white)),
              );
            }
            
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}