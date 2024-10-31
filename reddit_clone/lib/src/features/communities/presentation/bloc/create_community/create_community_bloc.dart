import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';
import 'package:reddit_clone/src/core/common/entities/user_entity.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/create_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/get_community_members_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/get_query_communities_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/join_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/leave_community_usease.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/update_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/update_mods_usecase.dart';

part 'create_community_event.dart';
part 'create_community_state.dart';

class CreateCommunityBloc
    extends Bloc<CreateCommunityEvent, CreateCommunityState> {
  final CreateCommunityUsecase _createCommunityUsecase;
  final UpdateCommunityUsecase _updateCommunityUsecase;
  final GetQueryCommunitiesUsecase _getQueryCommunitiesUsecase;
  final JoinCommunityUsecase _joinCommunityUsecase;
  final LeaveCommunityUsease _leaveCommunityUsease;
  final GetCommunityMembersUsecase _getCommunityMembersUsecase;
  final UpdateModsUsecase _updateModsUsecase;

  CreateCommunityBloc({
    required CreateCommunityUsecase createCommunityUsecase,
    required UpdateCommunityUsecase updateCommunityUsecase,
    required GetQueryCommunitiesUsecase getQueryCommunitiesUsecase,
    required JoinCommunityUsecase joinCommunityUsecase,
    required LeaveCommunityUsease leaveCommunityUsease,
    required GetCommunityMembersUsecase getCommunityMembersUsecase,
    required UpdateModsUsecase updateModsUsecase,
  })  : _createCommunityUsecase = createCommunityUsecase,
        _updateCommunityUsecase = updateCommunityUsecase,
        _getQueryCommunitiesUsecase = getQueryCommunitiesUsecase,
        _joinCommunityUsecase = joinCommunityUsecase,
        _leaveCommunityUsease = leaveCommunityUsease,
        _getCommunityMembersUsecase = getCommunityMembersUsecase,
        _updateModsUsecase = updateModsUsecase,
        super(CreateCommunityInitial()) {
    on<CreateCommunity>(onCreateCommunity);
    on<UpdateCommunityEvent>(onEditCommunity);
    on<UpdateMods>(onUpdateMods);
    on<JoinCommunity>(onJoinCommunity);
    on<LeaveCommunity>(onLeaveCommunity);
    on<GetCommunityMembers>(onGetCommunityMembers);
    on<GetQueryCommunities>(onGetQueryCommunities);
    on<QueryCommunitiesFailed>((_, emit) =>
        emit(CreateCommunityFailure("An unexpected error occured")));
    on<QueryCommunitiesFetched>((event, emit) =>
        emit(GetQueryCommunitySuccess(communities: event.communities)));
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

  void onUpdateMods(
    UpdateMods event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _updateModsUsecase(
        UpdateModsParams(communityName: event.communityName, mods: event.mods));

    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) => emit(CreateCommunitySuccess()),
    );
  }

  void onJoinCommunity(
    JoinCommunity event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _joinCommunityUsecase(
      JoinCommunityParams(
        communityName: event.communityName,
        userId: event.userId,
      ),
    );

    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) => emit(CreateCommunitySuccess()),
    );
  }

  void onLeaveCommunity(
    LeaveCommunity event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _leaveCommunityUsease(
      LeaveCommunityParams(
        communityName: event.communityName,
        userId: event.userId,
      ),
    );

    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) => emit(CreateCommunitySuccess()),
    );
  }

  void onGetQueryCommunities(
    GetQueryCommunities event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _getQueryCommunitiesUsecase(
      CommunityQueryParams(query: event.query),
    );

    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) {
        r.listen(
          (communities) =>
              add(QueryCommunitiesFetched(communities: communities)),
          onError: (object) => add(QueryCommunitiesFailed()),
        );
      },
    );
  }

  void onGetCommunityMembers(
    GetCommunityMembers event,
    Emitter<CreateCommunityState> emit,
  ) async {
    emit(CreateCommunityLoading());
    final res = await _getCommunityMembersUsecase(
        GetCommunityMembersParams(communityName: event.communityName));
    res.fold(
      (l) => emit(CreateCommunityFailure(l.message)),
      (r) => emit(GetCommunityMembersSuccess(members: r)),
    );
  }
}
