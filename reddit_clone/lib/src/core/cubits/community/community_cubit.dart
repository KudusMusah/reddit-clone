import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/common/entities/community_entity.dart';

part 'community_state.dart';

class UserCommunitiesCubit extends Cubit<UserCommunitiesState> {
  UserCommunitiesCubit() : super(UserCommunitiesInitial());

  void onUserCommunitiesSuccess(List<CommunityEntity> communities) {
    emit(UserCommunitiesSucess(communities: communities));
  }

  void onUserCommunitiesFailure() {
    emit(UserCommunitiesFailure(message: "Could not fetch users'communities"));
  }
}
