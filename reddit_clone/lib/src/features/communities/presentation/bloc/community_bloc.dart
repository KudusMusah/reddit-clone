import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/community/community_cubit.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/create_community_usecase.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/get_user_communities_usecase.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CreateCommunityUsecase _createCommunityUsecase;
  final GetUserCommunitiesUsecase _getUserCommunitiesUsecase;
  final UserCommunitiesCubit _userCommunitiesCubit;
  CommunityBloc({
    required CreateCommunityUsecase createCommunityUsecase,
    required GetUserCommunitiesUsecase getUserCommunitiesUsecase,
    required UserCommunitiesCubit userCommunitiesCubit,
  })  : _createCommunityUsecase = createCommunityUsecase,
        _getUserCommunitiesUsecase = getUserCommunitiesUsecase,
        _userCommunitiesCubit = userCommunitiesCubit,
        super(CommunityInitial()) {
    on<CreateCommunity>(onCreateCommunity);
    on<GetUserCommunities>(onGetUserCommunities);
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
}
