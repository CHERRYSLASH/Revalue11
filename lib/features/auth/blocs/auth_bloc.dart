import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final String baseUrl = 'http://10.0.2.2:8000/api/auth';

  AuthBloc() : super(AuthInitial()) {
    

    on<AuthCheckRequested>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');


      await Future.delayed(const Duration(milliseconds: 800));

      if (token != null && token.isNotEmpty) {
        emit(AuthAuthenticated()); // VIP pass found!
      } else {
        emit(AuthUnauthenticated()); // No pass, go to login.
      }
    });


    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': event.email,
            'password': event.password,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['access_token'];
          
          // Save the JWT to the device
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          
          emit(AuthAuthenticated());
        } else {
          final error = jsonDecode(response.body);
          emit(AuthError(error['detail'] ?? 'Login failed'));
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError("Network error. Check server connection."));
        emit(AuthUnauthenticated());
      }
    });


    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/signup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': event.name,
            'email': event.email,
            'password': event.password,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['access_token'];
          

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          
          emit(AuthAuthenticated());
        } else {
          final error = jsonDecode(response.body);
          emit(AuthError(error['detail'] ?? 'Sign up failed'));
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError("Network error. Check server connection."));
        emit(AuthUnauthenticated());
      }
    });


    on<LogoutRequested>((event, emit) async {
      // Delete the JWT from the device
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      
      emit(AuthUnauthenticated());
    });
  }
}