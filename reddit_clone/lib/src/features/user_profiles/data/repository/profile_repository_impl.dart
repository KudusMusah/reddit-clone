import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/common/models/user_model.dart';
import 'package:reddit_clone/src/core/enums/karma.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/mappers/user_mapper.dart';
import 'package:reddit_clone/src/core/network/internet_checker.dart';
import 'package:reddit_clone/src/features/user_profiles/data/datasources/profile_remote_datasource.dart';
import 'package:reddit_clone/src/features/user_profiles/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final InternetChecker internetChecker;
  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.internetChecker,
  });

  @override
  Future<Either<Failure, void>> editUserProfile(
    UserEntity profile,
    File? banner,
    File? profileImage,
    String name,
  ) async {
    if (!(await internetChecker.hasInternectConnection)) {
      return left(Failure("No internet connection"));
    }
    try {
      UserModel user = UserMapper.entityToModel(profile);
      if (banner != null) {
        final bannerUrl = await profileRemoteDataSource.uploadImage(
            "users/banner", profile.uid, banner);
        user = user.copyWith(banner: bannerUrl);
      }
      if (profileImage != null) {
        final profileUrl = await profileRemoteDataSource.uploadImage(
            "users/profile", profile.uid, profileImage);
        user = user.copyWith(profilePic: profileUrl);
      }
      return right(await profileRemoteDataSource
          .editUserProfile(user.copyWith(name: name)));
    } on ProfileException catch (e) {
      return left(ProfileFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserKarma(
    String uid,
    UserKarma karma,
  ) async {
    try {
      await profileRemoteDataSource.updateUserKarma(uid, karma);
      return right(null);
    } on ProfileException catch (e) {
      return left(ProfileFailure(e.message));
    }
  }
}
