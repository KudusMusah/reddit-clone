import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/error/failure.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/user_profiles/domain/repository/profile_repository.dart';

class EditProfileUsecase implements Usecase<void, EditProfileParams> {
  final ProfileRepository profileRepository;
  EditProfileUsecase({required this.profileRepository});

  @override
  Future<Either<Failure, void>> call(EditProfileParams params) async {
    return await profileRepository.editUserProfile(
      params.profile,
      params.banner,
      params.profileImage,
      params.name,
    );
  }
}

class EditProfileParams {
  final UserEntity profile;
  final File? banner;
  final File? profileImage;
  final String name;

  EditProfileParams({
    required this.profile,
    required this.banner,
    required this.profileImage,
    required this.name,
  });
}
