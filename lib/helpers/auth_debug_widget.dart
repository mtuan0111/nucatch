import 'package:flutter/material.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/services/auth_services.dart';

/// Debug widget to verify Firebase Anonymous Authentication
///
/// Usage: Add this widget to any screen to see authentication status
/// Example:
/// ```dart
/// Column(
///   children: [
///     // Your existing widgets
///     if (kDebugMode) AuthDebugWidget(),
///   ],
/// )
/// ```
class AuthDebugWidget extends StatefulWidget {
  const AuthDebugWidget({super.key});

  @override
  State<AuthDebugWidget> createState() => _AuthDebugWidgetState();
}

class _AuthDebugWidgetState extends State<AuthDebugWidget> {
  final AuthServices _authServices = AuthServices();
  String _status = 'Checking...';
  String? _userId;
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = _authServices.currentUser;
    setState(() {
      if (user != null) {
        _status = 'Authenticated';
        _userId = user.uid;
        _isAnonymous = user.isAnonymous;
      } else {
        _status = 'Not Authenticated';
        _userId = null;
        _isAnonymous = false;
      }
    });
  }

  Future<void> _signInAnonymously() async {
    final result = await _authServices.signInAnonymously();
    if (result != null) {
      await _checkAuthStatus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in successfully!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in')),
        );
      }
    }
  }

  Future<void> _signOut() async {
    await _authServices.signOut();
    await _checkAuthStatus();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🔐 Auth Debug',
            style: LayoutConfig(context).boldSubtitleStyle(),
          ),
          const SizedBox(height: 8),
          Text('Status: $_status'),
          if (_userId != null) ...[
            const SizedBox(height: 4),
            Text(
              'User ID: ${_userId!.substring(0, 8)}...',
              style: LayoutConfig(context).captionStyle(),
            ),
            const SizedBox(height: 4),
            Text('Anonymous: $_isAnonymous'),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _checkAuthStatus,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text('Refresh',
                    style: LayoutConfig(context).captionStyle()),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _userId == null ? _signInAnonymously : null,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text('Sign In',
                    style: LayoutConfig(context).captionStyle()),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _userId != null ? _signOut : null,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text('Sign Out',
                    style: LayoutConfig(context).captionStyle()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
