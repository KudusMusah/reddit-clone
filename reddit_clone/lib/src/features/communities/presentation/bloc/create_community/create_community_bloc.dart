import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/create_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/update_community_usecase.dart';

part 'create_community_event.dart';
part 'create_community_state.dart';

class CreateCommunityBloc
    extends Bloc<CreateCommunityEvent, CreateCommunityState> {
  final CreateCommunityUsecase _createCommunityUsecase;
  final UpdateCommunityUsecase _updateCommunityUsecase;
  CreateCommunityBloc({
    required CreateCommunityUsecase createCommunityUsecase,
    required UpdateCommunityUsecase updateCommunityUsecase,
  })  : _createCommunityUsecase = createCommunityUsecase,
        _updateCommunityUsecase = updateCommunityUsecase,
        super(CreateCommunityInitial()) {
    on<CreateCommunity>(onCreateCommunity);
    on<UpdateCommunityEvent>(onEditCommunity);
  }

  void onCreateCommunity(
    CreateCommunity event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _createCommunityUsecase(
      CreateCommunityParams(
        name: event.name,
        creatorUid: event.creatorUid,
      ),
    );

    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) => emit(CreateCommunitySuccess()),
    );
  }

  void onEditCommunity(
    UpdateCommunityEvent event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _updateCommunityUsecase(UpdateCommunityParams(
        community: event.community,
        profileImage: event.profileImage,
        bannerImage: event.bannerImage));

    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) => emit(CreateCommunitySuccess()),
    );
  }
}
