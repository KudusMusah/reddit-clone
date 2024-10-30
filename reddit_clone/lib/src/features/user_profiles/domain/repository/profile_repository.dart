import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/enums/karma.dart';
import 'package:reddit_clone/src/core/error/failure.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, void>> editUserProfile(
    UserEntity profile,
    File? banner,
    File? profileImage,
    String name,
  );
  Future<Either<Failure, void>> updateUserKarma(String uid, UserKarma karma);
}
