import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/entities/community_entity.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/create_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/get_query_communities_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/update_community_usecase.dart';

part 'create_community_event.dart';
part 'create_community_state.dart';

class CreateCommunityBloc
    extends Bloc<CreateCommunityEvent, CreateCommunityState> {
  final CreateCommunityUsecase _createCommunityUsecase;
  final UpdateCommunityUsecase _updateCommunityUsecase;
  final GetQueryCommunitiesUsecase _getQueryCommunitiesUsecase;
  CreateCommunityBloc({
    required CreateCommunityUsecase createCommunityUsecase,
    required UpdateCommunityUsecase updateCommunityUsecase,
    required GetQueryCommunitiesUsecase getQueryCommunitiesUsecase,
  })  : _createCommunityUsecase = createCommunityUsecase,
        _updateCommunityUsecase = updateCommunityUsecase,
        _getQueryCommunitiesUsecase = getQueryCommunitiesUsecase,
        super(CreateCommunityInitial()) {
    on<CreateCommunity>(onCreateCommunity);
    on<UpdateCommunityEvent>(onEditCommunity);
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
}
