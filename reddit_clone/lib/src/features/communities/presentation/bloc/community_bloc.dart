import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/features/communities/domain/usecase/create_community_usecase.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CreateCommunityUsecase _createCommunityUsecase;
  CommunityBloc({
    required CreateCommunityUsecase createCommunityUsecase,
  })  : _createCommunityUsecase = createCommunityUsecase,
        super(CommunityInitial()) {
    on<CommunityEvent>((event, emit) => emit(CommunityLoading()));
    on<CreateCommunity>(onCreateCommunity);
  }

  void onCreateCommunity(
    CreateCommunity event,
    Emitter<CommunityState> emit,
  ) async {
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
}
