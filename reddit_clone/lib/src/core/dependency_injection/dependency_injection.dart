part of 'dependency_injection_imports.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  _initAuth();
  _initCommunity();
  _initProfile();
  serviceLocator
    ..registerLazySingleton(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton(
      () => FirebaseStorage.instance,
    )
    ..registerLazySingleton(
      () => GoogleSignIn(),
    )
    ..registerLazySingleton(
      () => FirebaseAuth.instance,
    )
    ..registerLazySingleton(
      () => sharedPreferences,
    )
    ..registerLazySingleton(
      () => ThemeCubit(
        sharedPreferences: serviceLocator(),
      ),
    );
}

void _initAuth() {
  serviceLocator
    // Datasources
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firestore: serviceLocator(),
        firebaseAuth: serviceLocator(),
        googleSignIn: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => SignInWithGooleUsecase(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => AuthStateChangesUsecases(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetUserWithIdUsecase(authRepository: serviceLocator()),
    )
    ..registerFactory(
      () => SignOutUsecase(authRepository: serviceLocator()),
    );
  // Cubits
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  // Blocs
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
    // Datasources
    ..registerFactory<CommunityRemoteDatasource>(
      () => CommunityRemoteDatasourceImpl(
        firebaseFirestore: serviceLocator(),
        firebaseStorage: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<CommunityRepository>(
      () =>
          CommunityRepositoryImpl(communityRemoteDatasource: serviceLocator()),
    )

    // Usecases
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
    ..registerFactory(
      () => GetQueryCommunitiesUsecase(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => JoinCommunityUsecase(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => LeaveCommunityUsease(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => GetCommunityMembersUsecase(communityRepository: serviceLocator()),
    )
    ..registerFactory(
      () => UpdateModsUsecase(communityRepository: serviceLocator()),
    )

    // Cubits
    ..registerLazySingleton(
      () => UserCommunitiesCubit(),
    )
    // Blocs
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
        getQueryCommunitiesUsecase: serviceLocator(),
        joinCommunityUsecase: serviceLocator(),
        leaveCommunityUsease: serviceLocator(),
        getCommunityMembersUsecase: serviceLocator(),
        updateModsUsecase: serviceLocator(),
      ),
    );
}

void _initProfile() {
  serviceLocator
    // Datasources
    ..registerFactory<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
        firestore: serviceLocator(),
        storage: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(
        profileRemoteDataSource: serviceLocator(),
      ),
    ) // Usecases
    ..registerFactory(
      () => EditProfileUsecase(
        profileRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ProfileBloc(
        editProfileUsecase: serviceLocator(),
      ),
    );
}
