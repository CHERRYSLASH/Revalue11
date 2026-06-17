import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/blocs/auth_bloc.dart';
import 'features/auth/blocs/auth_state.dart';
import 'features/auth/presentation/login_screen.dart';
// 1. Import your BLoCs
import 'features/products/blocs/product_bloc.dart';
import 'features/products/blocs/product_event.dart'; // If you want to load on startup
import 'features/cart/blocs/cart_bloc.dart';
import 'features/products/blocs/feed_bloc.dart';
import 'features/products/data/product_data_source.dart';
import 'features/products/domain/product_repository.dart';
// 2. Import your Custom Navigation Shell
import 'features/products/presentation/navbar.dart';
import 'features/products/blocs/feed_event.dart';
import 'features/auth/blocs/auth_event.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(
            repository: ProductRepository(
              remoteDataSource: ProductRemoteDataSource(), 
            ), 
          )..add(LoadProducts()),
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
      // 4. The main App configuration
      child: MaterialApp(
        title: 'Revalue',
        debugShowCheckedModeBanner: false, // Hides the annoying "DEBUG" banner
        
        // 5. Global Dark Theme Configuration
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
        
        // 6. Point the app entry to your custom shell
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // 1. If authenticated, show the app
            if (state is AuthAuthenticated) {
              return const MainNavigationShell();
            }
            
            // 2. If loading or initial, show a splash/loading spinner
            if (state is AuthLoading || state is AuthInitial) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator(color: Colors.white)),
              );
            }
            
            // 3. Otherwise (Unauthenticated or Error), show the Login screen
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}