import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileDetailsFormScreen extends StatefulWidget {
  const ProfileDetailsFormScreen({super.key});

  static const routeName = '/profile-details';

  @override
  State<ProfileDetailsFormScreen> createState() =>
      _ProfileDetailsFormScreenState();
}

class _ProfileDetailsFormScreenState extends State<ProfileDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _saving = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _attemptedSubmit = false;

  static final _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  static final _phoneRegex = RegExp(r'^\d{10}$');

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(_recompute);
    _emailController.addListener(_recompute);
    _phoneController.addListener(_recompute);
    _passwordController.addListener(_recompute);
    _confirmPasswordController.addListener(_recompute);
  }

  void _recompute() {
    if (!mounted) return;
    setState(() {
      // Rebuild to update "Save" button enabled state.
    });
  }

  bool get _isFormLikelyValid {
    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final pw = _passwordController.text;
    final cpw = _confirmPasswordController.text;

    return name.length >= 3 &&
        _emailRegex.hasMatch(email) &&
        _phoneRegex.hasMatch(phone) &&
        pw.length >= 8 &&
        cpw == pw;
  }

  String? _validateFullName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Full name must be at least 3 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePhone(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(v)) return 'Enter a valid 10-digit phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Confirm password is required';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    setState(() => _attemptedSubmit = true);

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save profile details.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      // Save profile fields to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          'name': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // Update Firebase Auth password
      final newPassword = _passwordController.text;
      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully.')),
      );
      Navigator.of(context).maybePop();
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to save profile.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = !_saving && _isFormLikelyValid;
    final autovalidateMode = _attemptedSubmit
        ? AutovalidateMode.always
        : AutovalidateMode.onUserInteraction;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details Form'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter your details to save your profile.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g. Alex Johnson',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateFullName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g. alex@email.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                     LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '10 digits',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePhone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Minimum 8 characters',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip:
                          _obscurePassword ? 'Show password' : 'Hide password',
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      tooltip: _obscureConfirmPassword
                          ? 'Show confirm password'
                          : 'Hide confirm password',
                      onPressed: () => setState(
                        () => _obscureConfirmPassword =
                            !_obscureConfirmPassword,
                      ),
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) {
                    if (canSubmit) _submit();
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: canSubmit ? _submit : null,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_saving ? 'Saving...' : 'Save Profile'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  canSubmit
                      ? 'All fields look valid. You can submit.'
                      : 'Fix validation errors to enable Save.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: canSubmit
                        ? Colors.green.shade700
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

