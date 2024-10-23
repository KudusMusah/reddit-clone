import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/features/user_profiles/domain/usecases/edit_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EditProfileUsecase _editProfileUsecase;
  ProfileBloc({
    required EditProfileUsecase editProfileUsecase,
  })  : _editProfileUsecase = editProfileUsecase,
        super(ProfileInitial()) {
    on<EditProfile>((onEditProfile));
  }

  void onEditProfile(EditProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final ref = await _editProfileUsecase(EditProfileParams(
      profile: event.profile,
      banner: event.banner,
      profileImage: event.profileImage,
      name: event.name,
    ));

    ref.fold(
      (l) => emit(ProfileFailure(message: l.message)),
      (r) => emit(ProfileSuccess()),
    );
  }
}
