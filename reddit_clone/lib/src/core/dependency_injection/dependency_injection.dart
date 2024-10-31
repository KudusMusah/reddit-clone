part of 'dependency_injection_imports.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  _initAuth();
  _initCommunity();
  _initProfile();
  _initPosts();

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
      () => const Uuid(),
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
    ..registerFactory(
      () => FetchCommunityPostsUsecase(
        communityRepository: serviceLocator(),
      ),
    )

    // Cubits
    ..registerLazySingleton(
      () => UserCommunitiesCubit(),
    )
    // Blocs
    ..registerLazySingleton(
      () => CommunityPostsBloc(
        fetchCommunityPostsUsecase: serviceLocator(),
      ),
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
    ..registerFactory(
      () => UpdateKarmaUsecase(
        profileRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => ProfileBloc(
        editProfileUsecase: serviceLocator(),
        updateKarmaUsecase: serviceLocator(),
      ),
    );
}

void _initPosts() {
  serviceLocator
    // Datasources
    ..registerFactory<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(
        firestore: serviceLocator(),
        firebaseStorage: serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<PostRepository>(
      () => PostRepositoryImpl(
        postRemoteDataSource: serviceLocator(),
        uuid: serviceLocator(),
      ),
    ) // Usecases
    ..registerFactory(
      () => CreateImagePostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CreateTextPostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CreateLinkPostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUserFeedUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeletePostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpvotePostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DownvotePostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => FetchUserPostsUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetPostWithIdUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CreateCommentUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetPostCommentsUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => AwardPostUsecase(
        postRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => PostsBloc(
        createImagePostUsecase: serviceLocator(),
        createLinkPostUsecase: serviceLocator(),
        createTextPostUsecase: serviceLocator(),
        deletePostUsecase: serviceLocator(),
        upvotePostUsecase: serviceLocator(),
        downvotePostUsecase: serviceLocator(),
        getPostWithIdUsecase: serviceLocator(),
        createCommentUsecase: serviceLocator(),
        awardPostUsecase: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => UserFeedBloc(
        getUserFeedUsecase: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => PostsCommentsBloc(
        getPostCommentsUsecase: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => UserPostsBloc(
        fetchUserPostsUsecase: serviceLocator(),
      ),
    );
}
