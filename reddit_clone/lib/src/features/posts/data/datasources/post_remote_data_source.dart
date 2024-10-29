import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reddit_clone/src/core/error/exceptions.dart';
import 'package:reddit_clone/src/core/common/models/community_model.dart';
import 'package:reddit_clone/src/features/posts/data/models/post_model.dart';

abstract interface class PostRemoteDataSource {
  Future<void> createPost(PostModel post);
  Future<String> uploadImage(String path, String id, File image);
  Stream<List<PostModel>> fetchUserFeed(List<CommunityModel> communities);
  Future<void> deletePost(String postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  PostRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage firebaseStorage,
  })  : _firestore = firestore,
        _firebaseStorage = firebaseStorage;

  CollectionReference get _post => _firestore.collection("post");

  @override
  Future<String> uploadImage(String path, String id, File image) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw PostException(e.message ?? e.toString());
    } catch (e) {
      throw PostException(e.toString());
    }
  }

  @override
  Future<void> createPost(PostModel post) async {
    try {
      await _post.doc(post.id).set(post.toJson());
    } on FirebaseException catch (e) {
      throw PostException(e.message ?? e.toString());
    } catch (e) {
      throw PostException(e.toString());
    }
  }

  @override
  Stream<List<PostModel>> fetchUserFeed(List<CommunityModel> communities) {
    return _post
        .where(
          "communityName",
          whereIn: communities.map((e) => e.name).toList(),
        )
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

  @override
  Future<void> deletePost(String postId) async {
    try {
      print(postId);
      await _post.doc(postId).delete();
    } on FirebaseException catch (e) {
      throw PostException(e.message ?? e.toString());
    } catch (e) {
      throw PostException(e.toString());
    }
  }
}
