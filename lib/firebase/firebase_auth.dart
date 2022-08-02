import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

import '../model/firebase_response.dart';

typedef CheckUserStat = void Function({required bool loggedIn});

class FirebaseAuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FBResponse> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        return FBResponse(
            message: 'Successfully Send verify link', status: true);
      }
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    } catch (e) {
      // print(e.toString());
    }
    return FBResponse(message: 'Something went wrong ', status: false);
  }

  Future<FBResponse> signIn({
    required String password,
    required String email,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        String message = userCredential.user!.emailVerified
            ? 'LoggedIn Successfully'
            : 'LoggedIn Successfully';
        // : 'You must verify email';
        return FBResponse(
            // message: message, status: userCredential.user!.emailVerified);
            message: message,
            status: true);
      }
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    } catch (e) {
      //
    }
    return FBResponse(message: 'Something went wrong', status: false);
  }

  Future<FBResponse> forgetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return FBResponse(
          message: 'Successfully send verify link to rest password',
          status: true);
    } on FirebaseAuthException catch (e) {
      return controlError(e);
    } catch (e) {
      //
    }
    return FBResponse(message: 'Something went wrong', status: false);
  }
 /// Not for Use --
  // bool get loggedIn => _firebaseAuth.currentUser != null;

  StreamSubscription checkUserState(CheckUserStat checkUserStat) {
    return _firebaseAuth.authStateChanges().listen((User? user) {
      checkUserStat(loggedIn: user !=null);
    });
  }

  Future<void> logeOut() async {
    await _firebaseAuth.signOut();
  }

  FBResponse controlError(FirebaseAuthException authException) {
    // print('${authException.code} : hi ');
    if (authException.code == 'email-already-in-use') {
    } else if (authException.code == 'invalid-email') {
    } else if (authException.code == 'operation-not-allowed') {
    } else if (authException.code == 'weak-password') {
    } else if (authException.code == 'wrong-password') {
    } else if (authException.code == 'user-not-found') {
    } else if (authException.code == 'invalid-email') {
    } else if (authException.code == 'user-disabled') {
    } else if (authException.code == 'auth/invalid-email') {
    } else if (authException.code == 'auth/user-not-found') {}
    return FBResponse(
        message: authException.message ?? 'Error Occurred', status: false);
  }
}
