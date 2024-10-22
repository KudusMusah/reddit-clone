import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:reddit_clone/src/core/common/models/user_model.dart';
import 'package:reddit_clone/src/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Either<Failure, Stream<User?>> authStateChanges() {
    final stream = authRemoteDataSource.authStateChanges();
    return right(stream);
  }

  @override
  Either<Failure, Stream<UserModel>> getUserWithId(String uid) {
    try {
      final stream = authRemoteDataSource.getUserWithId(uid);
      return right(stream);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<AuthFailure, UserModel>> signInWithGoogle() async {
    try {
      final user = await authRemoteDataSource.signInWithGoogle();
      return right(user);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await authRemoteDataSource.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left(AuthFailure(e.message));
    }
  }
}
