import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/core/usecase/usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/auth_state_changes_usecases.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/get_user_with_id_usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/sign_in_with_goole_usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/sign_out_usecase.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGooleUsecase _signInWithGooleUsecase;
  final AppUserCubit _appUserCubit;
  final AuthStateChangesUsecases _authStateChangesUsecases;
  final GetUserWithIdUsecase _getUserWithIdUsecase;
  final SignOutUsecase _signOutUsecase;
  AuthBloc({
    required SignInWithGooleUsecase signInWithGooleUsecase,
    required AppUserCubit appUserCubit,
    required AuthStateChangesUsecases authStateChangesUsecases,
    required GetUserWithIdUsecase getUserWithIdUsecase,
    required SignOutUsecase signOutUsecase,
  })  : _signInWithGooleUsecase = signInWithGooleUsecase,
        _appUserCubit = appUserCubit,
        _authStateChangesUsecases = authStateChangesUsecases,
        _getUserWithIdUsecase = getUserWithIdUsecase,
        _signOutUsecase = signOutUsecase,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<SignInWithGoogle>(signInWithGoogle);
    on<SignOut>(signOut);
    on<GetSignedInUserData>(getSignedInUserData);
    on<GetUserData>(getUserData);

    _initializeAuthStateChanges();
  }

  Future<void> _initializeAuthStateChanges() async {
    final res = await _authStateChangesUsecases(NoParams());
    res.fold(
      (l) {
        _appUserCubit.onUserError();
      },
      (r) {
        r.listen((user) {
          if (user == null) {
            _appUserCubit.onUserLoggedOut();
          } else {
            _appUserCubit.onUserAuthenticated(user.uid);
          }
        });
      },
    );
  }

  void signInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    final res = await _signInWithGooleUsecase(NoParams());

    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) {
        _appUserCubit.onUserLoggedIn(r);
        emit(AuthSuccess());
      },
    );
  }

  void signOut(SignOut event, Emitter<AuthState> emit) async {
    final res = await _signOutUsecase(NoParams());

    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) {
        _appUserCubit.onUserLoggedOut();
        emit(AuthSuccess());
      },
    );
  }

  void getUserData(GetUserData event, Emitter<AuthState> emit) async {
    final res = await _getUserWithIdUsecase(GetUserParams(uid: event.uid));

    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(AuthSuccess()),
    );
  }

  void getSignedInUserData(
      GetSignedInUserData event, Emitter<AuthState> emit) async {
    final res = await _getUserWithIdUsecase(GetUserParams(uid: event.uid));

    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) {
        r.listen((user) {
          _appUserCubit.onUserLoggedIn(user);
        });
        emit(AuthSuccess());
      },
    );
  }
}
