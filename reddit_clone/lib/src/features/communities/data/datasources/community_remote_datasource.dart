import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/features/communities/data/models/community_model.dart';

abstract interface class CommunityRemoteDatasource {
  Future<void> createCommunity(CommunityModel community);
  Stream<List<CommunityModel>> getUserCommunities(String uid);
  Stream<CommunityModel> getCommunity(String name);
  Future<String> uploadImage(String path, String id, File image);
  Future<void> updateCommunity(CommunityModel community);
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
}
