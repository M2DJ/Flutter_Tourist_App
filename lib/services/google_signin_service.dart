import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  late GoogleSignIn _googleSignIn;

  Future<void> initialize() async {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile', 'openid'],
      serverClientId: '519306226072-dodl7gu1pflnar1d0i633mt2tq2kg8g1.apps.googleusercontent.com',
    );
  }

  GoogleSignIn get googleSignIn => _googleSignIn;
}
