import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/common/app_text_field.dart';
import '../../../shared/widgets/common/primary_button.dart';
import '../data/auth_model.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              const _AuthLogo(),
              const SizedBox(height: AppSpacing.xl),
              _TabSelector(controller: _tabController),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 440,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _LoginForm(tabController: _tabController),
                    _RegisterForm(tabController: _tabController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthLogo extends StatelessWidget {
  const _AuthLogo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(80),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '₿',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'CandleCore',
          style: TextStyle(
            fontSize: AppTypography.text2xl,
            fontWeight: AppTypography.fontWeightBold,
            letterSpacing: AppTypography.letterSpacingTight,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          'Your crypto intelligence hub',
          style: TextStyle(
            fontSize: AppTypography.textSm,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _TabSelector extends StatelessWidget {
  final TabController controller;

  const _TabSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: AppTypography.textSm,
          fontWeight: AppTypography.fontWeightSemiBold,
        ),
        tabs: const [
          Tab(text: 'Sign In'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  final TabController tabController;

  const _LoginForm({required this.tabController});

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(LoginRequest(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ));
      ref.read(currentUserProvider.notifier).setUser(user);
      if (mounted) context.go(AppRoutes.dashboard);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Enter your username',
            prefixIcon: Icons.person_outline,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Username is required' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) =>
                v == null || v.isEmpty ? 'Password is required' : null,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: AppTypography.textSm,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Sign In',
            isLoading: _isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => widget.tabController.animateTo(1),
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppTypography.textSm,
                ),
                children: [
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: AppTypography.fontWeightSemiBold,
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
}

class _RegisterForm extends ConsumerStatefulWidget {
  final TabController tabController;

  const _RegisterForm({required this.tabController});

  @override
  ConsumerState<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.register(RegisterRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
      ref.read(currentUserProvider.notifier).setUser(user);
      if (mounted) context.go(AppRoutes.dashboard);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _usernameController,
            label: 'Username',
            hint: 'Choose a username',
            prefixIcon: Icons.person_outline,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Username is required' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Create a password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'At least 6 characters required';
              return null;
            },
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: AppTypography.textSm,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Create Account',
            isLoading: _isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: () => widget.tabController.animateTo(0),
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppTypography.textSm,
                ),
                children: [
                  TextSpan(
                    text: 'Sign In',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: AppTypography.fontWeightSemiBold,
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
}
