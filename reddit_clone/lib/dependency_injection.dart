import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/src/core/cubits/app_user/app_user_cubit.dart';
import 'package:reddit_clone/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:reddit_clone/src/features/auth/data/repository/auth_repository_impl.dart';
import 'package:reddit_clone/src/features/auth/domain/repository/auth_repository.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/auth_state_changes_usecases.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/get_user_with_id_usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/sign_in_with_goole_usecase.dart';
import 'package:reddit_clone/src/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:reddit_clone/src/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
}

void _initAuth() {
  serviceLocator.registerFactory(
    () => GoogleSignIn(),
  );

  serviceLocator.registerFactory(
    () => FirebaseAuth.instance,
  );

  serviceLocator.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );

  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firestore: serviceLocator(),
      firebaseAuth: serviceLocator(),
      googleSignIn: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => SignInWithGooleUsecase(authRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );

  serviceLocator.registerFactory(
    () => AuthStateChangesUsecases(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetUserWithIdUsecase(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => SignOutUsecase(authRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      signInWithGooleUsecase: serviceLocator(),
      signOutUsecase: serviceLocator(),
      appUserCubit: serviceLocator(),
      authStateChangesUsecases: serviceLocator(),
      getUserWithIdUsecase: serviceLocator(),
    ),
  );
}
