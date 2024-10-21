part of 'dependency_injection_imports.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initCommunity();
  serviceLocator.registerLazySingleton(
    () => FirebaseFirestore.instance,
  );
  serviceLocator.registerLazySingleton(
    () => FirebaseStorage.instance,
  );
}

void _initAuth() {
  serviceLocator.registerFactory(
    () => GoogleSignIn(),
  );

  serviceLocator.registerFactory(
    () => FirebaseAuth.instance,
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

void _initCommunity() {
  serviceLocator
    ..registerFactory<CommunityRemoteDatasource>(
      () => CommunityRemoteDatasourceImpl(
        firebaseFirestore: serviceLocator(),
        firebaseStorage: serviceLocator(),
      ),
    )
    ..registerFactory<CommunityRepository>(
      () =>
          CommunityRepositoryImpl(communityRemoteDatasource: serviceLocator()),
    )
    ..registerFactory(
      () => CreateCommunityUsecase(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetUserCommunitiesUsecase(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetCommunityUsecase(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateCommunityUsecase(communityRepository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => UserCommunitiesCubit(),
    )
    ..registerLazySingleton(
      () => CommunityBloc(
        getUserCommunitiesUsecase: serviceLocator(),
        userCommunitiesCubit: serviceLocator(),
        getCommunityUsecase: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => CreateCommunityBloc(
        createCommunityUsecase: serviceLocator(),
        updateCommunityUsecase: serviceLocator(),
      ),
    );
}
