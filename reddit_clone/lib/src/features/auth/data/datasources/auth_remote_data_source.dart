import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/src/core/constants/constants.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  CollectionReference get users;
  Stream<UserModel> getUserWithId(String uid);
  Stream<User?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  CollectionReference get users => _firestore.collection("users");

  @override
  Stream<User?> authStateChanges() {
    try {
      return _firebaseAuth.authStateChanges();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Stream<UserModel> getUserWithId(String uid) {
    try {
      return users.doc(uid).snapshots().map(
            (e) => UserModel.fromJson(e.data() as Map<String, dynamic>),
          );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gAuth = await _googleSignIn.signIn();

      if (gAuth == null) {
        throw AuthException("An unexpected error occured");
      }

      final authCredential = await gAuth.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: authCredential.accessToken,
        idToken: authCredential.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        final userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? "No name",
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          karma: 0,
          awards: [],
          isAuthenticated: true,
        );
        await users.doc(userModel.uid).set(userModel.toJson());
      }
      return await getUserWithId(userCredential.user!.uid).first;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "An unexpected error occured");
    } catch (e) {
      if (e is AuthException) {
        throw AuthException(e.message);
      }
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? "An unexpected error occured");
    } catch (e) {
      if (e is AuthException) {
        throw AuthException(e.message);
      }
      throw AuthException(e.toString());
    }
  }
}
