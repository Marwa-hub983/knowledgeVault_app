import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:knowledge_vault_app/shared/constants/assets/assets.dart';
import 'package:knowledge_vault_app/shared/constants/colors.dart';
import 'package:knowledge_vault_app/shared/constants/font_palette.dart';
import 'package:knowledge_vault_app/shared/routes/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreateAccount() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty) {
      _showErrorSnackBar('Please enter your full name');
      return;
    }

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }

    if (password.length < 8) {
      _showErrorSnackBar('Password must be at least 8 characters');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    if (!_agreedToTerms) {
      _showErrorSnackBar("Please agree to Vault's Terms & Privacy Guarantee");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating vault account for $fullName...'),
        backgroundColor: const Color(0xFF0F766E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    context.go(home);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onGoogleSignUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Connecting to Google Sign-Up...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.25, 0.7, 1.0],
            colors: [
              Color(0xFFE8EEFD),
              Color(0xFFF1F4FD),
              Color(0xFFF8FAFC),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 390),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Create your Vault',
                      textAlign: TextAlign.center,
                      style: FontPalette.hW800S22.copyWith(
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Subtitle
                    Text(
                      'Start chatting with your personal\ndocuments with zero data leaks',
                      textAlign: TextAlign.center,
                      style: FontPalette.hW400S12.copyWith(
                        fontSize: 12.5,
                        color: const Color(0xFF64748B),
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ZERO-KNOWLEDGE ARCHITECTURE pill badge
                    _buildZeroKnowledgeArchitectureBadge(),

                    const SizedBox(height: 12),

                    // Main Register White Card
                    _buildRegisterCard(),

                    const SizedBox(height: 10),

                    // Already have an account? Log in
                    _buildLoginPrompt(),

                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// "ZERO-KNOWLEDGE ARCHITECTURE" pill badge
  Widget _buildZeroKnowledgeArchitectureBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2EFE9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_rounded,
              size: 11,
              color: Color(0xFF0F766E),
            ),
            const SizedBox(width: 5),
            Text(
              'ZERO-KNOWLEDGE ARCHITECTURE',
              style: FontPalette.hW800S10.copyWith(
                fontSize: 9.5,
                color: const Color(0xFF0F766E),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Main White Card containing input fields, checkboxes, buttons, and divider
  Widget _buildRegisterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 18,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full Name Label
            Text(
              'Full Name',
              style: FontPalette.hW600S12.copyWith(
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 4),

            // Full Name Input Field
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                style: FontPalette.hW500S13.copyWith(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 8),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 38,
                  ),
                  hintText: 'Elena Vance',
                  hintStyle: FontPalette.hW400S13.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // Email address Label
            Text(
              'Email address',
              style: FontPalette.hW600S12.copyWith(
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 4),

            // Email Input Field
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: FontPalette.hW500S13.copyWith(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 8),
                    child: Icon(
                      Icons.mail_outline_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 38,
                  ),
                  hintText: 'name@example.com',
                  hintStyle: FontPalette.hW400S13.copyWith(
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // Password Label
            Text(
              'Password',
              style: FontPalette.hW600S12.copyWith(
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 4),

            // Password Input Field
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                obscuringCharacter: '•',
                textInputAction: TextInputAction.next,
                style: FontPalette.hW500S13.copyWith(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                  letterSpacing: _isPasswordVisible ? 0 : 2,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 8),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 38,
                  ),
                  hintText: '••••••••',
                  hintStyle: FontPalette.hW400S14.copyWith(
                    color: const Color(0xFF64748B),
                    letterSpacing: 2,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF64748B),
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      splashRadius: 16,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 38,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // "Must be at least 8 characters" info line
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 12.5,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Must be at least 8 characters',
                    style: FontPalette.hW500S11.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 9),

            // Confirm Password Label
            Text(
              'Confirm Password',
              style: FontPalette.hW600S12.copyWith(
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 4),

            // Confirm Password Input Field (lock with clock/timer badge icon)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                obscuringCharacter: '•',
                textInputAction: TextInputAction.done,
                style: FontPalette.hW500S13.copyWith(
                  fontSize: 13.5,
                  color: const Color(0xFF0F172A),
                  letterSpacing: _isConfirmPasswordVisible ? 0 : 2,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 8),
                    child: Icon(
                      Icons.lock_clock_outlined,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 38,
                  ),
                  hintText: '••••••••',
                  hintStyle: FontPalette.hW400S14.copyWith(
                    color: const Color(0xFF64748B),
                    letterSpacing: 2,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF64748B),
                        size: 18,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      splashRadius: 16,
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 38,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Terms & Privacy Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1.5),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreedToTerms = !_agreedToTerms;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 17,
                      height: 17,
                      decoration: BoxDecoration(
                        color: _agreedToTerms
                            ? const Color(0xFF00BFA5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4.5),
                        border: Border.all(
                          color: _agreedToTerms
                              ? const Color(0xFF00BFA5)
                              : const Color(0xFF94A3B8),
                          width: 1.5,
                        ),
                      ),
                      child: _agreedToTerms
                          ? const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "By signing up, you agree to Vault's ",
                      style: FontPalette.hW400S12.copyWith(
                        fontSize: 11.5,
                        color: const Color(0xFF475569),
                        height: 1.25,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms',
                          style: FontPalette.hW700S12.copyWith(
                            fontSize: 11.5,
                            color: const Color(0xFF4338CA),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Viewing Vault's Terms of Service..."),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'AES-256 Privacy Guarantee',
                          style: FontPalette.hW700S12.copyWith(
                            fontSize: 11.5,
                            color: const Color(0xFF4338CA),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Viewing AES-256 Privacy Guarantee...'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Create Account Button
            Container(
              width: double.infinity,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x304F46E5),
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _onCreateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: FontPalette.hW700S14.copyWith(
                          fontSize: 14.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // OR Divider
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Color(0xFFE2E8F0),
                    thickness: 0.8,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'OR',
                    style: FontPalette.hW600S10.copyWith(
                      color: const Color(0xFF94A3B8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Color(0xFFE2E8F0),
                    thickness: 0.8,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Continue with Google Button
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _onGoogleSignUp,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              googleIcon,
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Continue with Google',
                              style: FontPalette.hW600S14.copyWith(
                                fontSize: 13.5,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// "Already have an account? Log in" footer
  Widget _buildLoginPrompt() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: FontPalette.hW500S13.copyWith(
              color: const Color(0xFF475569),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.push(login);
              }
            },
            child: Text(
              'Log in',
              style: FontPalette.hW700S13.copyWith(
                color: const Color(0xFF4338CA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
