abstract class AuthEvent {}

// Triggered automatically when the app starts
class AuthCheckRequested extends AuthEvent {}

// Triggered when the user taps "LOG IN"
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

// Triggered when the user taps "SIGN UP"
class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignUpRequested(this.name, this.email, this.password);
}

// Triggered when the user taps a logout button
class LogoutRequested extends AuthEvent {}