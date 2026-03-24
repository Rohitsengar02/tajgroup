import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../main_screen_router.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _mapRole(String role) {
    if (role.contains("Admin")) return "Admin";
    if (role.contains("Super Stockist")) return "Super Stockist";
    if (role.contains("Distributor")) return "Distributor";
    if (role.contains("Sales Person")) return "Sales Person";
    if (role.contains("Retailer")) return "Retailer";
    return role;
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String role = _mapRole(widget.role);

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Success
        if (mounted) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          await userProvider.login(data);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScreenLoader()),
            (route) => false,
          );
        }
      } else {
        // Error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Login failed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Side: Branding & Visuals
        Expanded(
          flex: 4,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF000000), Color(0xFF2D3436)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 60),
                    const Icon(Icons.lock_person_rounded, size: 80, color: Colors.white),
                    const SizedBox(height: 48),
                    Text(
                      "Access your\n${widget.role}",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Authenticate your account with TajNova to manage your enterprise data securely.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Right Side: Login Form
        Expanded(
          flex: 6,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SECURE AUTHENTICATION",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: textPrimaryColor,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 48),
                
                // Email Input
                const Text("EMAIL ADDRESS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textSecondaryColor, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                _buildInputField(Icons.alternate_email_rounded, "Enter your email", false, _emailController),
                
                const SizedBox(height: 24),
                
                // Password Input
                const Text("PASSWORD", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textSecondaryColor, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                _buildInputField(Icons.lock_outline_rounded, "Enter your password", true, _passwordController),
                
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("SIGN IN TO PANEL", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                  ),
                ),
                
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[100])),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("TRUSTED ACCESS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondaryColor))),
                    Expanded(child: Divider(color: Colors.grey[100])),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: _buildSocialButton(Icons.fingerprint_rounded, "Biometric")),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSocialButton(Icons.qr_code_scanner_rounded, "QR Code")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.role, style: const TextStyle(color: textPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome Back", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -1.5)),
            const SizedBox(height: 8),
            const Text("Please enter your credentials to access the secure enterprise portal.", style: TextStyle(fontSize: 14, color: textSecondaryColor, height: 1.5)),
            const SizedBox(height: 48),
            _buildInputField(Icons.alternate_email_rounded, "Email address", false, _emailController),
            const SizedBox(height: 24),
            _buildInputField(Icons.lock_outline_rounded, "Password", true, _passwordController),
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text("Forgot Password?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity, 
              height: 55, 
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), 
                child: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("SIGN IN", style: TextStyle(fontWeight: FontWeight.w800))
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(IconData icon, String hint, bool isPassword, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        obscureText: isPassword && _isObscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          suffixIcon: isPassword ? IconButton(icon: Icon(_isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[400], size: 20), onPressed: () => setState(() => _isObscure = !_isObscure)) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
