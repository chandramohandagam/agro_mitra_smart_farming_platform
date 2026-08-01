import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

enum AuthStatus { authenticated, unauthenticated, authenticating, loading }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.loading;
  UserProfile? _userProfile;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserProfile? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _authService.authStateChanges.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) {
        if (session != null) {
          await _loadUserProfile();
        }
      } else if (event == AuthChangeEvent.signedOut) {
        _status = AuthStatus.unauthenticated;
        _userProfile = null;
        notifyListeners();
      }
    });

    if (_authService.currentUser != null) {
      await _loadUserProfile();
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      _userProfile = await _authService.getUserProfile();
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required UserRole role
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role
      );
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
