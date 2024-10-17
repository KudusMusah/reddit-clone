import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/features/auth/data/models/user_model.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Either<Failure, Stream<UserModel>> getUserWithId(String uid);
  Either<Failure, Stream<User?>> authStateChanges();
}
