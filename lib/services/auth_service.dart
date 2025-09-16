import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_governate_app/models/user_model.dart';
import 'package:my_governate_app/services/google_signin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn? _googleSignIn;

  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';

  GoogleSignIn get googleSignIn {
    _googleSignIn ??= GoogleSignIn();
    return _googleSignIn!;
  }

  User? get currentUser => _auth.currentUser;

  Future<void> _saveLoginState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userIdKey, userId);
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedInPref = prefs.getBool(_isLoggedInKey) ?? false;
      
      final currentFirebaseUser = _auth.currentUser;
      
      if (currentFirebaseUser != null && !isLoggedInPref) {
        await _saveLoginState(currentFirebaseUser.uid);
        return true;
      }
      
      if (isLoggedInPref && currentFirebaseUser == null) {
        await _clearLoginState();
        return false;
      }
      
      return isLoggedInPref && currentFirebaseUser != null;
    } catch (e) {
      print('Error checking login state: $e');
      return false;
    }
  }

  Future<String?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_userIdKey);
  }

  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? city,
    String? phone,
  }) async {
    try {
      final String cleanEmail = email.trim().toLowerCase();
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(cleanEmail)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'البريد الإلكتروني غير صالح',
        );
      }

      if (password.length < 6) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        );
      }

      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        final UserModel userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          name: name ?? '',
          city: city ?? '',
          phone: phone,
          profileImage: user.photoURL,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

        await _saveLoginState(user.uid);

        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      print('Sign up error: ${e.toString()}');
      switch (e.code) {
        case 'email-already-in-use':
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'هذا البريد الإلكتروني مستخدم بالفعل',
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'البريد الإلكتروني غير صالح',
          );
        case 'operation-not-allowed':
          throw FirebaseAuthException(
            code: 'operation-not-allowed',
            message: 'تسجيل الحساب غير مفعل حالياً',
          );
        case 'weak-password':
          throw FirebaseAuthException(
            code: 'weak-password',
            message: 'كلمة المرور ضعيفة جداً',
          );
        default:
          throw FirebaseAuthException(
            code: 'error',
            message: 'حدث خطأ في إنشاء الحساب',
          );
      }
    } catch (e) {
      print('Unexpected error during sign up: ${e.toString()}');
      throw FirebaseAuthException(
        code: 'error',
        message: 'حدث خطأ غير متوقع',
      );
    }
    return null;
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final String cleanEmail = email.trim().toLowerCase();

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(cleanEmail)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'البريد الإلكتروني غير صالح',
        );
      }

      if (password.isEmpty) {
        throw FirebaseAuthException(
          code: 'invalid-credential',
          message: 'كلمة المرور مطلوبة',
        );
      }

      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        try {
          final DocumentSnapshot doc =
              await _firestore.collection('users').doc(user.uid).get();

          if (doc.exists && doc.data() != null) {
            final data = doc.data();
            if (data is Map<String, dynamic>) {
              await _saveLoginState(user.uid);
              return UserModel.fromMap(data);
            } else {
              print('Document data is not a Map: ${data.runtimeType}');
              final UserModel userModel = UserModel(
                uid: user.uid,
                email: user.email!,
                profileImage: user.photoURL,
              );
              await _firestore
                  .collection('users')
                  .doc(user.uid)
                  .set(userModel.toMap());

              return userModel;
            }
          } else {
            final UserModel userModel = UserModel(
              uid: user.uid,
              email: user.email!,
              profileImage: user.photoURL,
            );

            await _firestore
                .collection('users')
                .doc(user.uid)
                .set(userModel.toMap());

            await _saveLoginState(user.uid);
            return userModel;
          }
        } catch (docError) {
          print('Error fetching user document: $docError');
          // Still return a basic user model if document fetch fails
          final userModel = UserModel(
            uid: user.uid,
            email: user.email!,
            profileImage: user.photoURL,
          );

          await _saveLoginState(user.uid);
          return userModel;
        }
      }
    } catch (e) {
      print('Sign in error: ${e.toString()}');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            throw FirebaseAuthException(
              code: 'user-not-found',
              message: 'لم يتم العثور على حساب بهذا البريد الإلكتروني',
            );
          case 'wrong-password':
            throw FirebaseAuthException(
              code: 'invalid-credential',
              message: 'كلمة المرور غير صحيحة',
            );
          case 'invalid-credential':
            throw FirebaseAuthException(
              code: 'invalid-credential',
              message: 'بيانات تسجيل الدخول غير صحيحة',
            );
          case 'user-disabled':
            throw FirebaseAuthException(
              code: 'user-disabled',
              message: 'تم تعطيل هذا الحساب',
            );
          default:
            throw FirebaseAuthException(
              code: 'auth-error',
              message: 'حدث خطأ في تسجيل الدخول',
            );
        }
      }
      rethrow;
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _clearLoginState();
      
      // Try to sign out from Google, but don't fail if it's not initialized
      try {
        if (_googleSignIn != null) {
          await _googleSignIn!.signOut();
        }
      } catch (googleError) {
        print('Google sign out error (ignoring): $googleError');
        // Continue with Firebase sign out even if Google sign out fails
      }
      
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // تسجيل الدخول بـ Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      print('=== STARTING GOOGLE SIGN-IN ===');
      
      // Get GoogleSignIn instance
      final googleSignIn = GoogleSignInService().googleSignIn;
      print('GoogleSignIn service obtained');
      
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      print('Google user result: ${googleUser?.email ?? 'null'}');
      
      if (googleUser == null) {
        print('User cancelled Google Sign-In');
        return null;
      }

      print('Getting Google authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('Access token: ${googleAuth.accessToken != null ? 'Present' : 'Missing'}');
      print('ID token: ${googleAuth.idToken != null ? 'Present' : 'Missing'}');
      
      if (googleAuth.accessToken == null) {
        print('Access token is null - retrying authentication');
        throw Exception('فشل في الحصول على access token من Google');
      }
      
      if (googleAuth.idToken == null) {
        print('ID token is null - this may be a configuration issue');
        print('Attempting to proceed with access token only...');
        
        // Try alternative approach - get user info directly
        try {
          final GoogleSignInAccount? currentUser = await googleSignIn.signInSilently();
          if (currentUser != null) {
            final newAuth = await currentUser.authentication;
            if (newAuth.idToken != null) {
              print('Retrieved ID token on retry');
              final credential = GoogleAuthProvider.credential(
                accessToken: newAuth.accessToken,
                idToken: newAuth.idToken,
              );
              
              final UserCredential result = await _auth.signInWithCredential(credential);
              final User? user = result.user;
              
              if (user != null) {
                print('Firebase user created via retry: ${user.email}');
                
                final userModel = UserModel(
                  uid: user.uid,
                  email: user.email!,
                  name: user.displayName ?? '',
                  profileImage: user.photoURL,
                );
                
                final doc = await _firestore.collection('users').doc(user.uid).get();
                if (!doc.exists) {
                  await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
                }
                await _saveLoginState(user.uid);
                print('=== GOOGLE SIGN-IN SUCCESS VIA RETRY ===');
                return userModel;
              }
            }
          }
        } catch (retryError) {
          print('Retry failed: $retryError');
        }
        
        throw Exception('فشل في الحصول على ID token من Google');
      }
      
      print('Tokens obtained successfully');

      print('Creating Firebase credential...');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('Signing in with Firebase...');
      final UserCredential result = await _auth.signInWithCredential(credential);
      final User? user = result.user;
      
      if (user == null) {
        throw Exception('فشل في إنشاء مستخدم Firebase');
      }
      
      print('Firebase user created: ${user.email}');

      print('Checking Firestore for user data...');
      final DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      
      UserModel userModel;
      if (doc.exists && doc.data() != null) {
        print('User exists in Firestore');
        final data = doc.data() as Map<String, dynamic>;
        userModel = UserModel.fromMap(data);
      } else {
        print('Creating new user in Firestore');
        userModel = UserModel(
          uid: user.uid,
          email: user.email!,
          name: user.displayName ?? '',
          profileImage: user.photoURL,
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
        print('User saved to Firestore');
      }

      print('Saving login state...');
      await _saveLoginState(user.uid);
      print('=== GOOGLE SIGN-IN SUCCESS ===');
      return userModel;
    } catch (e) {
      print('=== GOOGLE SIGN-IN ERROR CAUGHT ===');
      print('Error message: ${e.toString()}');
      print('Error type: ${e.runtimeType}');
      
      // Always check if user is actually signed in to Firebase after any error
      print('Checking Firebase auth state after error...');
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        print('User is actually signed in to Firebase: ${currentUser.email}');
        print('This was a false error - proceeding with success flow');
        
        // Create user model and return success
        final userModel = UserModel(
          uid: currentUser.uid,
          email: currentUser.email!,
          name: currentUser.displayName ?? '',
          profileImage: currentUser.photoURL,
        );
        
        // Save to Firestore if not exists
        try {
          final doc = await _firestore.collection('users').doc(currentUser.uid).get();
          if (!doc.exists) {
            await _firestore.collection('users').doc(currentUser.uid).set(userModel.toMap());
            print('User saved to Firestore');
          } else {
            print('User already exists in Firestore');
          }
          await _saveLoginState(currentUser.uid);
          print('=== RECOVERED FROM FALSE ERROR - SUCCESS ===');
          return userModel;
        } catch (firestoreError) {
          print('Firestore error during recovery: $firestoreError');
          // Even if Firestore fails, we can still proceed with login
          await _saveLoginState(currentUser.uid);
          return userModel;
        }
      }
      
      // Handle specific errors
      if (e.toString().contains('channel-error')) {
        await Future.delayed(const Duration(milliseconds: 500));
        throw Exception('مشكلة في الاتصال مع Google. يرجى المحاولة مرة أخرى.');
      } else if (e.toString().contains('network')) {
        throw Exception('مشكلة في الشبكة. يرجى التحقق من الاتصال بالإنترنت.');
      } else if (e.toString().contains('cancelled') || e.toString().contains('aborted')) {
        return null; // User cancelled
      } else if (e.toString().contains('account_exists_with_different_credential')) {
        throw Exception('الحساب موجود بطريقة مختلفة. استخدم الإيميل وكلمة المرور.');
      }
      
      // Log the full error for debugging
      print('=== GOOGLE SIGN-IN DEBUG INFO ===');
      print('Full Google Sign-In error: ${e.toString()}');
      print('Error type: ${e.runtimeType}');
      
      // More specific error handling
      if (e is FirebaseAuthException) {
        print('Firebase Auth Error Code: ${e.code}');
        print('Firebase Auth Error Message: ${e.message}');
        if (e.code == 'account-exists-with-different-credential') {
          throw Exception('Account exists with different credential. Try email/password login.');
        } else if (e.code == 'invalid-credential') {
          throw Exception('Invalid Google credentials. Please try again.');
        }
      }
      
      print('=== END DEBUG INFO ===');
      
      // Always show a generic message to user but log details
      throw Exception('تعذر تسجيل الدخول بـ Google. يرجى المحاولة مرة أخرى أو استخدام الإيميل وكلمة المرور.');
    }
  }


  Future<void> updateUserData({
    String? name,
    String? city,
    String? profileImage,
    String? bio,
    String? phone,
    Uint8List? imageBytes,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('لم يتم تسجيل الدخول');

      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (city != null) updates['city'] = city;
      if (profileImage != null) updates['profileImage'] = profileImage;
      if (bio != null) updates['bio'] = bio;
      if (phone != null) updates['phone'] = phone;

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(user.uid).update(updates);
      }
    } catch (e) {
      print('Error updating user data: $e');
      throw e;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    String? name,
    String? profileImage,
    String? bio,
    String? phone,
  }) async {
    try {
      final String uid = currentUser?.uid ?? '';
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      if (bio != null) updateData['bio'] = bio;
      if (phone != null) updateData['phone'] = phone;

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = currentUser;
      final userId = user?.uid;

      if (userId == null) {
        return null;
      }

      // Always try to get fresh data from Firebase
      try {
        final DocumentSnapshot doc =
            await _firestore.collection('users').doc(userId).get();

        if (doc.exists && doc.data() != null) {
          final data = doc.data();
          if (data is Map<String, dynamic>) {
            return UserModel.fromMap(data);
          } else {
            print('Document data is not a Map: ${data.runtimeType}');
            // Return basic user model if data format is unexpected
            if (user != null) {
              return UserModel(
                uid: user.uid,
                email: user.email!,
                profileImage: user.photoURL,
              );
            }
          }
        }
      } catch (e) {
        print('Error getting Firebase user data: $e');
        // If Firebase fails and we have current user, return basic info
        if (user != null) {
          return UserModel(
            uid: user.uid,
            email: user.email!,
            profileImage: user.photoURL,
          );
        }
      }
    } catch (e) {
      print('Error getting current user data: $e');
    }
    return null;
  }
}
