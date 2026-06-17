import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/blocs/auth_bloc.dart';
import '../../auth/blocs/auth_event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text('Chereub Rajesh', style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 40),
            
            // The Logout Button
            SizedBox(
              width: 200,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  // Fire the event to delete the JWT and reset the state
                  context.read<AuthBloc>().add(LogoutRequested());
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('LOG OUT', style: TextStyle(color: Colors.redAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}