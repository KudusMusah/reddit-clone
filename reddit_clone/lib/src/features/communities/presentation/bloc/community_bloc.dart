import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/create_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/get_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/get_user_communities_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/update_community_usecase.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CreateCommunityUsecase _createCommunityUsecase;
  final GetUserCommunitiesUsecase _getUserCommunitiesUsecase;
  final UserCommunitiesCubit _userCommunitiesCubit;
  final GetCommunityUsecase _getCommunityUsecase;
  final UpdateCommunityUsecase _updateCommunityUsecase;
  CommunityBloc({
    required CreateCommunityUsecase createCommunityUsecase,
    required GetUserCommunitiesUsecase getUserCommunitiesUsecase,
    required UserCommunitiesCubit userCommunitiesCubit,
    required GetCommunityUsecase getCommunityUsecase,
    required UpdateCommunityUsecase updateCommunityUsecase,
  })  : _createCommunityUsecase = createCommunityUsecase,
        _getUserCommunitiesUsecase = getUserCommunitiesUsecase,
        _userCommunitiesCubit = userCommunitiesCubit,
        _getCommunityUsecase = getCommunityUsecase,
        _updateCommunityUsecase = updateCommunityUsecase,
        super(CommunityInitial()) {
    on<CreateCommunity>(onCreateCommunity);
    on<EditCommunityEvent>(onEditCommunity);
    on<GetUserCommunities>(onGetUserCommunities);
    on<GetCommunity>(onGetCommunity);
    on<GetCommunityDone>(
        (event, emit) => emit(GetCommunitySuccess(community: event.community)));
    on<GetCommunityFailed>(
        (event, emit) => emit(CommunityFailureState(event.message)));
  }

  void onCreateCommunity(
    CreateCommunity event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final res = await _createCommunityUsecase(
      CreateCommunityParams(
        name: event.name,
        creatorUid: event.creatorUid,
      ),
    );

    res.fold(
      (l) => emit(CommunityFailureState(l.message)),
      (r) => emit(CommunitySuccess()),
    );
  }

  void onEditCommunity(
    EditCommunityEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final res = await _updateCommunityUsecase(UpdateCommunityParams(
        community: event.community,
        profileImage: event.profileImage,
        bannerImage: event.bannerImage));

    res.fold(
      (l) => emit(CommunityFailureState(l.message)),
      (r) => emit(CommunitySuccess()),
    );
  }

  void onGetUserCommunities(
    GetUserCommunities event,
    Emitter<CommunityState> emit,
  ) async {
    final res = await _getUserCommunitiesUsecase(
      GetUserCommunitiesParams(uid: event.uid),
    );

    res.fold(
      (l) => _userCommunitiesCubit.onUserCommunitiesFailure(),
      (r) {
        r.listen(
          (communities) {
            _userCommunitiesCubit.onUserCommunitiesSuccess(communities);
          },
          onError: (object) => _userCommunitiesCubit.onUserCommunitiesFailure(),
        );
      },
    );
  }

  void onGetCommunity(
    GetCommunity event,
    Emitter<CommunityState> emit,
  ) async {
    emit(CommunityLoading());
    final res =
        await _getCommunityUsecase(GetCommunityParams(name: event.name));
    res.fold(
      (l) => add(GetCommunityFailed(l.message)),
      (r) {
        r.listen(
          (community) => add(GetCommunityDone(community)),
          onError: (object) =>
              add(GetCommunityFailed("An unexpected error occured")),
        );
      },
    );
  }
}
