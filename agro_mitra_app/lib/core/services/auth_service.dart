import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({required String email, required String password, required String fullName, required UserRole role}) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': role.name,
      },
    );
    return response;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserProfile?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return UserProfile.fromJson(response);
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _supabase.from('profiles').upsert(profile.toJson());
  }
}
