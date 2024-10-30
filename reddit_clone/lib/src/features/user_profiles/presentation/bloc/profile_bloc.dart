import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/core/enums/karma.dart';
import 'package:reddit_clone/src/features/user_profiles/domain/usecases/edit_profile_usecase.dart';
import 'package:reddit_clone/src/features/user_profiles/domain/usecases/update_user_karma_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final EditProfileUsecase _editProfileUsecase;
  final UpdateKarmaUsecase _updateKarmaUsecase;
  ProfileBloc({
    required EditProfileUsecase editProfileUsecase,
    required UpdateKarmaUsecase updateKarmaUsecase,
  })  : _editProfileUsecase = editProfileUsecase,
        _updateKarmaUsecase = updateKarmaUsecase,
        super(ProfileInitial()) {
    on<EditProfile>((onEditProfile));
    on<UpdateKarma>((onUpdateKarma));
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

  void onUpdateKarma(UpdateKarma event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final ref = await _updateKarmaUsecase(
      UpdateKarmaParams(uid: event.uid, karma: event.karma),
    );

    ref.fold(
      (l) => emit(ProfileFailure(message: l.message)),
      (r) => emit(ProfileSuccess()),
    );
  }
}
