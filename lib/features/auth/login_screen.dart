import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../shared/navigation/main_navigation_shell.dart';
import '../../shared/widgets/app_logo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'demo@siapgenerus.app');
  final _passwordController = TextEditingController(text: 'Generus123!');
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    // Check credentials against PRD demo credentials
    if (email == 'demo@siapgenerus.app' && password == 'Generus123!') {
      DummyDataStore.instance.login();
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Email atau kata sandi tidak cocok dengan akun demo.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: AppColors.badgeRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    // Centered top notch imitation
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.black87),
                      onSelected: (val) {
                        if (val == 'demo') {
                          _emailController.text = 'demo@siapgenerus.app';
                          _passwordController.text = 'Generus123!';
                        } else if (val == 'about') {
                          _showInfoDialog(
                            'Tentang SIAP-GENERUS',
                            'Aplikasi Sistem Informasi Administrasi dan Pembinaan Generus.\nTahap Frontend Dummy Mode.',
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'demo',
                          child: Text('Isi Kredensial Demo'),
                        ),
                        const PopupMenuItem(
                          value: 'about',
                          child: Text('Tentang Aplikasi'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // App Icon (green rounded square with book icon)
                const AppLogo(),
                const SizedBox(height: 20),

                // Title & Subtitle
                const Text(
                  'SIAP-GENERUS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sistem Informasi Administrasi\ndan Pembinaan Generus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 32),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8F6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE8EDE9),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: AppColors.secondaryGreen,
                            size: 22,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E9E5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E9E5),
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!val.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.secondaryGreen,
                            size: 22,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.remove_red_eye_outlined,
                              color: AppColors.secondaryText,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E9E5),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE4E9E5),
                            ),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            _showInfoDialog(
                              'Lupa Password',
                              'Simulasi reset password demo.\nSilakan hubungi administrator atau gunakan kredensial demo default.',
                            );
                          },
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: AppColors.secondaryGreen,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Divider 'atau'
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'atau',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Login dengan Google Button
                InkWell(
                  onTap: () {
                    _showInfoDialog(
                      'Login Google',
                      'Simulasi OAuth Google: Kredensial demo aktif secara lokal.',
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAF9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E9E5)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login_rounded,
                          color: AppColors.secondaryGreen,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Login dengan Google',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showInfoDialog(
                          'Daftar Akun',
                          'Pendaftaran akun baru disimulasikan secara lokal.\nSilakan gunakan kredensial demo untuk masuk.',
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          color: AppColors.secondaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
