import 'dart:async';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:store/core/utils/enviroments_values.dart';
import 'package:store/domain/repositories/auth_repository.dart';

enum AuthProviderLocal { none, google, facebook }

class AuthRepositoryImpl implements AuthRepository {
  final GoogleSignIn _google = GoogleSignIn.instance;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  AuthProviderLocal _provider = AuthProviderLocal.none;

  final List<String> requiredScopes = [
    'email',
    'profile',
  ];

  final _controller = StreamController<AuthRepositoryStatus>.broadcast();

  AuthRepositoryImpl() {
    _initialize();
  }

  Stream<AuthRepositoryStatus> get status => _controller.stream;

  Future<void> _initialize() async {
    await _google.initialize(clientId: null,
        serverClientId: serverClientId);
    _google.authenticationEvents.listen((event) async {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          _currentUser = event.user;
          break;
        case GoogleSignInAuthenticationEventSignOut():
          _currentUser = null;
          _isAuthorized = false;
          _controller.add(AuthRepositoryStatus.signedOut);
          return;
      }

      if (_currentUser == null) {
        _controller.add(AuthRepositoryStatus.signedOut);
        return;
      }

      final auth = await _currentUser!.authorizationClient
          .authorizationForScopes(requiredScopes);

      if (auth != null) {
        _isAuthorized = true;
        _controller.add(AuthRepositoryStatus.authorized);
      } else {
        _isAuthorized = false;
        _controller.add(AuthRepositoryStatus.needsAuthorization);
      }
    });

    // _google.attemptLightweightAuthentication();
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      if (_google.supportsAuthenticate()) {
        await _google.authenticate();
        _provider = AuthProviderLocal.google;
        return true;
      }
      return false;
    } catch (e) {
      print("Google login error: $e");
      return false;
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return _currentUser != null && _isAuthorized;
  }

  @override
  Future<void> signOut() async {
    switch (_provider) {
      case AuthProviderLocal.google:
        await _google.disconnect();
        break;
      case AuthProviderLocal.facebook:
        await FacebookAuth.instance.logOut();
        break;
      default:
        break;
    }
    _currentUser = null;
    _isAuthorized = false;
    _provider = AuthProviderLocal.none;
    _controller.add(AuthRepositoryStatus.signedOut);
  }

  Future<bool> requestScopes() async {
    if (_currentUser == null) return false;

    try {
      final authorization = await _currentUser!.authorizationClient
          .authorizeScopes(requiredScopes);

      if (authorization != null) {
        _isAuthorized = true;
        _controller.add(AuthRepositoryStatus.authorized);
        return true;
      }
    } catch (e) {
      print("Request scopes error: $e");
      return false;
    }
  }

  @override
  Future<bool> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        _provider = AuthProviderLocal.facebook;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String? get currentUserEmail {
    if (_provider == AuthProviderLocal.google && _currentUser != null) {
      return _currentUser!.email;
    }
    return null;
  }
}

enum AuthRepositoryStatus {
  signedOut,
  signedIn,
  needsAuthorization,
  authorized
}
