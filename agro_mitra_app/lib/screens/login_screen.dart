import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../core/models/user_model.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  UserRole _selectedRole = UserRole.farmer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final authProvider = context.read<AuthProvider>();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    bool success;
    if (_isLogin) {
      success = await authProvider.login(email, password);
    } else {
      success = await authProvider.register(
        email: email,
        password: password,
        fullName: name,
        role: _selectedRole
      );
    }

    if (success && mounted) {
      if (authProvider.userProfile != null) {
        _navigateBasedOnRole(authProvider.userProfile!.role);
      }
    }
  }

  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.farmer:
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case UserRole.dealer:
        Navigator.pushReplacementNamed(context, '/dealer_dashboard');
        break;
      case UserRole.company:
        Navigator.pushReplacementNamed(context, '/company_dashboard');
        break;
      case UserRole.admin:
        Navigator.pushReplacementNamed(context, '/admin_dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(top: -100, right: -100, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.1)))),
          Positioned(bottom: -50, left: -50, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary.withValues(alpha: 0.1)))),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.eco, color: AppColors.primary, size: 32)),
                  const SizedBox(height: 24),
                  Text(_isLogin ? 'Welcome Back' : 'Join Agro Mitra', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text(_isLogin ? 'Login to manage your modern farm.' : 'Create an account to start your journey.', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
                  const SizedBox(height: 40),

                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (!_isLogin) ...[
                          _buildTextField('Full Name', _nameController, Icons.person_outline),
                          const SizedBox(height: 16),
                          _buildRoleSelector(),
                          const SizedBox(height: 16),
                        ],
                        _buildTextField('Email Address', _emailController, Icons.email_outlined),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 24),

                        if (authProvider.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(authProvider.errorMessage!, style: const TextStyle(color: AppColors.error, fontSize: 12)),
                          ),

                        ElevatedButton(
                          onPressed: authProvider.status == AuthStatus.authenticating ? null : _handleAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: authProvider.status == AuthStatus.authenticating
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_isLogin ? 'Sign In' : 'Create Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: RichText(
                        text: TextSpan(
                          text: _isLogin ? "Don't have an account? " : "Already have an account? ",
                          style: const TextStyle(color: AppColors.onSurfaceVariant),
                          children: [
                            TextSpan(text: _isLogin ? 'Sign Up' : 'Sign In', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('I am a...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: UserRole.values.where((r) => r != UserRole.admin).map((role) {
            final isSelected = _selectedRole == role;
            return GestureDetector(
              onTap: () => setState(() => _selectedRole = role),
              child: Container(
                width: 90,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    role.name.toUpperCase(),
                    style: TextStyle(color: isSelected ? Colors.white : AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
