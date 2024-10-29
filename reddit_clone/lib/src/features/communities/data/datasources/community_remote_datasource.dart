import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reddit_clone/src/core/common/models/user_model.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/common/models/community_model.dart';
import 'package:reddit_clone/src/core/common/models/post_model.dart';

abstract interface class CommunityRemoteDatasource {
  Future<void> createCommunity(CommunityModel community);
  Stream<List<CommunityModel>> getUserCommunities(String uid);
  Stream<CommunityModel> getCommunity(String name);
  Future<String> uploadImage(String path, String id, File image);
  Future<void> updateCommunity(CommunityModel community);
  Stream<List<CommunityModel>> getQueryCommunities(String query);
  Future<void> joinCommunity(String communityName, String userId);
  Future<void> leaveCommunity(String communityName, String userId);
  Future<List<UserModel>> getCommunityMembers(String communityName);
  Future<UserModel> getUserWithId(String uid);
  Future<void> updateMods(String communityName, List<String> mods);
  Stream<List<PostModel>> fetchCommunityPosts(String communityName);
}

class CommunityRemoteDatasourceImpl implements CommunityRemoteDatasource {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  CommunityRemoteDatasourceImpl({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage firebaseStorage,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebaseStorage;

  CollectionReference get _community =>
      _firebaseFirestore.collection("communities");
  CollectionReference get _users => _firebaseFirestore.collection("users");
  CollectionReference get _post => _firebaseFirestore.collection("post");

  @override
  Future<void> createCommunity(CommunityModel community) async {
    try {
      final communityDoc = await _community.doc(community.name).get();
      if (communityDoc.exists) {
        throw CommunityException("Community with that name exits");
      }
      return _community.doc(community.name).set(community.toJson());
    } on FirebaseException catch (e) {
      throw CommunityException(e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _community
        .where("members", arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        communities.add(
          CommunityModel.fromJson(doc.data() as Map<String, dynamic>),
        );
      }
      return communities;
    });
  }

  @override
  Stream<CommunityModel> getCommunity(String name) {
    return _community.doc(name).snapshots().map(
          (e) => CommunityModel.fromJson(
            e.data() as Map<String, dynamic>,
          ),
        );
  }

  @override
  Future<String> uploadImage(String path, String id, File image) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw CommunityException(e.message ?? e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Future<void> updateCommunity(CommunityModel community) async {
    try {
      await _community.doc(community.name).update(community.toJson());
    } on FirebaseException catch (e) {
      throw CommunityException(e.message ?? e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Stream<List<CommunityModel>> getQueryCommunities(String query) {
    return _community
        .where(
          "name",
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
      (stream) {
        List<CommunityModel> communities = [];
        for (var community in stream.docs) {
          communities.add(CommunityModel.fromJson(
              community.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  @override
  Future<void> joinCommunity(String communityName, String userId) async {
    try {
      await _community.doc(communityName).update({
        "members": FieldValue.arrayUnion([userId]),
      });
    } on FirebaseException catch (e) {
      throw CommunityException(e.message ?? e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Future<void> leaveCommunity(String communityName, String userId) async {
    try {
      await _community.doc(communityName).update({
        "members": FieldValue.arrayRemove([userId]),
      });
    } on FirebaseException catch (e) {
      throw CommunityException(e.message ?? e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getCommunityMembers(String communityName) async {
    try {
      List<UserModel> membersData = [];
      final community = await _community.doc(communityName).snapshots().first;
      final membersId =
          CommunityModel.fromJson(community.data() as Map<String, dynamic>)
              .members;

      for (var member in membersId) {
        membersData.add(await getUserWithId(member));
      }
      return membersData;
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> getUserWithId(String uid) async {
    try {
      final user = await _users.doc(uid).snapshots().first;
      return UserModel.fromJson(user.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw CommunityException(e.message ?? e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Future<void> updateMods(String communityName, List<String> mods) async {
    try {
      await _community.doc(communityName).update({
        "mods": mods,
      });
    } on FirebaseException catch (e) {
      throw CommunityException(e.message ?? e.toString());
    } catch (e) {
      throw CommunityException(e.toString());
    }
  }

  @override
  Stream<List<PostModel>> fetchCommunityPosts(String communityName) {
    return _post
        .where("communityName", isEqualTo: communityName)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
      (posts) {
        List<PostModel> streamPosts = [];
        for (var e in posts.docs) {
          streamPosts.add(
            PostModel.fromJson(e.data() as Map<String, dynamic>),
          );
        }
        return streamPosts;
      },
    );
  }
}
