import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
    String? city,
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
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());

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
        final DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          final UserModel userModel = UserModel(
            uid: user.uid,
            email: user.email!,
          );

          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());

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
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUserData({
    String? name,
    String? city,
    String? profileImage,
    String? bio,
  }) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('لم يتم تسجيل الدخول');

      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (city != null) updates['city'] = city;
      if (profileImage != null) updates['profileImage'] = profileImage;
      if (bio != null) updates['bio'] = bio;

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
  }) async {
    try {
      final String uid = currentUser?.uid ?? '';
      final Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (profileImage != null) updateData['profileImage'] = profileImage;
      if (bio != null) updateData['bio'] = bio;

      await _firestore.collection('users').doc(uid).update(updateData);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
